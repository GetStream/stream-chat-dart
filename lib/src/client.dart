import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/version.dart';
import 'package:uuid/uuid.dart';

import 'api/channel.dart';
import 'api/connection_status.dart';
import 'api/requests.dart';
import 'api/responses.dart';
import 'api/websocket.dart';
import 'exceptions.dart';
import 'models/event.dart';
import 'models/message.dart';
import 'models/user.dart';

typedef LogHandlerFunction = void Function(LogRecord record);
typedef DecoderFunction<T> = T Function(Map<String, dynamic>);
typedef TokenProvider = Future<String> Function(String userId);

/// The official Dart client for Stream Chat,
/// a service for building chat applications.
/// This library can be used on any Dart project and on both mobile and web apps with Flutter.
/// You can sign up for a Stream account at https://getstream.io/chat/
///
/// The Chat client will manage API call, event handling and manage the
/// websocket connection to Stream Chat servers.
///
/// ```dart
/// final client = Client("stream-chat-api-key");
/// ```
class Client {
  /// Create a client instance with default options.
  /// You should only create the client once and re-use it across your application.
  Client(
    this.apiKey, {
    this.tokenProvider,
    this.baseURL = _defaultBaseURL,
    this.logLevel = Level.WARNING,
    this.logHandlerFunction,
    Duration connectTimeout = const Duration(seconds: 6),
    Duration receiveTimeout = const Duration(seconds: 6),
    Dio httpClient,
  }) {
    state = ClientState(this);

    _setupLogger();
    _setupDio(httpClient, receiveTimeout, connectTimeout);

    logger.info('instantiating new client');
  }

  /// This client state
  ClientState state;

  /// A map of <id, channel>
  Map<String, Channel> channels = {};

  /// By default the Chat Client will write all messages with level Warn or Error to stdout.
  /// During development you might want to enable more logging information, you can change the default log level when constructing the client.
  ///
  /// ```dart
  /// final client = Client("stream-chat-api-key", logLevel: Level.INFO);
  /// ```
  final Level logLevel;

  /// Client specific logger instance.
  /// Refer to the class [Logger] to learn more about the specific implementation.
  final Logger logger = Logger('📡');

  /// A function that has a parameter of type [LogRecord].
  /// This is called on every new log record.
  /// By default the client will use the handler returned by [_getDefaultLogHandler].
  /// Setting it you can handle the log messages directly instead of have them written to stdout,
  /// this is very convenient if you use an error tracking tool or if you want to centralize your logs into one facility.
  ///
  /// ```dart
  /// myLogHandlerFunction = (LogRecord record) {
  ///  // do something with the record (ie. send it to Sentry or Fabric)
  /// }
  ///
  /// final client = Client("stream-chat-api-key", logHandlerFunction: myLogHandlerFunction);
  ///```
  LogHandlerFunction logHandlerFunction;

  /// Your project Stream Chat api key.
  /// Find your API keys here https://getstream.io/dashboard/
  final String apiKey;

  /// Your project Stream Chat base url.
  final String baseURL;

  /// A function in which you send a request to your own backend to get a Stream Chat API token.
  /// The token will be the return value of the function.
  /// It's used by the client to refresh the token once expired or to set the user without a predefined token using [setUserWithProvider].
  final TokenProvider tokenProvider;

  /// [Dio] httpClient
  /// It's be chosen because it's easy to use and supports interesting features out of the box
  /// (Interceptors, Global configuration, FormData, File downloading etc.)
  @visibleForTesting
  Dio httpClient = Dio();

  static const _defaultBaseURL = "chat-us-east-1.stream-io-api.com";
  static const _tokenExpiredErrorCode = 40;
  VoidCallback _connectionStatusListener;

  final BehaviorSubject<Event> _controller = BehaviorSubject<Event>();

  /// Stream of [Event] coming from websocket connection
  /// Listen to this or use the [on] method to filter specific event types
  Stream<Event> get stream => _controller.stream;

  /// This notifies the connection status of the websocket connection.
  /// Listen to this to get notified when the websocket tries to reconnect.
  final ValueNotifier<ConnectionStatus> wsConnectionStatus =
      ValueNotifier(null);

  String _token;
  bool _anonymous = false;
  String _connectionId;
  WebSocket _ws;

  bool get _hasConnectionId => _connectionId != null;
  Completer _tokenExpiredCompleter;

  void _setupDio(
    Dio httpClient,
    Duration receiveTimeout,
    Duration connectTimeout,
  ) {
    logger.info('http client setup');

    this.httpClient = httpClient ?? Dio();
    this.httpClient.options.baseUrl = Uri.https(baseURL, '').toString();
    this.httpClient.options.receiveTimeout = receiveTimeout.inMilliseconds;
    this.httpClient.options.connectTimeout = connectTimeout.inMilliseconds;
    this.httpClient.interceptors.add(InterceptorsWrapper(
          onRequest: (options) async {
            if (_tokenExpiredCompleter != null) {
              await _tokenExpiredCompleter.future;
            }

            options.queryParameters.addAll(_commonQueryParams);
            options.headers.addAll(_httpHeaders);

            logger.info('''
    
          method: ${options.method}
          url: ${options.uri} 
          headers: ${options.headers}
          data: ${options.data.toString()}
    
        ''');

            return options;
          },
          onError: _tokenExpiredInterceptor,
        ));
  }

  _tokenExpiredInterceptor(DioError err) async {
    final apiError = ApiError(
      err.response?.data,
      err.response?.statusCode,
    );

    if (apiError.code == _tokenExpiredErrorCode) {
      logger.info('token expired');

      if (this.tokenProvider != null) {
        _tokenExpiredCompleter = Completer();
        final userId = state.user.id;

        _ws.connectionStatus.removeListener(_connectionStatusListener);

        await disconnect();

        final newToken = await this.tokenProvider(userId);
        await Future.delayed(Duration(seconds: 4));
        this._token = newToken;

        await setUser(User(id: userId), newToken);

        _tokenExpiredCompleter.complete();

        try {
          return await this.httpClient.request(
                err.request.path,
                cancelToken: err.request.cancelToken,
                data: err.request.data,
                onReceiveProgress: err.request.onReceiveProgress,
                onSendProgress: err.request.onSendProgress,
                queryParameters: err.request.queryParameters,
                options: err.request,
              );
        } catch (err) {
          return err;
        }
      }
    }

    return err;
  }

  LogHandlerFunction _getDefaultLogHandler() {
    final levelEmojiMapper = {
      Level.INFO.name: 'ℹ️',
      Level.WARNING.name: '⚠️',
      Level.SEVERE.name: '🚨',
    };
    return (LogRecord record) {
      print(
          '(${record.time}) ${levelEmojiMapper[record.level.name] ?? record.level.name} ${record.loggerName} ${record.message}');
      if (record.stackTrace != null) {
        print(record.stackTrace);
      }
    };
  }

  void _setupLogger() {
    Logger.root.level = logLevel;

    logHandlerFunction ??= _getDefaultLogHandler();

    logger.onRecord.listen(logHandlerFunction);

    logger.info('logger setup');
  }

  /// Call this function to dispose the client
  void dispose() async {
    await this.disconnect();
    httpClient.close();
    await _controller.close();
    channels.values.forEach((c) => c.dispose());
    state.dispose();
  }

  Map<String, String> get _httpHeaders => {
        "Authorization": _token,
        "stream-auth-type": _authType,
        "x-stream-client": _userAgent,
      };

  /// Set the current user, this triggers a connection to the API.
  /// It returns a [Future] that resolves when the connection is setup.
  Future<Event> setUser(User user, String token) async {
    state.user = user;
    _token = token;
    _anonymous = false;
    return _connect();
  }

  /// Set the current user using the [tokenProvider] to fetch the token.
  /// It returns a [Future] that resolves when the connection is setup.
  Future<Event> setUserWithProvider(User user) async {
    if (tokenProvider == null) {
      throw Exception('''
      TokenProvider must be provided in the constructor in order to use `setUserWithProvider` method.
      Use `setUser` providing a token.
      ''');
    }
    final token = await tokenProvider(user.id);
    return setUser(user, token);
  }

  /// Stream of [Event] coming from websocket connection
  /// Pass an eventType as parameter in order to filter just a type of event
  Stream<Event> on([String eventType]) =>
      stream.where((event) => eventType == null || event.type == eventType);

  /// Method called to add a new event to the [_controller].
  void handleEvent(Event event) {
    if (event.connectionId != null) {
      // ws was just reconnected
      _connectionId = event.connectionId;
    }
    _controller.add(event);
  }

  Future<Event> _connect() async {
    _ws = WebSocket(
      baseUrl: baseURL,
      user: state.user,
      connectParams: {
        "api_key": apiKey,
        "authorization": _token,
        "stream-auth-type": _authType,
      },
      connectPayload: {
        "user_id": state.user.id,
        "server_determines_connection_id": true,
      },
      handler: handleEvent,
      logger: Logger('WS'),
    );

    _connectionStatusListener = () {
      final value = _ws.connectionStatus.value;
      this.wsConnectionStatus.value = value;
    };

    _ws.connectionStatus.addListener(_connectionStatusListener);

    final connectEvent = await _ws.connect();
    _connectionId = connectEvent.connectionId;
    return connectEvent;
  }

  /// Requests channels with a given query.
  Future<List<Channel>> queryChannels({
    Map<String, dynamic> filter,
    List<SortOption> sort,
    Map<String, dynamic> options,
    PaginationParams paginationParams,
    int messageLimit,
  }) async {
    final Map<String, dynamic> defaultOptions = {
      "state": true,
      "watch": true,
      "presence": false,
    };

    Map<String, dynamic> payload = {
      "filter_conditions": filter,
      "sort": sort,
      "user_details": state.user,
    };

    if (messageLimit != null) {
      payload['message_limit'] = messageLimit;
    }

    payload.addAll(defaultOptions);

    if (options != null) {
      payload.addAll(options);
    }

    if (paginationParams != null) {
      payload.addAll(paginationParams.toJson());
    }

    final response = await get(
      "/channels",
      queryParameters: {
        "payload": jsonEncode(payload),
      },
    );

    final newChannels = decode<QueryChannelsResponse>(
      response.data,
      QueryChannelsResponse.fromJson,
    )?.channels?.map((channelState) {
      if (channels.containsKey(channelState.channel.id)) {
        final client = channels[channelState.channel.id];
        client.state.updateChannelState(channelState);
      } else {
        channels[channelState.channel.id] =
            Channel.fromState(this, channelState);
      }

      return channels[channelState.channel.id];
    })?.toList();

    return newChannels;
  }

  _parseError(DioError error) {
    if (error.type == DioErrorType.RESPONSE) {
      return ApiError(error.response?.data, error.response?.statusCode);
    }

    return error;
  }

  /// Handy method to make http GET request with error parsing.
  Future<Response<String>> get(
    String path, {
    Map<String, dynamic> queryParameters,
  }) async {
    try {
      final response = await httpClient.get<String>(
        path,
        queryParameters: queryParameters,
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http POST request with error parsing.
  Future<Response<String>> post(
    String path, {
    dynamic data,
  }) async {
    try {
      final response = await httpClient.post<String>(path, data: data);
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http DELETE request with error parsing.
  Future<Response<String>> delete(
    String path, {
    Map<String, dynamic> queryParameters,
  }) async {
    try {
      final response = await httpClient.delete<String>(path,
          queryParameters: queryParameters);
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http PATCH request with error parsing.
  Future<Response<String>> patch(
    String path, {
    Map<String, dynamic> queryParameters,
    dynamic data,
  }) async {
    try {
      final response = await httpClient.patch<String>(
        path,
        queryParameters: queryParameters,
        data: data,
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http PUT request with error parsing.
  Future<Response<String>> put(
    String path, {
    Map<String, dynamic> queryParameters,
    dynamic data,
  }) async {
    try {
      final response = await httpClient.put<String>(
        path,
        queryParameters: queryParameters,
        data: data,
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Used to log errors and stacktrace in case of bad json deserialization
  T decode<T>(String j, DecoderFunction<T> decoderFunction) {
    try {
      return decoderFunction(json.decode(j));
    } catch (error, stacktrace) {
      logger.severe('Error decoding response', error, stacktrace);
      rethrow;
    }
  }

  String get _authType => _anonymous ? 'anonymous' : 'jwt';

  // TODO: get the right version of the lib from the build toolchain
  String get _userAgent => "stream_chat_dart-client-$PACKAGE_VERSION";

  Map<String, String> get _commonQueryParams => {
        "user_id": state.user?.id,
        "api_key": apiKey,
        "connection_id": _connectionId,
      };

  /// Set the current user with an anonymous id, this triggers a connection to the API.
  /// It returns a [Future] that resolves when the connection is setup.
  Future<Event> setAnonymousUser() async {
    this._anonymous = true;
    final uuid = Uuid();
    state.user = User(id: uuid.v4());
    return _connect();
  }

  /// Set the current user as guest, this triggers a connection to the API.
  /// It returns a [Future] that resolves when the connection is setup.
  Future<Event> setGuestUser(User user) async {
    _anonymous = true;
    final response = await post("/guest", data: {"user": user.toJson()})
        .then((res) => decode<SetGuestUserResponse>(
            res.data, SetGuestUserResponse.fromJson))
        .whenComplete(() => _anonymous = false);
    return setUser(response.user, response.accessToken);
  }

  /// Closes the websocket connection and resets the client
  Future<void> disconnect() async {
    logger.info('Client disconnecting');

    this._anonymous = false;
    this._connectionId = null;
    await this._ws.disconnect();
    this._token = null;
    state.user = null;
  }

  /// Requests users with a given query.
  Future<QueryUsersResponse> queryUsers(
    Map<String, dynamic> filter,
    List<SortOption> sort,
    Map<String, dynamic> options,
  ) async {
    final Map<String, dynamic> defaultOptions = {
      "presence": this._hasConnectionId,
    };

    Map<String, dynamic> payload = {
      "filter_conditions": filter ?? {},
      "sort": sort,
    };

    payload.addAll(defaultOptions);

    if (options != null) {
      payload.addAll(options);
    }

    final response = await get(
      "/users",
      queryParameters: {
        "payload": jsonEncode(payload),
      },
    );
    return decode<QueryUsersResponse>(
      response.data,
      QueryUsersResponse.fromJson,
    );
  }

  /// A message search.
  Future<SearchMessagesResponse> search(
    Map<String, dynamic> filters,
    List<SortOption> sort,
    String query,
    PaginationParams paginationParams,
  ) async {
    final payload = {
      'filter_conditions': filters,
      'query': query,
      'sort': sort,
    };

    if (paginationParams != null) {
      payload.addAll(paginationParams.toJson());
    }

    final response = await get("/search",
        queryParameters: {'payload': json.encode(payload)});
    return decode<SearchMessagesResponse>(
        response.data, SearchMessagesResponse.fromJson);
  }

  /// Add a device for Push Notifications.
  Future<EmptyResponse> addDevice(String id, String pushProvider) async {
    final response = await post("/devices", data: {
      "id": id,
      "push_provider": pushProvider,
    });
    return decode<EmptyResponse>(response.data, EmptyResponse.fromJson);
  }

  /// Gets a list of user devices.
  Future<ListDevicesResponse> getDevices() async {
    final response = await get("/devices");
    return decode<ListDevicesResponse>(
        response.data, ListDevicesResponse.fromJson);
  }

  /// Remove a user's device.
  Future<EmptyResponse> removeDevice(String id) async {
    final response = await delete("/devices", queryParameters: {
      "id": id,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Get a development token
  String devToken(String userId) {
    final payload = json.encode({"user_id": userId});
    final payloadBytes = utf8.encode(payload);
    final payloadB64 = base64.encode(payloadBytes);
    return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.$payloadB64.devtoken";
  }

  /// Returns a channel client with the given type, id and custom data.
  Channel channel(
    String type, {
    String id,
    Map<String, dynamic> extraData,
  }) {
    final channel = Channel(this, type, id, extraData);

    channels[id] = channel;

    return channel;
  }

  /// Update or Create the given user object.
  Future<UpdateUsersResponse> updateUser(User user) async {
    return updateUsers([user]);
  }

  /// Batch update a list of users
  Future<UpdateUsersResponse> updateUsers(List<User> users) async {
    final response = await post("/users", data: {
      "users": users.asMap().map((_, u) => MapEntry(u.id, u.toJson())),
    });
    return decode<UpdateUsersResponse>(
      response.data,
      UpdateUsersResponse.fromJson,
    );
  }

  /// Bans a user from all channels
  Future<EmptyResponse> banUser(
    String targetUserID, [
    Map<String, dynamic> options = const {},
  ]) async {
    final data = Map<String, dynamic>.from(options)
      ..addAll({
        "target_user_id": targetUserID,
      });
    final response = await post(
      "/moderation/ban",
      data: data,
    );
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Remove global ban for a user
  Future<EmptyResponse> unbanUser(
    String targetUserID, [
    Map<String, dynamic> options = const {},
  ]) async {
    final data = Map<String, dynamic>.from(options)
      ..addAll({
        "target_user_id": targetUserID,
      });
    final response = await delete(
      "/moderation/ban",
      queryParameters: data,
    );
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Mutes a user
  Future<EmptyResponse> muteUser(String targetID) async {
    final response = await post("/moderation/mute", data: {
      "target_id": targetID,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Unmutes a user
  Future<EmptyResponse> unmuteUser(String targetID) async {
    final response = await post("/moderation/unmute", data: {
      "target_id": targetID,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Flag a message
  Future<EmptyResponse> flagMessage(String messageID) async {
    final response = await post("/moderation/flag", data: {
      "target_message_id": messageID,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Unflag a message
  Future<EmptyResponse> unflagMessage(String messageId) async {
    final response = await post("/moderation/unflag", data: {
      "target_message_id": messageId,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Flag a user
  Future<EmptyResponse> flagUser(String userId) async {
    final response = await post("/moderation/flag", data: {
      "target_user_id": userId,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Unflag a message
  Future<EmptyResponse> unflagUser(String userId) async {
    final response = await post("/moderation/unflag", data: {
      "target_user_id": userId,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Mark all channels for this user as read
  Future<EmptyResponse> markAllRead() async {
    final response = await post("/channels/read");
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Update the given message
  Future<UpdateMessageResponse> updateMessage(Message message) async {
    return post("/messages/${message.id}", data: {'message': message})
        .then((res) => decode(res.data, UpdateMessageResponse.fromJson));
  }

  /// Deletes the given message
  Future<EmptyResponse> deleteMessage(String messageId) async {
    final response = await delete("/messages/$messageId");
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Get a message by id
  Future<GetMessageResponse> getMessage(String messageId) async {
    final response = await get("/messages/$messageId");
    return decode(response.data, GetMessageResponse.fromJson);
  }
}

/// The class that handles the state of the channel listening to the events
class ClientState {
  /// Creates a new instance listening to events and updating the state
  ClientState(this._client) {
    _client
        .on()
        .where((event) => event.me != null)
        .map((e) => e.me)
        .listen((user) {
      _userController.add(user);
    });

    _client
        .on()
        .where((event) => event.unreadChannels != null)
        .map((e) => e.unreadChannels)
        .listen((unreadChannels) {
      _unreadChannelsController.add(unreadChannels);
    });

    _client
        .on()
        .where((event) => event.totalUnreadCount != null)
        .map((e) => e.totalUnreadCount)
        .listen((totalUnreadCount) {
      _totalUnreadCountController.add(totalUnreadCount);
    });
  }

  final Client _client;

  /// Update user information
  set user(User user) {
    _userController.add(user);
  }

  /// The current user
  User get user => _userController.value;

  /// The current user as a stream
  Stream<User> get userStream => _userController.stream;

  /// The current unread channels count
  int get unreadChannels => _unreadChannelsController.value;

  /// The current unread channels count as a stream
  Stream<int> get unreadChannelsStream => _unreadChannelsController.stream;

  /// The current total unread messages count
  int get totalUnreadCount => _totalUnreadCountController.value;

  /// The current total unread messages count as a stream
  Stream<int> get totalUnreadCountStream => _totalUnreadCountController.stream;

  BehaviorSubject<User> _userController = BehaviorSubject();
  BehaviorSubject<int> _unreadChannelsController = BehaviorSubject();
  BehaviorSubject<int> _totalUnreadCountController = BehaviorSubject();

  /// Call this method to dispose this object
  void dispose() {
    _userController.close();
    _unreadChannelsController.close();
    _totalUnreadCountController.close();
  }
}
