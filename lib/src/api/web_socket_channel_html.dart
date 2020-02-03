import 'package:stream_chat/src/api/websocket.dart';
import 'package:web_socket_channel/html.dart';

final ConnectWebSocket connectWebSocket = (
  String url, {
  Iterable<String> protocols,
  Map<String, dynamic> headers,
  Duration pingInterval,
}) =>
    HtmlWebSocketChannel.connect(url, protocols: protocols);
