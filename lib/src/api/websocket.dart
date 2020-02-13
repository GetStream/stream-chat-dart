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
  final int reconnectionMonitorInterval;
  final int healthCheckInterval;
  final int reconnectionMonitorTimeout;

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
    this.reconnectionMonitorInterval = 1,
    this.healthCheckInterval = 30,
    this.reconnectionMonitorTimeout = 40,
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

  Completer<Event> _connectionCompleter = Completer<Event>();

  Future<Event> connect() {
    if (_manuallyClosed) {
      connectionStatus = ValueNotifier(ConnectionStatus.disconnected);
    }
    _manuallyClosed = false;

    if (_connecting) {
      logger.severe('already connecting');
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
    return _connectionCompleter.future;
  }

  void _onDone() {
    if (_manuallyClosed) {
      return;
    }

    logger.info(
        'connection closed | closeCode: ${_channel.closeCode} | closedReason: ${_channel.closeReason}');

    if (!_reconnecting) {
      _reconnect();
    }
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
      _lastEventAt = DateTime.now();

      connectionStatus.value = ConnectionStatus.connected;

      if (!_connectionCompleter.isCompleted) {
        _connectionCompleter.complete(event);
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

    if (!_connectionCompleter.isCompleted) {
      _cancelTimers();
      _connectionCompleter.completeError(error, stacktrace);
    } else if (!_reconnecting) {
      return _reconnect();
    }
  }

  void _startReconnectionMonitor() {
    final reconnectionTimer = (_) {
      final now = DateTime.now();
      if (_lastEventAt != null &&
          now.difference(_lastEventAt).inSeconds > reconnectionMonitorTimeout) {
        _channel.sink.close();
      }
    };

    _reconnectionMonitor = Timer.periodic(
      Duration(seconds: reconnectionMonitorInterval),
      reconnectionTimer,
    );

    reconnectionTimer(_reconnectionMonitor);
  }

  Future<void> _reconnect() async {
    print('reconnect');
    if (!_reconnecting) {
      _reconnecting = true;
      connectionStatus.value = ConnectionStatus.connecting;
    }

    final reconnectionTimer = (timer) {
      if (!_reconnecting) {
        timer.cancel();
        return;
      }
      if (_connecting) {
        logger.info('already connecting');
        return null;
      }

      logger.info('reconnecting..');

      _cancelTimers();

      connect();
    };

    final timer = Timer.periodic(Duration(seconds: 5), reconnectionTimer);

    reconnectionTimer(timer);
    print('reconnect end');
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

    final healthCheckTimer = (_) {
      logger.info('sending health.check');
      _channel.sink.add("{'type': 'health.check'}");
    };

    _healthCheck = Timer.periodic(
      Duration(seconds: healthCheckInterval),
      healthCheckTimer,
    );

    healthCheckTimer(_healthCheck);
  }

  Future<void> disconnect() {
    logger.info('disconnecting');
    _connectionCompleter = Completer();
    _cancelTimers();
    _manuallyClosed = true;
    connectionStatus.value = ConnectionStatus.disconnected;
    connectionStatus.dispose();
    return _channel.sink.close();
  }
}
