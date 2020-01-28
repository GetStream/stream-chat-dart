import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/html.dart';

import '../models/event.dart';
import '../models/user.dart';

// TODO: make this work on web and mobile
// TODO: improve error path for the connect() method
// TODO: make sure we pass an error with a stacktrace
// TODO: parse error even
// TODO: make sure parsing the event data is handled correctly
// TODO: if parsing an error into an event fails we should not hide the original error
// TODO: implement reconnection logic
class WebSocket {
  final String baseUrl;
  final User user;
  final Map<String, String> connectParams;
  final Map<String, dynamic> connectPayload;
  final void Function(Event) handler;

  bool _resolved;

  WebSocket(this.baseUrl, this.user, this.connectParams, this.connectPayload,
      this.handler) {
    _resolved = false;
  }

  Event decodeEvent(String source) {
    var map = json.decode(source);
    return Event.fromJson(map);
  }

  Future<Event> connect() {
    var completer = new Completer<Event>();
    var qs = Map<String, String>.from(connectParams);

    var data = Map<String, dynamic>.from(connectPayload);
    data["user_details"] = user.toJson();

    qs["json"] = json.encode(data);

    var uri = Uri.https(baseUrl, "connect", qs);
    var path = uri.toString().replaceFirst("https", "wss");

    var channel = HtmlWebSocketChannel.connect(path);
    channel.stream.listen((data) {
      final event = decodeEvent(data);
      if (_resolved) {
        handler(event);
      } else {
        _resolved = true;
        completer.complete(event);
      }
    }, onError: (error) {
      completer.completeError(error);
    });
    return completer.future;
  }
}
