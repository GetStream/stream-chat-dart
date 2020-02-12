import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/event.dart';
import '../models/user.dart';
import 'connection_status.dart';
import 'web_socket_channel_stub.dart'
    if (dart.library.html) 'web_socket_channel_html.dart'
    if (dart.library.io) 'web_socket_channel_io.dart';

typedef EventHandler = void Function(Event);
typedef ConnectWebSocket = WebSocketChannel Function(String url,
    {Iterable<String> protocols});

// TODO: improve error path for the connect() method
// TODO: make sure we pass an error with a stacktrace
// TODO: parse error even
// TODO: make sure parsing the event data is handled correctly
// TODO: if parsing an error into an event fails we should not hide the original error
class WebSocket {
  final String baseUrl;
  final User user;
  final Map<String, String> connectParams;
  final Map<String, dynamic> connectPayload;
  final EventHandler handler;
  final Logger logger;
  final ConnectWebSocket connectFunc;

  ValueNotifier<ConnectionStatus> connectionStatus =
      ValueNotifier(ConnectionStatus.disconnected);

  Uri uri;
  String path;

  WebSocketChannel _channel;
  Timer _healthCheck, _reconnectionMonitor;
  DateTime _lastEventAt;
  bool _manuallyClosed = false, _connecting = false, _reconnecting = false;

  WebSocket({
    @required this.baseUrl,
    this.user,
    this.connectParams,
    this.connectPayload,
    this.handler,
    this.logger,
    this.connectFunc = connectWebSocket,
  }) {
    final qs = Map<String, String>.from(connectParams);

    final data = Map<String, dynamic>.from(connectPayload);

    data["user_details"] = user.toJson();
    qs["json"] = json.encode(data);

    uri = Uri.https(baseUrl, "connect", qs);
    path = uri.toString().replaceFirst("https", "wss");
  }

  Event decodeEvent(String source) {
    return Event.fromJson(json.decode(source));
  }

  Completer<Event> completer = Completer<Event>();

  Future<Event> connect() {
    if (_manuallyClosed) {
      connectionStatus = ValueNotifier(ConnectionStatus.disconnected);
    }
    _manuallyClosed = false;

    if (_connecting) {
      logger.info('already connecting');
      return null;
    }

    _connecting = true;
    connectionStatus.value = ConnectionStatus.connecting;

    logger.info('connecting to $path');

    _channel = connectFunc(path);
    _channel.stream.listen(
      (data) {
        _onData(data);
      },
      onError: (error, stacktrace) {
        _onConnectionError(error, stacktrace);
      },
      onDone: () {
        _onDone();
      },
    );
    return completer.future;
  }

  void _onDone() {
    if (_manuallyClosed) {
      return;
    }

    logger.info(
        'connection closed | closeCode: ${_channel.closeCode} | closedReason: ${_channel.closeReason}');

    _reconnect();
  }

  void _onData(data) {
    logger.info('new data: $data');
    final event = decodeEvent(data);
    if (_lastEventAt != null) {
      handler(event);
    } else {
      logger.info('connection estabilished');
      _connecting = false;
      _reconnecting = false;

      connectionStatus.value = ConnectionStatus.connected;

      if (!completer.isCompleted) {
        completer.complete(event);
      } else {
        handler(event);
      }

      _startReconnectionMonitor();
      _startHealthCheck();
    }
    _lastEventAt = DateTime.now();
  }

  Future<void> _onConnectionError(error, stacktrace) async {
    logger.severe('error connecting');
    _connecting = false;

    if (!_reconnecting) {
      connectionStatus.value = ConnectionStatus.disconnected;
    }

    if (!completer.isCompleted) {
      _cancelTimers();
      completer.completeError(error, stacktrace);
    } else {
      return _reconnect();
    }
  }

  void _startReconnectionMonitor() {
    _reconnectionMonitor = Timer.periodic(Duration(seconds: 1), (_) {
      final now = DateTime.now();
      if (now.difference(_lastEventAt).inSeconds > 40) {
        _channel.sink.close();
      }
    });
  }

  Future<Event> _reconnect() async {
    if (!_reconnecting) {
      _reconnecting = true;
      connectionStatus.value = ConnectionStatus.connecting;
    }

    if (_connecting) {
      logger.info('already connecting');
      return null;
    }

    logger.info('reconnecting..');

    _cancelTimers();

    await Future.delayed(Duration(seconds: 5));

    return connect();
  }

  void _cancelTimers() {
    _lastEventAt = null;
    if (_healthCheck != null) {
      _healthCheck.cancel();
    }
    if (_reconnectionMonitor != null) {
      _reconnectionMonitor.cancel();
    }
  }

  void _startHealthCheck() {
    logger.info('start health check monitor');
    _healthCheck = Timer.periodic(Duration(seconds: 30), (_) {
      logger.info('sending health.check');
      _channel.sink.add("{'type': 'health.check'}");
    });
  }

  Future<void> disconnect() {
    logger.info('disconnecting');
    completer = Completer();
    _cancelTimers();
    _manuallyClosed = true;
    connectionStatus.value = ConnectionStatus.disconnected;
    connectionStatus.dispose();
    return _channel.sink.close();
  }
}
