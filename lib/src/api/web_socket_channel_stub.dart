import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:async/src/stream_sink_transformer.dart';
import 'package:stream_channel/src/stream_channel_transformer.dart';
import 'package:stream_channel/stream_channel.dart';

WebSocketChannel connectWebSocket(String url,
    {Iterable<String> protocols,
      Map<String, dynamic> headers,
      Duration pingInterval}) =>
    ImplWebSocketChannel();

class ImplWebSocketChannel implements WebSocketChannel {

  @override
  StreamChannel<S> cast<S>() => throw UnimplementedError();

  @override
  StreamChannel changeSink(StreamSink Function(StreamSink sink) change) => throw UnimplementedError();

  @override
  StreamChannel changeStream(Stream Function(Stream stream) change) => throw UnimplementedError();

  @override
  int get closeCode => throw UnimplementedError();

  @override
  String get closeReason => throw UnimplementedError();

  @override
  void pipe(StreamChannel other) => throw UnimplementedError();

  @override
  String get protocol => throw UnimplementedError();

  @override
  WebSocketSink get sink => throw UnimplementedError();

  @override
  Stream get stream => throw UnimplementedError();

  @override
  StreamChannel<S> transform<S>(StreamChannelTransformer<S,dynamic> transformer) => throw UnimplementedError();

  @override
  StreamChannel transformSink(StreamSinkTransformer transformer) => throw UnimplementedError();

  @override
  StreamChannel transformStream(StreamTransformer transformer) => throw UnimplementedError();
}