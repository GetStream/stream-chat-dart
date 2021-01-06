import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat/src/api/retry_policy.dart';
import 'package:stream_chat/src/event_type.dart';
import 'package:stream_chat/src/models/channel_model.dart';
import 'package:stream_chat/src/models/own_user.dart';
import 'package:stream_chat/version.dart';
import 'package:uuid/uuid.dart';

import 'api/channel.dart';
import 'api/connection_status.dart';
import 'api/requests.dart';
import 'api/responses.dart';
import 'api/websocket.dart';
import 'db/offline_storage.dart';
import 'exceptions.dart';
import 'models/event.dart';
import 'models/message.dart';
import 'models/user.dart';

typedef LogHandlerFunction = void Function(LogRecord record);
typedef DecoderFunction<T> = T Function(Map<String, dynamic>);
typedef TokenProvider = Future<String> Function(String userId);

/// The key used to save the userId to sharedPreferences
const String KEY_USER_ID = 'KEY_USER_ID';

/// The key used to save the token to sharedPreferences
const String KEY_TOKEN = 'KEY_TOKEN';

/// The key used to save the apiKey to sharedPreferences
const String KEY_API_KEY = 'KEY_API_KEY';

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
    this.persistenceEnabled = true,
    Duration connectTimeout = const Duration(seconds: 6),
    Duration receiveTimeout = const Duration(seconds: 6),
    Dio httpClient,
    this.showLocalNotification,
    this.backgroundKeepAlive = const Duration(minutes: 1),
    RetryPolicy retryPolicy,
  }) {
    WidgetsFlutterBinding.ensureInitialized();

    _retryPolicy ??= RetryPolicy(
      retryTimeout: (Client client, int attempt, ApiError error) =>
          Duration(seconds: 1 * attempt),
      shouldRetry: (Client client, int attempt, ApiError error) => attempt < 5,
    );

    state = ClientState(this);

    _setupLogger();
    _setupDio(httpClient, receiveTimeout, connectTimeout);

    logger.info('instantiating new client');
  }

  OfflineStorage _offlineStorage;

  /// If true chat data will persist on disk
  final bool persistenceEnabled;

  RetryPolicy _retryPolicy;

  bool _synced = false;

  /// The retry policy options getter
  RetryPolicy get retryPolicy => _retryPolicy;

  /// Method used to show a local notification while the app is in background
  /// Switching to another application will not disconnect the client immediately
  /// So, use this method to show the notification when receiving a new message via events
  final void Function(Message, ChannelModel) showLocalNotification;

  /// The amount of time that will pass before disconnecting the client in the background
  final Duration backgroundKeepAlive;

  /// Client offline database
  OfflineStorage get offlineStorage => _offlineStorage;

  /// This client state
  ClientState state;

  /// By default the Chat Client will write all messages with level Warn or Error to stdout.
  /// During development you might want to enable more logging information, you can change the default log level when constructing the client.
  ///
  /// ```dart
  /// final client = Client("stream-chat-api-key", logLevel: Level.INFO);
  /// ```
  final Level logLevel;

  /// Client specific logger instance.
  /// Refer to the class [Logger] to learn more about the specific implementation.
  final Logger logger = Logger.detached('📡');

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
  String apiKey;

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

  static const _defaultBaseURL = 'chat-us-east-1.stream-io-api.com';
  static const _tokenExpiredErrorCode = 40;
  VoidCallback _connectionStatusListener;

  final BehaviorSubject<Event> _controller = BehaviorSubject<Event>();

  /// Stream of [Event] coming from websocket connection
  /// Listen to this or use the [on] method to filter specific event types
  Stream<Event> get stream => _controller.stream;

  /// This notifies the connection status of the websocket connection.
  /// Listen to this to get notified when the websocket tries to reconnect.
  final ValueNotifier<ConnectionStatus> wsConnectionStatus =
      ValueNotifier(ConnectionStatus.disconnected);

  /// The current user token
  String token;

  /// The id of the current websocket connection
  String get connectionId => _connectionId;

  bool _anonymous = false;
  String _connectionId;
  WebSocket _ws;

  bool get _hasConnectionId => _connectionId != null;

  void _setupDio(
    Dio httpClient,
    Duration receiveTimeout,
    Duration connectTimeout,
  ) {
    logger.info('http client setup');

    this.httpClient = httpClient ?? Dio();

    String url;
    if (!baseURL.startsWith('https') && !baseURL.startsWith('http')) {
      url = Uri.https(baseURL, '').toString();
    } else {
      url = baseURL;
    }

    this.httpClient.options.baseUrl = url;
    this.httpClient.options.receiveTimeout = receiveTimeout.inMilliseconds;
    this.httpClient.options.connectTimeout = connectTimeout.inMilliseconds;
    this.httpClient.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options) async {
              options.queryParameters.addAll(_commonQueryParams);
              options.headers.addAll(_httpHeaders);

              if (_connectionId != null &&
                  (options.data is Map || options.data == null)) {
                options.data = {
                  'connection_id': _connectionId,
                  ...(options.data ?? {}),
                };
              }

              var stringData = options.data.toString();

              if (options.data is FormData) {
                final multiPart = (options.data as FormData).files[0]?.value;
                stringData =
                    '${multiPart?.filename} - ${multiPart?.contentType}';
              }

              logger.info('''
    
          method: ${options.method}
          url: ${options.uri} 
          headers: ${options.headers}
          data: $stringData
    
        ''');

              return options;
            },
            onError: _tokenExpiredInterceptor,
          ),
        );
  }

  Future<void> _tokenExpiredInterceptor(DioError err) async {
    final apiError = ApiError(
      err.response?.data,
      err.response?.statusCode,
    );

    if (apiError.code == _tokenExpiredErrorCode) {
      logger.info('token expired');

      if (tokenProvider != null) {
        httpClient.lock();
        final userId = state.user.id;

        _ws.connectionStatus.removeListener(_connectionStatusListener);

        await _disconnect();

        final newToken = await tokenProvider(userId);
        await Future.delayed(Duration(seconds: 4));
        token = newToken;

        httpClient.unlock();

        await setUser(User(id: userId), newToken);

        try {
          return await httpClient.request(
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

  Logger _detachedLogger(
    String name,
  ) {
    return Logger.detached(name)
      ..level = logLevel
      ..onRecord.listen(logHandlerFunction ?? _getDefaultLogHandler());
  }

  void _setupLogger() {
    logger.level = logLevel;

    logHandlerFunction ??= _getDefaultLogHandler();

    logger.onRecord.listen(logHandlerFunction);

    logger.info('logger setup');
  }

  /// Call this function to dispose the client
  void dispose() async {
    await _offlineStorage?.disconnect();
    await _disconnect();
    httpClient.close();
    await _controller.close();
    state.channels.values.forEach((c) => c.dispose());
    state.dispose();
  }

  Map<String, String> get _httpHeaders => {
        'Authorization': token,
        'stream-auth-type': _authType,
        'x-stream-client': _userAgent,
        'Content-Encoding': 'gzip',
      };

  /// Set the current user, this triggers a connection to the API.
  /// It returns a [Future] that resolves when the connection is setup.
  Future<Event> setUser(User user, String token) async {
    if (_connectCompleter != null && !_connectCompleter.isCompleted) {
      logger.warning('Already connecting');
      throw Exception('Already connecting');
    }

    _connectCompleter = Completer();

    logger.info('set user');
    state.user = OwnUser.fromJson(user.toJson());
    this.token = token;
    _anonymous = false;

    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(KEY_USER_ID, user.id);
    await sharedPreferences.setString(KEY_TOKEN, token);
    await sharedPreferences.setString(KEY_API_KEY, apiKey);

    return connect().then((event) {
      _connectCompleter.complete(event);
      return event;
    }).catchError((e, s) {
      _connectCompleter.completeError(e, s);
      throw e;
    });
  }

  /// Set the current user using the [tokenProvider] to fetch the token.
  /// It returns a [Future] that resolves when the connection is setup.
  Future<void> setUserWithProvider(User user) async {
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
  Stream<Event> on([
    String eventType,
    String eventType2,
    String eventType3,
    String eventType4,
  ]) =>
      stream.where((event) =>
          eventType == null ||
          (event.type != null &&
              (event.type == eventType ||
                  event.type == eventType2 ||
                  event.type == eventType3 ||
                  event.type == eventType4)));

  /// Method called to add a new event to the [_controller].
  void handleEvent(Event event) async {
    logger.info('handle new event: ${event.toJson()}');
    if (event.connectionId != null) {
      _connectionId = event.connectionId;
    }

    if (!event.isLocal) {
      if (_synced && event.createdAt != null) {
        await _offlineStorage?.updateConnectionInfo(event);
        await _offlineStorage?.updateLastSyncAt(event.createdAt);
      }
    }

    if (event.user != null) {
      state._updateUser(event.user);
    }

    if (event.me != null) {
      state.user = event.me;
    }
    _controller.add(event);
  }

  Completer<Event> _connectCompleter;

  /// Connect the client websocket
  Future<Event> connect() async {
    logger.info('connecting');
    if (wsConnectionStatus.value == ConnectionStatus.connecting) {
      logger.warning('Already connecting');
      throw Exception('Already connecting');
    }

    if (wsConnectionStatus.value == ConnectionStatus.connected) {
      logger.warning('Already connected');
      throw Exception('Already connected');
    }

    wsConnectionStatus.value = ConnectionStatus.connecting;

    if (persistenceEnabled && _offlineStorage == null) {
      _offlineStorage =
          await connectDatabase(state.user, _detachedLogger('💽'));
    }

    _ws = WebSocket(
      baseUrl: baseURL,
      user: state.user,
      connectParams: {
        'api_key': apiKey,
        'authorization': token,
        'stream-auth-type': _authType,
        'x-stream-client': _userAgent,
      },
      connectPayload: {
        'user_id': state.user.id,
        'server_determines_connection_id': true,
      },
      handler: handleEvent,
      logger: _detachedLogger('🔌'),
    );

    _connectionStatusListener = () async {
      final value = _ws.connectionStatus.value;
      wsConnectionStatus.value = value;
      handleEvent(Event(
        type: EventType.connectionChanged,
        online: value == ConnectionStatus.connected,
      ));

      if (value == ConnectionStatus.connected &&
          state.channels?.isNotEmpty == true) {
        queryChannels(filter: {
          'cid': {
            '\$in': state.channels.keys.toList(),
          },
        }).then(
          (_) async {
            await resync();
            handleEvent(Event(
              type: EventType.connectionRecovered,
              online: true,
            ));
          },
        );
      } else {
        _synced = false;
      }
    };

    _ws.connectionStatus.addListener(_connectionStatusListener);

    var event = await _offlineStorage?.getConnectionInfo();

    await _ws.connect().then((e) async {
      await _offlineStorage?.updateConnectionInfo(e);
      event = e;
      await resync();
    }).catchError((err, stacktrace) {
      logger.severe('error connecting ws', err, stacktrace);
      if (err is Map) {
        throw err;
      }
    });

    return event;
  }

  /// Get the events missed while offline to sync the offline storage
  Future<void> resync([List<String> cids]) async {
    final lastSyncAt = await offlineStorage?.getLastSyncAt();

    if (lastSyncAt == null) {
      _synced = true;
      return;
    }

    cids ??= await offlineStorage?.getChannelCids();

    if (cids?.isEmpty == true) {
      return;
    }

    try {
      final rawRes = await post('/sync', data: {
        'channel_cids': cids,
        'last_sync_at': lastSyncAt.toUtc().toIso8601String(),
      });
      logger.fine('rawRes: $rawRes');

      final res = decode<SyncResponse>(
        rawRes.data,
        SyncResponse.fromJson,
      );

      res.events.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      res.events.forEach((element) {
        logger.fine('element.type: ${element.type}');
        logger.fine('element.message.text: ${element.message?.text}');
      });

      res.events.forEach((event) {
        handleEvent(event);
      });

      await _offlineStorage?.updateLastSyncAt(DateTime.now());
      _synced = true;
    } catch (error) {
      logger.severe('Error during resync $error');
    }
  }

  String _asMap(sort) {
    return sort?.map((s) => s.toJson().toString())?.join('');
  }

  final _queryChannelsStreams = <String, Future<List<Channel>>>{};

  /// Requests channels with a given query.
  Future<List<Channel>> queryChannels({
    Map<String, dynamic> filter,
    List<SortOption> sort,
    Map<String, dynamic> options,
    PaginationParams paginationParams = const PaginationParams(limit: 10),
    int messageLimit,
    bool onlyOffline = false,
    bool waitForConnect = true,
  }) async {
    if (waitForConnect) {
      if (_connectCompleter != null && !_connectCompleter.isCompleted) {
        logger.info('awaiting connection completer');
        await _connectCompleter.future;
      }
      if (wsConnectionStatus.value != ConnectionStatus.connected) {
        throw Exception(
            'You cannot use queryChannels without an active connection. Call setUser to connect the client.');
      }
    }

    final hash = base64.encode(utf8.encode(
        '$filter${_asMap(sort)}$options${paginationParams?.toJson()}$messageLimit$onlyOffline'));
    if (_queryChannelsStreams.containsKey(hash)) {
      return _queryChannelsStreams[hash];
    }

    final newQueryChannelsStream = _doQueryChannels(
      filter: filter,
      sort: sort,
      options: options,
      paginationParams: paginationParams,
      messageLimit: messageLimit,
      onlyOffline: onlyOffline,
    ).whenComplete(() {
      _queryChannelsStreams.remove(hash);
    });

    _queryChannelsStreams[hash] = newQueryChannelsStream;

    return newQueryChannelsStream;
  }

  Future<List<Channel>> _doQueryChannels({
    @required Map<String, dynamic> filter,
    @required List<SortOption> sort,
    @required Map<String, dynamic> options,
    @required int messageLimit,
    PaginationParams paginationParams = const PaginationParams(limit: 10),
    bool onlyOffline = false,
  }) async {
    logger.info('Query channel start');
    final defaultOptions = {
      'state': true,
      'watch': true,
      'presence': false,
    };

    var payload = <String, dynamic>{
      'filter_conditions': filter,
      'sort': sort,
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

    if (onlyOffline) {
      return _queryChannelsOffline(
        filter: filter,
        sort: sort,
        paginationParams: paginationParams,
      );
    }

    try {
      final response = await get(
        '/channels',
        queryParameters: {
          'payload': jsonEncode(payload),
        },
      );

      final res = decode<QueryChannelsResponse>(
        response.data,
        QueryChannelsResponse.fromJson,
      );

      final users = res.channels
          ?.expand((channel) => channel.members.map((member) => member.user))
          ?.toList();

      if (users != null) {
        state._updateUsers(users);
      }

      logger.info('Got ${res.channels?.length} channels from api');

      if (res.channels?.isEmpty != false &&
          (paginationParams?.offset ?? 0) == 0) {
        logger.warning('''We could not find any channel for this query.
          Please make sure to take a look at the Flutter tutorial: https://getstream.io/chat/flutter/tutorial
          If your application already has users and channels, you might need to adjust your query channel as explained in the docs https://getstream.io/chat/docs/query_channels/?language=dart''');
      }

      final newChannels = Map<String, Channel>.from(state.channels ?? {});
      final channels = <Channel>[];

      if (res.channels != null) {
        for (final channelState in res.channels) {
          final channel = newChannels[channelState.channel.cid];
          if (channel != null) {
            channel.state?.updateChannelState(channelState);
            channels.add(channel);
          } else {
            final newChannel = Channel.fromState(this, channelState);
            await _offlineStorage
                ?.updateChannelState(newChannel.state.channelState);
            newChannel.state?.updateChannelState(channelState);
            newChannels[newChannel.cid] = newChannel;
            channels.add(newChannel);
          }
        }
      }

      state.channels = newChannels;

      await _offlineStorage?.updateChannelQueries(
        filter,
        res.channels.map((c) => c.channel.cid).toList(),
        paginationParams?.offset == null || paginationParams.offset == 0,
      );

      return channels;
    } catch (e) {
      if (!persistenceEnabled) {
        rethrow;
      }
      return _queryChannelsOffline(
        filter: filter,
        sort: sort,
        paginationParams: paginationParams,
      );
    }
  }

  _parseError(DioError error) {
    if (error.type == DioErrorType.RESPONSE) {
      final apiError =
          ApiError(error.response?.data, error.response?.statusCode);
      logger.severe('apiError: ${apiError.toString()}');
      return apiError;
    }

    return error;
  }

  Future<List<Channel>> _queryChannelsOffline({
    @required Map<String, dynamic> filter,
    @required List<SortOption> sort,
    PaginationParams paginationParams = const PaginationParams(limit: 10),
  }) async {
    final offlineChannels = await _offlineStorage?.getChannelStates(
          filter: filter,
          sort: sort,
          paginationParams: paginationParams,
        ) ??
        [];
    final newChannels = Map<String, Channel>.from(state.channels ?? {});
    logger.info('Got ${offlineChannels.length} channels from storage');
    final channels = offlineChannels.map((channelState) {
      final channel = newChannels[channelState.channel.cid];
      if (channel != null) {
        channel.state?.updateChannelState(channelState);
        return channel;
      } else {
        final newChannel = Channel.fromState(this, channelState);
        _offlineStorage?.updateChannelState(newChannel.state.channelState);
        newChannels[newChannel.cid] = newChannel;
        return newChannel;
      }
    }).toList();

    if (channels.isNotEmpty) {
      state.channels = newChannels;
    }
    return channels;
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
      if (j == null) {
        return null;
      }
      return decoderFunction(json.decode(j));
    } catch (error, stacktrace) {
      logger.severe('Error decoding response', error, stacktrace);
      rethrow;
    }
  }

  String get _authType => _anonymous ? 'anonymous' : 'jwt';

  // TODO: get the right version of the lib from the build toolchain
  String get _userAgent => 'stream-chat-dart-client-$PACKAGE_VERSION';

  Map<String, String> get _commonQueryParams => {
        'user_id': state.user?.id,
        'api_key': apiKey,
        'connection_id': _connectionId,
      };

  /// Set the current user with an anonymous id, this triggers a connection to the API.
  /// It returns a [Future] that resolves when the connection is setup.
  Future<Event> setAnonymousUser() async {
    if (_connectCompleter != null && !_connectCompleter.isCompleted) {
      logger.warning('Already connecting');
      throw Exception('Already connecting');
    }

    _connectCompleter = Completer();

    _anonymous = true;
    final uuid = Uuid();
    state.user = OwnUser(id: uuid.v4());

    return connect().then((event) {
      _connectCompleter.complete(event);
      return event;
    }).catchError((e, s) {
      _connectCompleter.completeError(e, s);
      throw e;
    });
  }

  /// Set the current user as guest, this triggers a connection to the API.
  /// It returns a [Future] that resolves when the connection is setup.
  Future<void> setGuestUser(User user) async {
    _anonymous = true;
    final response = await post('/guest', data: {'user': user.toJson()})
        .then((res) => decode<SetGuestUserResponse>(
            res.data, SetGuestUserResponse.fromJson))
        .whenComplete(() => _anonymous = false);
    return setUser(
      response.user,
      response.accessToken,
    );
  }

  /// Closes the websocket connection and resets the client
  /// If [flushOfflineStorage] is true the client deletes all offline user's data
  /// If [clearUser] is true the client unsets the current user
  Future<void> disconnect({
    bool flushOfflineStorage = false,
    bool clearUser = false,
  }) async {
    logger.info(
        'Disconnecting flushOfflineStorage: $flushOfflineStorage; clearUser: $clearUser');

    await _offlineStorage?.disconnect(flush: flushOfflineStorage);
    _offlineStorage = null;

    if (clearUser == true) {
      state.dispose();
      state = ClientState(this);
    }

    await _disconnect();
  }

  Future<void> _disconnect() async {
    logger.info('Client disconnecting');

    await _ws?.disconnect();
  }

  /// Requests users with a given query.
  Future<QueryUsersResponse> queryUsers({
    Map<String, dynamic> filter,
    List<SortOption> sort,
    Map<String, dynamic> options,
    PaginationParams pagination,
  }) async {
    final defaultOptions = {
      'presence': _hasConnectionId,
    };

    final payload = <String, dynamic>{
      'filter_conditions': filter ?? {},
      'sort': sort,
    };

    payload.addAll(defaultOptions);

    if (pagination != null) {
      payload.addAll(pagination.toJson());
    }

    if (options != null) {
      payload.addAll(options);
    }

    final rawRes = await get(
      '/users',
      queryParameters: {
        'payload': jsonEncode(payload),
      },
    );

    final response = decode<QueryUsersResponse>(
      rawRes.data,
      QueryUsersResponse.fromJson,
    );

    state?._updateUsers(response.users);

    return response;
  }

  /// A message search.
  Future<SearchMessagesResponse> search(
    Map<String, dynamic> filters,
    List<SortOption> sort,
    String query,
    PaginationParams paginationParams, {
    Map<String, dynamic> messageFilters,
  }) async {
    final payload = {
      'filter_conditions': filters,
      if (messageFilters != null) ...{
        'message_filter_conditions': messageFilters,
      },
      'query': query,
      'sort': sort,
    };

    if (paginationParams != null) {
      payload.addAll(paginationParams.toJson());
    }

    final response = await get('/search',
        queryParameters: {'payload': json.encode(payload)});
    return decode<SearchMessagesResponse>(
        response.data, SearchMessagesResponse.fromJson);
  }

  /// Add a device for Push Notifications.
  Future<EmptyResponse> addDevice(String id, String pushProvider) async {
    final response = await post('/devices', data: {
      'id': id,
      'push_provider': pushProvider,
    });
    return decode<EmptyResponse>(response.data, EmptyResponse.fromJson);
  }

  /// Gets a list of user devices.
  Future<ListDevicesResponse> getDevices() async {
    final response = await get('/devices');
    return decode<ListDevicesResponse>(
        response.data, ListDevicesResponse.fromJson);
  }

  /// Remove a user's device.
  Future<EmptyResponse> removeDevice(String id) async {
    final response = await delete('/devices', queryParameters: {
      'id': id,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Get a development token
  String devToken(String userId) {
    final payload = json.encode({'user_id': userId});
    final payloadBytes = utf8.encode(payload);
    final payloadB64 = base64.encode(payloadBytes);
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.$payloadB64.devtoken';
  }

  /// Returns a channel client with the given type, id and custom data.
  Channel channel(
    String type, {
    String id,
    Map<String, dynamic> extraData,
  }) {
    if (type != null &&
        id != null &&
        state.channels?.containsKey('$type:$id') == true) {
      return state.channels['$type:$id'];
    }

    return Channel(this, type, id, extraData);
  }

  /// Update or Create the given user object.
  Future<UpdateUsersResponse> updateUser(User user) async {
    return updateUsers([user]);
  }

  /// Batch update a list of users
  Future<UpdateUsersResponse> updateUsers(List<User> users) async {
    final response = await post('/users', data: {
      'users': users.asMap().map((_, u) => MapEntry(u.id, u.toJson())),
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
        'target_user_id': targetUserID,
      });
    final response = await post(
      '/moderation/ban',
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
        'target_user_id': targetUserID,
      });
    final response = await delete(
      '/moderation/ban',
      queryParameters: data,
    );
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Shadow bans a user
  Future<EmptyResponse> shadowBan(
    String targetID, [
    Map<String, dynamic> options = const {},
  ]) async {
    return banUser(targetID, {
      'shadow': true,
      ...options,
    });
  }

  /// Removes shadow ban from a user
  Future<EmptyResponse> removeShadowBan(
    String targetID, [
    Map<String, dynamic> options = const {},
  ]) async {
    return unbanUser(targetID, {
      'shadow': true,
      ...options,
    });
  }

  /// Mutes a user
  Future<EmptyResponse> muteUser(String targetID) async {
    final response = await post('/moderation/mute', data: {
      'target_id': targetID,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Unmutes a user
  Future<EmptyResponse> unmuteUser(String targetID) async {
    final response = await post('/moderation/unmute', data: {
      'target_id': targetID,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Flag a message
  Future<EmptyResponse> flagMessage(String messageID) async {
    final response = await post('/moderation/flag', data: {
      'target_message_id': messageID,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Unflag a message
  Future<EmptyResponse> unflagMessage(String messageId) async {
    final response = await post('/moderation/unflag', data: {
      'target_message_id': messageId,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Flag a user
  Future<EmptyResponse> flagUser(String userId) async {
    final response = await post('/moderation/flag', data: {
      'target_user_id': userId,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Unflag a message
  Future<EmptyResponse> unflagUser(String userId) async {
    final response = await post('/moderation/unflag', data: {
      'target_user_id': userId,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Mark all channels for this user as read
  Future<EmptyResponse> markAllRead() async {
    final response = await post('/channels/read');
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Update the given message
  Future<UpdateMessageResponse> updateMessage(
    Message message, [
    String cid,
  ]) async {
    message = message.copyWith(
      status: MessageSendingStatus.UPDATING,
      updatedAt: message.updatedAt ?? DateTime.now(),
    );

    final channel = state?.channels != null ? state?.channels[cid] : null;
    channel?.state?.addMessage(message);

    return post('/messages/${message.id}', data: {'message': message})
        .then((res) {
      final updateMessageResponse = decode(
        res?.data,
        UpdateMessageResponse.fromJson,
      );

      channel?.state?.addMessage(updateMessageResponse?.message?.copyWith(
        ownReactions: message.ownReactions,
      ));

      return updateMessageResponse;
    }).catchError((error) {
      if (error is DioError &&
          error.type != DioErrorType.RESPONSE &&
          state?.channels != null) {
        channel?.state?.retryQueue?.add([message]);
      }
      throw error;
    });
  }

  /// Deletes the given message
  Future<EmptyResponse> deleteMessage(Message message, [String cid]) async {
    if (message.status == MessageSendingStatus.FAILED) {
      state.channels[cid].state.addMessage(message.copyWith(
        type: 'deleted',
        status: MessageSendingStatus.SENT,
      ));
      return EmptyResponse();
    }

    try {
      message = message.copyWith(
        type: 'deleted',
        status: MessageSendingStatus.DELETING,
        deletedAt: message.deletedAt ?? DateTime.now(),
      );

      if (state?.channels != null) {
        state.channels[cid]?.state?.addMessage(message);
      }

      final response = await delete('/messages/${message.id}');

      if (state?.channels != null) {
        state.channels[cid]?.state
            ?.addMessage(message.copyWith(status: MessageSendingStatus.SENT));
      }

      return decode(response.data, EmptyResponse.fromJson);
    } catch (error) {
      if (error is DioError &&
          error.type != DioErrorType.RESPONSE &&
          state?.channels != null) {
        state.channels[cid]?.state?.retryQueue?.add([message]);
      }
      rethrow;
    }
  }

  /// Get a message by id
  Future<GetMessageResponse> getMessage(String messageId) async {
    final response = await get('/messages/$messageId');
    return decode(response.data, GetMessageResponse.fromJson);
  }
}

/// The class that handles the state of the channel listening to the events
class ClientState {
  final _subscriptions = <StreamSubscription>[];

  /// Creates a new instance listening to events and updating the state
  ClientState(this._client) {
    _subscriptions.addAll([
      _client
          .on()
          .where((event) => event.me != null)
          .map((e) => e.me)
          .listen((user) {
        _userController.add(user);
        if (user.totalUnreadCount != null) {
          _totalUnreadCountController.add(user.totalUnreadCount);
        }

        if (user.unreadChannels != null) {
          _unreadChannelsController.add(user.unreadChannels);
        }
      }),
      _client
          .on()
          .where((event) => event.unreadChannels != null)
          .map((e) => e.unreadChannels)
          .listen((unreadChannels) {
        _unreadChannelsController.add(unreadChannels);
      }),
      _client
          .on()
          .where((event) => event.totalUnreadCount != null)
          .map((e) => e.totalUnreadCount)
          .listen((totalUnreadCount) {
        _totalUnreadCountController.add(totalUnreadCount);
      }),
    ]);

    _listenChannelDeleted();

    _listenChannelHidden();

    _listenUserUpdated();
  }

  void _listenChannelHidden() {
    _subscriptions.add(_client.on(EventType.channelHidden).listen((event) {
      _client._offlineStorage?.deleteChannels([event.cid]);
      if (channels != null) {
        channels = channels..removeWhere((cid, ch) => cid == event.cid);
      }
    }));
  }

  void _listenUserUpdated() {
    _subscriptions.add(_client.on(EventType.userUpdated).listen((event) {
      if (event.user.id == user.id) {
        user = OwnUser.fromJson(event.user.toJson());
      }
      _updateUser(event.user);
    }));
  }

  void _listenChannelDeleted() {
    _subscriptions.add(_client
        .on(
      EventType.channelDeleted,
      EventType.notificationRemovedFromChannel,
      EventType.notificationChannelDeleted,
    )
        .listen((Event event) async {
      final eventChannel = event.channel;
      await _client._offlineStorage?.deleteChannels([eventChannel.cid]);
      if (channels != null) {
        channels = channels..remove(eventChannel.cid);
      }
    }));
  }

  final Client _client;

  /// Update user information
  set user(OwnUser user) {
    _userController.add(user);
  }

  void _updateUsers(List<User> users) {
    users?.forEach(_updateUser);
  }

  void _updateUser(User user) {
    final newUsers = {
      ...users ?? {},
      user.id: user,
    };
    _usersController.add(newUsers);
  }

  /// The current user
  OwnUser get user => _userController.value;

  /// The current user as a stream
  Stream<OwnUser> get userStream => _userController.stream;

  /// The current user
  Map<String, User> get users => _usersController.value;

  /// The current user as a stream
  Stream<Map<String, User>> get usersStream => _usersController.stream;

  /// The current unread channels count
  int get unreadChannels => _unreadChannelsController.value;

  /// The current unread channels count as a stream
  Stream<int> get unreadChannelsStream => _unreadChannelsController.stream;

  /// The current total unread messages count
  int get totalUnreadCount => _totalUnreadCountController.value;

  /// The current total unread messages count as a stream
  Stream<int> get totalUnreadCountStream => _totalUnreadCountController.stream;

  /// The current list of channels in memory as a stream
  Stream<Map<String, Channel>> get channelsStream => _channelsController.stream;

  /// The current list of channels in memory
  Map<String, Channel> get channels => _channelsController.value;

  set channels(Map<String, Channel> v) {
    _channelsController.add(v);
  }

  final BehaviorSubject<Map<String, Channel>> _channelsController =
      BehaviorSubject.seeded({});
  final BehaviorSubject<OwnUser> _userController = BehaviorSubject();
  final BehaviorSubject<Map<String, User>> _usersController =
      BehaviorSubject.seeded({});
  final BehaviorSubject<int> _unreadChannelsController = BehaviorSubject();
  final BehaviorSubject<int> _totalUnreadCountController = BehaviorSubject();

  /// Call this method to dispose this object
  void dispose() {
    _subscriptions.forEach((s) => s.cancel());
    _userController.close();
    _unreadChannelsController.close();
    _totalUnreadCountController.close();
    channels.values.forEach((c) => c.dispose());
    _channelsController.close();
  }
}
