import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:stream_chat_dart/api/channel.dart';
import 'exceptions.dart';
import 'models/event.dart';
import 'api/requests.dart';
import 'api/responses.dart';
import 'models/message.dart';
import 'models/user.dart';
import 'api/websocket.dart';

typedef void LogHandlerFunction(LogRecord record);

class Client {
  static const defaultBaseURL = "chat-us-east-1.stream-io-api.com";

  final Logger logger = Logger('HTTP');
  final Level logLevel;
  final String apiKey;
  final String baseURL;
  final Dio dioClient = Dio();

  final _controller = StreamController<Event>.broadcast();

  Stream get stream => _controller.stream;

  String _token;
  User _user;
  bool _anonymous;
  String _connectionId;
  WebSocket _ws;

  Client(
    this.apiKey, {
    this.baseURL = defaultBaseURL,
    this.logLevel = Level.WARNING,
    LogHandlerFunction logHandlerFunction,
    Duration connectTimeout = const Duration(seconds: 6),
    Duration receiveTimeout = const Duration(seconds: 6),
  }) {
    _setupLogger(logHandlerFunction);
    _setupDio(receiveTimeout, connectTimeout);
  }

  void _setupDio(Duration receiveTimeout, Duration connectTimeout) {
    dioClient.options.baseUrl = 'https://$baseURL';
    dioClient.options.receiveTimeout = receiveTimeout.inMilliseconds;
    dioClient.options.connectTimeout = connectTimeout.inMilliseconds;
    dioClient.interceptors.add(InterceptorsWrapper(
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
      onError: (error) async {
        logger.severe(error.message, error);
        return error;
      },
      onResponse: (response) async {
        if (response.statusCode != 200) {
          return dioClient.reject(ApiError(
            response.data,
            response.statusCode,
          ));
        }
        return response;
      },
    ));
  }

  void _setupLogger(LogHandlerFunction logHandlerFunction) {
    Logger.root.level = logLevel;
    if (logHandlerFunction == null) {
      logHandlerFunction = (LogRecord record) {
        print(
            '(${record.time}) ${record.level.name}: ${record.loggerName} | ${record.message}');
        if (record.stackTrace != null) {
          print(record.stackTrace);
        }
      };
    }
    logger.onRecord.listen(logHandlerFunction);
  }

  void dispose(filename) {
    dioClient.close();
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
        baseURL,
        _user,
        {
          "api_key": apiKey,
          "authorization": _token,
          "stream-auth-type": _getAuthType(),
        },
        {
          "user_id": _user.id,
          "server_determines_connection_id": true,
        },
        handleEvent);

    var connectionFuture = _ws.connect();
    var connectEvent = await connectionFuture;
    _connectionId = connectEvent.connectionID;
    return connectionFuture;
  }

  Future<QueryChannelsResponse> queryChannels(
    QueryFilter filter,
    List<SortOption> sort,
    Map<String, dynamic> options,
  ) async {
    logger.info(
        'queryChannels - filter: ${json.encode(filter)} - sort: ${json.encode(sort)} - options: $options');
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

    final response = await dioClient.get<String>(
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

  // Used to log errors and stacktrace in case of bad json deserialization
  decode<T>(String j, T Function(Map<String, dynamic>) decoderFunction) {
    try {
      return decoderFunction(json.decode(j));
    } catch (error, stacktrace) {
      logger.severe('Error decoding response', error, stacktrace);
      throw error;
    }
  }

  _getAuthType() => _anonymous ? 'anonymous' : 'jwt';

  // TODO: get the right version of the lib from the build toolchain
  getUserAgent() => "stream_chat_dart-client-0.0.1";

  Map<String, String> get commonQueryParams => {
        "user_id": _user.id,
        "api_key": apiKey,
        "connection_id": _connectionId,
      };

  // TODO setAnonymousUser
  Future<Event> setAnonymousUser() async => null;

  // TODO setGuestUser
  Future<Event> setGuestUser(User user) async {
    var guestUser, guestToken;
    _anonymous = true;
    var response = await dioClient.post<String>("/guest",
        data: {"user": user.toJson()}).whenComplete(() => _anonymous = false);
    // TODO: parse response into guestUser and guestToken
    return setUser(guestUser, guestToken);
  }

  // TODO disconnect
  Future<dynamic> disconnect() async => null;

  // TODO queryUsers
  Future<dynamic> queryUsers() async => null;

  // TODO search
  Future<dynamic> search() async => null;

  Future<EmptyResponse> addDevice(String id, String pushProvider) async {
    final response = await dioClient.post<String>("/devices", data: {
      "id": id,
      "push_provider": pushProvider,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  // TODO getDevices
  Future<dynamic> getDevices() async => null;

  Future<EmptyResponse> removeDevice(String id) async {
    final response =
        await dioClient.delete<String>("/devices", queryParameters: {
      "id": id,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  Channel channel({
    @required String type,
    String id,
    Map<String, dynamic> custom,
  }) {
    return Channel(this, type, id, custom);
  }

  // TODO updateUser: parse response
  Future<EmptyResponse> updateUser(User user) async {
    final response = await dioClient.post<String>("/users", data: {
      "users": {user.id: user.toJson()},
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> banUser(
      String targetUserID, Map<String, dynamic> options) async {
    final data = Map<String, dynamic>.from(options)
      ..addAll({
        "target_user_id": targetUserID,
      });
    final response =
        await dioClient.post<String>("/moderation/ban", data: data);
    return decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> unbanUser(String targetUserID) async {
    final response =
        await dioClient.delete<String>("/moderation/ban", queryParameters: {
      "target_user_id": targetUserID,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> muteUser(String targetID) async {
    final response = await dioClient.post<String>("/moderation/mute", data: {
      "target_id": targetID,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> unmuteUser(String targetID) async {
    final response = await dioClient.post<String>("/moderation/unmute", data: {
      "target_id": targetID,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> flagMessage(String messageID) async {
    final response = await dioClient.post<String>("/moderation/flag", data: {
      "target_message_id": messageID,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> unflagMessage(String messageID) async {
    final response = await dioClient.post<String>("/moderation/unflag", data: {
      "target_message_id": messageID,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> markAllRead() async {
    return dioClient
        .post<String>("/channels/read")
        .then((res) => EmptyResponse.fromJson(json.decode(res.data)));
  }

  // TODO updateMessage: parse response correctly
  Future<EmptyResponse> updateMessage(Message message) async {
    return dioClient
        .post<String>("/messages/${message.id}")
        .then((res) => EmptyResponse.fromJson(json.decode(res.data)));
  }

  Future<EmptyResponse> deleteMessage(String messageID) async {
    final response = await dioClient.delete<String>("/messages/$messageID");
    return decode(response.data, EmptyResponse.fromJson);
  }

  // TODO getMessage: parse response correctly
  Future<EmptyResponse> getMessage(String messageID) async {
    return dioClient
        .get<String>("/messages/$messageID")
        .then((res) => EmptyResponse.fromJson(json.decode(res.data)));
  }
}
