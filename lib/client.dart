import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:stream_chat_dart/api/channel.dart';

import 'exceptions.dart';
import 'models/event.dart';
import 'api/requests.dart';
import 'api/responses.dart';
import 'models/message.dart';
import 'models/user.dart';
import 'api/websocket.dart';

class Options {
  static const Options DEFAULT = const Options();
  const Options();
}

const Map<String, String> _emptyMap = {};

class Client {
  static const defaultBaseURL = "chat-us-east-1.stream-io-api.com";

  Client(
      {@required this.apiKey,
      this.options = Options.DEFAULT,
      this.baseURL = defaultBaseURL});

  final String apiKey;
  final Options options;
  final String baseURL;
  final StreamController<Event> _controller =
      StreamController<Event>.broadcast();

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

  Future<http.Response> get(String url, {Map<String, String> params = _emptyMap}) async {
    final uri = _buildUri(url: url, params: params);
    var response = await http.get(uri, headers: getHttpHeaders());
    return _handleResponse(response);
  }

  Future<http.Response> put(String url, Map<String, dynamic> data) async {
    final uri = _buildUri(url: url);
    var response = await http.put(uri, headers: getHttpHeaders(), body: data);
    return _handleResponse(response);
  }

  Future<http.Response> post(String url, Map<String, dynamic> data) async {
    final uri = _buildUri(url: url);
    var response = await http.post(uri, headers: getHttpHeaders(), body: data);
    return _handleResponse(response);
  }

  Future<http.Response> patch(String url, Map<String, dynamic> data) async {
    final uri = _buildUri(url: url);
    var response = await http.patch(uri, headers: getHttpHeaders(), body: data);
    return _handleResponse(response);
  }

  Future<http.Response> delete(String url, {Map<String, String> params = _emptyMap}) async {
    final uri = _buildUri(url: url, params: params);
    var response = await http.delete(uri, headers: getHttpHeaders());
    return _handleResponse(response);
  }

  Map<String, String> getHttpHeaders() => {
        "Authorization": _token,
        "stream-auth-type": _getAuthType(),
        "x-stream-client": getUserAgent(),
      };

  Future<QueryChannelsResponse> queryChannels(QueryFilter filter,
      List<SortOption> sort, Map<String, dynamic> options) async {
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

    return get("/channels", params: {"payload": jsonEncode(payload)}).then(
        (value) => QueryChannelsResponse.fromJson(json.decode(value.body)));
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
    return post("/devices", {
      "id": id,
      "push_provider": pushProvider,
    }).then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }

  // TODO getDevices
  Future<dynamic> getDevices() async => null;

  Future<EmptyResponse> removeDevice(String id) async {
    return delete("/devices", params: {
      "id": id,
    }).then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }

  Channel channel(
      {@required String type, String id, Map<String, dynamic> custom}) {
    return Channel(this, type, id, custom);
  }

  // TODO updateUser: parse response
  Future<EmptyResponse> updateUser(User user) async {
    return post("/users", {
      "users": {user.id: user.toJson()},
    }).then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }

  Future<EmptyResponse> banUser(
      String targetUserID, Map<String, dynamic> options) async {
    var data = Map<String, dynamic>.from(options)
      ..addAll({
        "target_user_id": targetUserID,
      });
    return post("/moderation/ban", data)
        .then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }

  Future<EmptyResponse> unbanUser(String targetUserID) async {
    return delete("/moderation/ban", params: {
      "target_user_id": targetUserID,
    }).then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }

  Future<EmptyResponse> muteUser(String targetID) async {
    return post("/moderation/mute", {
      "target_id": targetID,
    }).then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }

  Future<EmptyResponse> unmuteUser(String targetID) async {
    return post("/moderation/unmute", {
      "target_id": targetID,
    }).then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }

  Future<EmptyResponse> flagMessage(String messageID) async {
    return post("/moderation/flag", {
      "target_message_id": messageID,
    }).then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }

  Future<EmptyResponse> unflagMessage(String messageID) async {
    return post("/moderation/unflag", {
      "target_message_id": messageID,
    }).then((value) => EmptyResponse.fromJson(json.decode(value.body)));
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
    return delete("/messages/$messageID")
        .then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }

  // TODO getMessage: parse response correctly
  Future<EmptyResponse> getMessage(String messageID) async {
    return get("/messages/$messageID")
        .then((value) => EmptyResponse.fromJson(json.decode(value.body)));
  }
}
