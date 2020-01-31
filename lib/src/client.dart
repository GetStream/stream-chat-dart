import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:uuid/uuid.dart';
import 'api/channel.dart';
import 'exceptions.dart';
import 'models/event.dart';
import 'api/requests.dart';
import 'api/responses.dart';
import 'models/message.dart';
import 'models/user.dart';
import 'api/websocket.dart';

typedef LogHandlerFunction = void Function(LogRecord record);
typedef DecoderFunction<T> = T Function(Map<String, dynamic>);

class Client {
  static const defaultBaseURL = "chat-us-east-1.stream-io-api.com";

  final Logger logger = Logger('HTTP');
  final Level logLevel;
  final String apiKey;
  final String baseURL;
  Dio httpClient = Dio();

  LogHandlerFunction _logHandlerFunction;

  LogHandlerFunction get logHandlerFunction => _logHandlerFunction;

  final _controller = StreamController<Event>.broadcast();

  Stream get stream => _controller.stream;

  String _token;
  User _user;
  bool _anonymous = false;
  String _connectionId;
  WebSocket _ws;

  bool get hasConnectionId => _connectionId != null;

  Client(
    this.apiKey, {
    this.baseURL = defaultBaseURL,
    this.logLevel = Level.WARNING,
    LogHandlerFunction logHandlerFunction,
    Duration connectTimeout = const Duration(seconds: 6),
    Duration receiveTimeout = const Duration(seconds: 6),
    Dio httpClient,
  }) {
    _setupLogger(logHandlerFunction);
    _setupDio(httpClient, receiveTimeout, connectTimeout);
  }

  void _setupDio(
    Dio httpClient,
    Duration receiveTimeout,
    Duration connectTimeout,
  ) {
    this.httpClient = httpClient ?? Dio();
    this.httpClient.options.baseUrl = Uri.https(baseURL, '').toString();
    this.httpClient.options.receiveTimeout = receiveTimeout.inMilliseconds;
    this.httpClient.options.connectTimeout = connectTimeout.inMilliseconds;
    this.httpClient.interceptors.add(InterceptorsWrapper(
      onRequest: (options) async {
        logger.info('''
    
          method: ${options.method}
          url: ${options.uri} 
          headers: ${options.headers}
          data: ${options.data.toString()}
    
        ''');
        options.queryParameters.addAll(commonQueryParams);
        options.headers.addAll(httpHeaders);
        return options;
      },
    ));
  }

  void _setupLogger(LogHandlerFunction logHandlerFunction) {
    Logger.root.level = logLevel;

    _logHandlerFunction = logHandlerFunction ??
        (LogRecord record) {
          print(
              '(${record.time}) ${record.level.name}: ${record.loggerName} | ${record.message}');
          if (record.stackTrace != null) {
            print(record.stackTrace);
          }
        };
    logger.onRecord.listen(_logHandlerFunction);
  }

  void dispose(filename) {
    httpClient.close();
    _controller.close();
  }

  Map<String, String> get httpHeaders => {
        "Authorization": _token,
        "stream-auth-type": _getAuthType(),
        "x-stream-client": getUserAgent(),
      };

  Future<Event> setUser(User user, String token) {
    _user = user;
    _token = token;
    _anonymous = false;
    return connect();
  }

  Stream<Event> on(String eventType) =>
      stream.where((event) => eventType == null || event.type == eventType);

  void handleEvent(Event event) => _controller.add(event);

  Future<Event> connect() async {
    _ws = WebSocket(
      baseUrl: baseURL,
      user: _user,
      connectParams: {
        "api_key": apiKey,
        "authorization": _token,
        "stream-auth-type": _getAuthType(),
      },
      connectPayload: {
        "user_id": _user.id,
        "server_determines_connection_id": true,
      },
      handler: handleEvent,
      logger: Logger('ws')..onRecord.listen(_logHandlerFunction),
    );

    final connectEvent = await _ws.connect();
    _connectionId = connectEvent.connectionId;
    return connectEvent;
  }

  Future<QueryChannelsResponse> queryChannels(
    Map<String, dynamic> filter,
    List<SortOption> sort,
    Map<String, dynamic> options,
  ) async {
    final Map<String, dynamic> defaultOptions = {
      "state": true,
      "watch": true,
      "presence": false,
    };

    Map<String, dynamic> payload = {
      "filter_conditions": filter,
      "sort": sort,
      "user_details": this._user,
    };

    payload.addAll(defaultOptions);

    if (options != null) {
      payload.addAll(options);
    }

    final response = await get(
      "/channels",
      queryParameters: {
        "payload": jsonEncode(payload),
      },
    );
    return decode<QueryChannelsResponse>(
      response.data,
      QueryChannelsResponse.fromJson,
    );
  }

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
      throw ApiError.fromDioError(error);
    }
  }

  Future<Response<String>> post(
    String path, {
    dynamic data,
  }) async {
    try {
      final response = await httpClient.post<String>(path, data: data);
      return response;
    } on DioError catch (error) {
      throw ApiError.fromDioError(error);
    }
  }

  Future<Response<String>> delete(
    String path, {
    Map<String, dynamic> queryParameters,
  }) async {
    try {
      final response = await httpClient.delete<String>(path,
          queryParameters: queryParameters);
      return response;
    } on DioError catch (error) {
      throw ApiError.fromDioError(error);
    }
  }

  Future<Response<String>> patch(
    String path, {
    Map<String, dynamic> queryParameters,
    dynamic data,
  }) async {
    try {
      final response = await httpClient.delete<String>(
        path,
        queryParameters: queryParameters,
        data: data,
      );
      return response;
    } on DioError catch (error) {
      throw ApiError.fromDioError(error);
    }
  }

  Future<Response<String>> put(
    String path, {
    Map<String, dynamic> queryParameters,
    dynamic data,
  }) async {
    try {
      final response = await httpClient.delete<String>(
        path,
        queryParameters: queryParameters,
        data: data,
      );
      return response;
    } on DioError catch (error) {
      throw ApiError.fromDioError(error);
    }
  }

  // Used to log errors and stacktrace in case of bad json deserialization
  T decode<T>(String j, DecoderFunction<T> decoderFunction) {
    try {
      return decoderFunction(json.decode(j));
    } catch (error, stacktrace) {
      logger.severe('Error decoding response', error, stacktrace);
      rethrow;
    }
  }

  _getAuthType() => _anonymous ? 'anonymous' : 'jwt';

  // TODO: get the right version of the lib from the build toolchain
  getUserAgent() => "stream_chat_dart-client-0.0.1";

  Map<String, String> get commonQueryParams => {
        "user_id": _user?.id,
        "api_key": apiKey,
        "connection_id": _connectionId,
      };

  Future<Event> setAnonymousUser() async {
    this._anonymous = true;
    final uuid = Uuid();
    this._user = User(id: uuid.v4());
    return connect();
  }

  Future<Event> setGuestUser(User user) async {
    _anonymous = true;
    final response = await post("/guest", data: {"user": user.toJson()})
        .then((res) => decode<SetGuestUserResponse>(
            res.data, SetGuestUserResponse.fromJson))
        .whenComplete(() => _anonymous = false);
    return setUser(response.user, response.accessToken);
  }

  // TODO disconnect
  Future<dynamic> disconnect() async => null;

  Future<QueryUsersResponse> queryUsers(
    Map<String, dynamic> filter,
    List<SortOption> sort,
    Map<String, dynamic> options,
  ) async {
    final Map<String, dynamic> defaultOptions = {
      "presence": this.hasConnectionId,
    };

    Map<String, dynamic> payload = {
      "filter_conditions": filter,
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

    payload.addAll(paginationParams.toJson());

    final response = await httpClient
        .get<String>("/search", queryParameters: {'payload': payload});
    return decode<SearchMessagesResponse>(
        response.data, SearchMessagesResponse.fromJson);
  }

  Future<EmptyResponse> addDevice(String id, String pushProvider) async {
    final response = await post("/devices", data: {
      "id": id,
      "push_provider": pushProvider,
    });
    return decode<EmptyResponse>(response.data, EmptyResponse.fromJson);
  }

  Future<ListDevicesResponse> getDevices() async {
    final response = await get("/devices");
    return decode<ListDevicesResponse>(
        response.data, ListDevicesResponse.fromJson);
  }

  Future<EmptyResponse> removeDevice(String id) async {
    final response = await delete("/devices", queryParameters: {
      "id": id,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  Channel channel(
    String type, {
    String id,
    Map<String, dynamic> custom,
  }) {
    return Channel(this, type, id, custom);
  }

  Future<UpdateUsersResponse> updateUser(User user) async {
    final response = await post("/users", data: {
      "users": {user.id: user.toJson()},
    });
    return decode<UpdateUsersResponse>(
        response.data, UpdateUsersResponse.fromJson);
  }

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

  Future<EmptyResponse> muteUser(String targetID) async {
    final response = await post("/moderation/mute", data: {
      "target_id": targetID,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> unmuteUser(String targetID) async {
    final response = await post("/moderation/unmute", data: {
      "target_id": targetID,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> flagMessage(String messageID) async {
    final response = await post("/moderation/flag", data: {
      "target_message_id": messageID,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> unflagMessage(String messageID) async {
    final response = await post("/moderation/unflag", data: {
      "target_message_id": messageID,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> markAllRead() async {
    final response = await post("/channels/read");
    return decode(response.data, EmptyResponse.fromJson);
  }

  Future<UpdateMessageResponse> updateMessage(Message message) async {
    return post("/messages/${message.id}")
        .then((res) => decode(res.data, UpdateMessageResponse.fromJson));
  }

  Future<EmptyResponse> deleteMessage(String messageID) async {
    final response = await delete("/messages/$messageID");
    return decode(response.data, EmptyResponse.fromJson);
  }

  Future<GetMessageResponse> getMessage(String messageID) async {
    final response = await get("/messages/$messageID");
    return decode(response.data, GetMessageResponse.fromJson);
  }
}
