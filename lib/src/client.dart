import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
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

class Client {
  static const defaultBaseURL = "chat-us-east-1.stream-io-api.com";

  final Logger logger = Logger('HTTP');
  final Level logLevel;
  final String apiKey;
  final String baseURL;
  Dio httpClient = Dio();

  LogHandlerFunction _logHandlerFunction;

  final StreamController<Event> _controller =
      StreamController<Event>.broadcast();

  Stream<Event> get stream => _controller.stream;

  String _token;
  User user;
  bool _anonymous = false;
  String _connectionId;
  WebSocket _ws;

  bool get hasConnectionId => _connectionId != null;

  ValueNotifier<ConnectionStatus> wsConnectionStatus;

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
    logger.info('instantiating new client');
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
              '(${record.time}) ${record.level.name}: <${record.loggerName}> ${record.message}');
          if (record.stackTrace != null) {
            print(record.stackTrace);
          }
        };
    logger.onRecord.listen(_logHandlerFunction);
  }

  void dispose() {
    httpClient.close();
    _controller.close();
  }

  Map<String, String> get httpHeaders => {
        "Authorization": _token,
        "stream-auth-type": authType,
        "x-stream-client": userAgent,
      };

  Future<Event> setUser(User user, String token) {
    this.user = user;
    _token = token;
    _anonymous = false;
    return connect();
  }

  Stream<Event> on(String eventType) =>
      stream.where((event) => eventType == null || event.type == eventType);

  void handleEvent(Event event) {
    if (event.connectionId != null) {
      _connectionId = event.connectionId;
    }
    _controller.add(event);
  }

  Future<Event> connect() async {
    _ws = WebSocket(
      baseUrl: baseURL,
      user: user,
      connectParams: {
        "api_key": apiKey,
        "authorization": _token,
        "stream-auth-type": authType,
      },
      connectPayload: {
        "user_id": user.id,
        "server_determines_connection_id": true,
      },
      handler: handleEvent,
      logger: Logger('WS'),
    );

    wsConnectionStatus = _ws.connectionStatus;

    final connectEvent = await _ws.connect();
    _connectionId = connectEvent.connectionId;
    return connectEvent;
  }

  Future<QueryChannelsResponse> queryChannels({
    Map<String, dynamic> filter,
    List<SortOption> sort,
    Map<String, dynamic> options,
    PaginationParams paginationParams,
  }) async {
    final Map<String, dynamic> defaultOptions = {
      "state": true,
      "watch": true,
      "presence": false,
    };

    Map<String, dynamic> payload = {
      "filter_conditions": filter,
      "sort": sort,
      "user_details": this.user,
    };

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
    return decode<QueryChannelsResponse>(
      response.data,
      QueryChannelsResponse.fromJson,
    );
  }

  void _parseError(DioError error) {
    if (error.type == DioErrorType.RESPONSE) {
      throw ApiError(error.response?.data, error.response?.statusCode);
    }

    throw error;
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
      _parseError(error);
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
      _parseError(error);
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
      _parseError(error);
    }
  }

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
      _parseError(error);
    }
  }

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
      _parseError(error);
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

  String get authType => _anonymous ? 'anonymous' : 'jwt';

  // TODO: get the right version of the lib from the build toolchain
  String get userAgent => "stream_chat_dart-client-0.0.1";

  Map<String, String> get commonQueryParams => {
        "user_id": user?.id,
        "api_key": apiKey,
        "connection_id": _connectionId,
      };

  Future<Event> setAnonymousUser() async {
    this._anonymous = true;
    final uuid = Uuid();
    this.user = User(id: uuid.v4());
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
  Future<void> disconnect() async {
    this._anonymous = false;
    this._connectionId = null;
    await this._ws.disconnect();
    this._token = null;
    this.user = null;
  }

  Future<QueryUsersResponse> queryUsers(
    Map<String, dynamic> filter,
    List<SortOption> sort,
    Map<String, dynamic> options,
  ) async {
    final Map<String, dynamic> defaultOptions = {
      "presence": this.hasConnectionId,
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

  String devToken(String userId) {
    final payload = json.encode({"user_id": userId});
    final payloadBytes = utf8.encode(payload);
    final payloadB64 = base64.encode(payloadBytes);
    return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.$payloadB64.devtoken";
  }

  ChannelClient channel(
    String type, {
    String id,
    Map<String, dynamic> data,
  }) {
    return ChannelClient(this, type, id, data);
  }

  Future<UpdateUsersResponse> updateUser(User user) async {
    final response = await post("/users", data: {
      "users": {user.id: user.toJson()},
    });
    return decode<UpdateUsersResponse>(
        response.data, UpdateUsersResponse.fromJson);
  }

  // TODO
//  Future<UpdateUsersResponse> updateUsers(User user) async {
//    final response = await post("/users", data: {
//      "users": {user.id: user.toJson()},
//    });
//    return decode<UpdateUsersResponse>(
//        response.data, UpdateUsersResponse.fromJson);
//  }

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

  Future<EmptyResponse> unflagMessage(String messageId) async {
    final response = await post("/moderation/unflag", data: {
      "target_message_id": messageId,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> markAllRead() async {
    final response = await post("/channels/read");
    return decode(response.data, EmptyResponse.fromJson);
  }

  Future<UpdateMessageResponse> updateMessage(Message message) async {
    return post("/messages/${message.id}", data: {'message': message})
        .then((res) => decode(res.data, UpdateMessageResponse.fromJson));
  }

  Future<EmptyResponse> deleteMessage(String messageId) async {
    final response = await delete("/messages/$messageId");
    return decode(response.data, EmptyResponse.fromJson);
  }

  Future<GetMessageResponse> getMessage(String messageId) async {
    final response = await get("/messages/$messageId");
    return decode(response.data, GetMessageResponse.fromJson);
  }
}
