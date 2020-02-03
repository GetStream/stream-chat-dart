import 'package:stream_chat/src/api/websocket.dart';
import 'package:web_socket_channel/io.dart';

final ConnectWebSocket connectWebSocket = (
  String url, {
  Iterable<String> protocols,
  Map<String, dynamic> headers,
  Duration pingInterval,
}) =>
    IOWebSocketChannel.connect(url, protocols: protocols);
