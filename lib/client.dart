import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
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

const Map<String, String> _emptyMap = {};

class Client {
  static const defaultBaseURL = "chat-us-east-1.stream-io-api.com";

  // TODO: keep-alive, connection timeout, connection pool (HttpClient dart:io)
  Client(
    this.apiKey, {
    this.baseURL = defaultBaseURL,
    this.logLevel = Level.WARNING,
    LogHandlerFunction logHandlerFunction,
    this.requestTimeout = const Duration(seconds: 6),
  }) {
    Logger.root.level = logLevel;
    if (logHandlerFunction == null) {
      logHandlerFunction = (LogRecord record) {
        print(
            '(${record.time}) ${record.level.name}: ${record.loggerName} | ${record.message}');
      };
    }
    logger.onRecord.listen(logHandlerFunction);
  }

  final Logger logger = Logger('HTTP');
  final Level logLevel;
  final String apiKey;
  final String baseURL;
  final Duration requestTimeout;
  final _controller = StreamController<Event>.broadcast();

  Stream get stream => _controller.stream;

  String _token;
  User _user;
  bool _anonymous;
  String _connectionId;
  WebSocket _ws;

  Future<Event> setUser(User user, String token) {
    _user = user;
    _token = token;
    _anonymous = false;
    return connect();
  }

  void dispose(filename) {
    _controller.close();
  }

  Stream<Event> on(String eventType) =>
      stream.where((event) => eventType == null || event.type == eventType);

  void handleEvent(Event event) => _controller.add(event);

  Uri _buildUri({@required String url, Map<String, String> params: _emptyMap}) {
    var fullParams = new Map<String, String>.from(params)
      ..addAll(getCommonQueryParams());
    return Uri.https(baseURL, url, fullParams);
  }

  http.Response _handleResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw ApiError(response.body, response.statusCode);
    }
    return response;
  }

  Future<http.Response> get(
    String url, {
    Map<String, String> params = _emptyMap,
  }) async {
    logger.info('get - $url - $params');
    final uri = _buildUri(url: url, params: params);
    var response = await http.get(uri, headers: getHttpHeaders());
    return _handleResponse(response);
  }

  Future<http.Response> put(String url, Map<String, dynamic> data) async {
    logger.info('put - $url - $data');
    final uri = _buildUri(url: url);
    var response = await http.put(uri, headers: getHttpHeaders(), body: data);
    return _handleResponse(response);
  }

  Future<http.Response> post(String url, Map<String, dynamic> data) async {
    logger.info('put - $url - $data');
    final uri = _buildUri(url: url);
    var response = await http.post(uri, headers: getHttpHeaders(), body: data);
    return _handleResponse(response);
  }

  Future<http.Response> patch(String url, Map<String, dynamic> data) async {
    logger.info('patch - $url - $data');
    final uri = _buildUri(url: url);
    var response = await http.patch(uri, headers: getHttpHeaders(), body: data);
    return _handleResponse(response);
  }

  Future<http.Response> delete(
    String url, {
    Map<String, String> params = _emptyMap,
  }) async {
    logger.info('delete - $url - $params');
    final uri = _buildUri(url: url, params: params);
    var response = await http.delete(uri, headers: getHttpHeaders());
    return _handleResponse(response);
  }

  Map<String, String> getHttpHeaders() => {
        "Authorization": _token,
        "stream-auth-type": _getAuthType(),
        "x-stream-client": getUserAgent(),
      };

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

    final response = await get("/channels", params: {
      "payload": jsonEncode(payload),
    });
    return decode<QueryChannelsResponse>(
      response.body,
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

  Map<String, String> getCommonQueryParams() => {
        "user_id": _user.id,
        "api_key": apiKey,
        "connection_id": _connectionId,
      };

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

  // TODO
  Future<http.Response> sendFile() async => null;

  // TODO setAnonymousUser
  Future<Event> setAnonymousUser() async => null;

  // TODO setGuestUser
  Future<Event> setGuestUser(User user) async {
    var guestUser, guestToken;
    _anonymous = true;
    var response = await post("/guest", {"user": user.toJson()})
        .whenComplete(() => _anonymous = false);
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
    final response = await post("/devices", {
      "id": id,
      "push_provider": pushProvider,
    });
    return decode(response.body, EmptyResponse.fromJson);
  }

  // TODO getDevices
  Future<dynamic> getDevices() async => null;

  Future<EmptyResponse> removeDevice(String id) async {
    final response = await delete("/devices", params: {
      "id": id,
    });
    return decode(response.body, EmptyResponse.fromJson);
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
    final response = await post("/users", {
      "users": {user.id: user.toJson()},
    });
    return decode(response.body, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> banUser(
      String targetUserID, Map<String, dynamic> options) async {
    final data = Map<String, dynamic>.from(options)
      ..addAll({
        "target_user_id": targetUserID,
      });
    final response = await post("/moderation/ban", data);
    return decode(response.body, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> unbanUser(String targetUserID) async {
    final response = await delete("/moderation/ban", params: {
      "target_user_id": targetUserID,
    });
    return decode(response.body, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> muteUser(String targetID) async {
    final response = await post("/moderation/mute", {
      "target_id": targetID,
    });
    return decode(response.body, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> unmuteUser(String targetID) async {
    final response = await post("/moderation/unmute", {
      "target_id": targetID,
    });
    return decode(response.body, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> flagMessage(String messageID) async {
    final response = await post("/moderation/flag", {
      "target_message_id": messageID,
    });
    return decode(response.body, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> unflagMessage(String messageID) async {
    final response = await post("/moderation/unflag", {
      "target_message_id": messageID,
    });
    return decode(response.body, EmptyResponse.fromJson);
  }

  Future<EmptyResponse> markAllRead() async {
    return post("/channels/read", {})
        .then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }

  // TODO updateMessage: parse response correctly
  Future<EmptyResponse> updateMessage(Message message) async {
    return post("/messages/${message.id}", {})
        .then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }

  Future<EmptyResponse> deleteMessage(String messageID) async {
    final response = await delete("/messages/$messageID");
    return decode(response.body, EmptyResponse.fromJson);
  }

  // TODO getMessage: parse response correctly
  Future<EmptyResponse> getMessage(String messageID) async {
    return get("/messages/$messageID")
        .then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }
}
