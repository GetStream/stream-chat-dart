import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

WebSocketChannel connectWebSocket(
  String url, {
  Iterable<String> protocols,
  Map<String, dynamic> headers,
  Duration pingInterval, 
}) =>
    HtmlWebSocketChannel.connect(url, protocols: protocols);
