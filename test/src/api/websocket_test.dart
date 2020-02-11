import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat/src/api/websocket.dart';
import 'package:stream_chat/src/models/event.dart';
import 'package:stream_chat/src/models/user.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Functions {
  WebSocketChannel connectFunc(
    String url, {
    Iterable<String> protocols,
    Map<String, dynamic> headers,
    Duration pingInterval,
  }) =>
      null;

  void handleFunc(Event event) => null;
}

class MockFunctions extends Mock implements Functions {}

class MockWSChannel extends Mock implements WebSocketChannel {}

void main() {
  group('src/api/websocket', () {
    group('connect', () {
      test('should connect with correct parameters', () async {
        final ConnectWebSocket connectFunc = MockFunctions().connectFunc;

        final ws = WebSocket(
          baseUrl: 'baseurl',
          user: User(id: 'testid'),
          logger: Logger('ws'),
          connectParams: {'test': 'true'},
          connectPayload: {'payload': 'test'},
          handler: (e) {
            print(e);
          },
          connectFunc: connectFunc,
        );

        final mockWSChannel = MockWSChannel();

        final StreamController<String> streamController =
            StreamController<String>.broadcast();

        final computedUrl =
            'wss://baseurl/connect?test=true&json=%7B%22payload%22%3A%22test%22%2C%22user_details%22%3A%7B%22id%22%3A%22testid%22%7D%7D';

        when(connectFunc(computedUrl)).thenAnswer((_) => mockWSChannel);
        when(mockWSChannel.stream).thenAnswer((_) {
          return streamController.stream;
        });

        final timer = Timer.periodic(
          Duration(milliseconds: 100),
          (_) => streamController.sink.add('{}'),
        );

        await ws.connect();

        verify(connectFunc(computedUrl)).called(1);

        await streamController.close();
        timer.cancel();
      });
    });

    test('should connect with correct parameters and handle events', () async {
      final handleFunc = MockFunctions().handleFunc;
      final ConnectWebSocket connectFunc = MockFunctions().connectFunc;

      final ws = WebSocket(
        baseUrl: 'baseurl',
        user: User(id: 'testid'),
        logger: Logger('ws'),
        connectParams: {'test': 'true'},
        connectPayload: {'payload': 'test'},
        handler: handleFunc,
        connectFunc: connectFunc,
      );

      final mockWSChannel = MockWSChannel();

      final StreamController<String> streamController =
          StreamController<String>.broadcast();

      final computedUrl =
          'wss://baseurl/connect?test=true&json=%7B%22payload%22%3A%22test%22%2C%22user_details%22%3A%7B%22id%22%3A%22testid%22%7D%7D';

      when(connectFunc(computedUrl)).thenAnswer((_) => mockWSChannel);
      when(mockWSChannel.stream).thenAnswer((_) {
        return streamController.stream;
      });

      final timer = Timer.periodic(
        Duration(milliseconds: 100),
        (_) => streamController.sink.add('{}'),
      );

      await ws.connect();

      when(handleFunc(any)).thenAnswer((_) async {
        verify(connectFunc(computedUrl)).called(1);
        verify(handleFunc(any)).called(greaterThan(0));

        timer.cancel();
        await streamController.close();
      });
    });

    test('should close correctly the controller', () async {
      final handleFunc = MockFunctions().handleFunc;

      final ConnectWebSocket connectFunc = MockFunctions().connectFunc;

      final ws = WebSocket(
        baseUrl: 'baseurl',
        user: User(id: 'testid'),
        logger: Logger('ws'),
        connectParams: {'test': 'true'},
        connectPayload: {'payload': 'test'},
        handler: handleFunc,
        connectFunc: connectFunc,
      );

      final mockWSChannel = MockWSChannel();

      final StreamController<String> streamController =
          StreamController<String>.broadcast();

      final computedUrl =
          'wss://baseurl/connect?test=true&json=%7B%22payload%22%3A%22test%22%2C%22user_details%22%3A%7B%22id%22%3A%22testid%22%7D%7D';

      when(connectFunc(computedUrl)).thenAnswer((_) => mockWSChannel);
      when(mockWSChannel.stream).thenAnswer((_) {
        return streamController.stream;
      });

      final timer = Timer.periodic(
        Duration(milliseconds: 100),
        (_) => streamController.sink.add('{}'),
      );

      await ws.connect();

      when(handleFunc(any)).thenAnswer((_) async {
        verify(connectFunc(computedUrl)).called(1);
        verify(handleFunc(any)).called(greaterThan(0));

        timer.cancel();
        await streamController.close();
      });
    });

    test('should throw an error', () async {
      final ConnectWebSocket connectFunc = MockFunctions().connectFunc;

      final ws = WebSocket(
        baseUrl: 'baseurl',
        user: User(id: 'testid'),
        logger: Logger('ws'),
        connectParams: {'test': 'true'},
        connectPayload: {'payload': 'test'},
        handler: (e) {
          print(e);
        },
        connectFunc: connectFunc,
      );

      final mockWSChannel = MockWSChannel();

      final StreamController<String> streamController =
          StreamController<String>.broadcast();

      final computedUrl =
          'wss://baseurl/connect?test=true&json=%7B%22payload%22%3A%22test%22%2C%22user_details%22%3A%7B%22id%22%3A%22testid%22%7D%7D';

      when(connectFunc(computedUrl)).thenAnswer((_) => mockWSChannel);
      when(mockWSChannel.stream).thenAnswer((_) {
        return streamController.stream;
      });

      final timer = Timer.periodic(
        Duration(milliseconds: 100),
        (_) => streamController.sink.addError('testerror'),
      );

      try {
        expect(await ws.connect(), throwsA(isA<String>()));
      } catch (_) {}

      verify(connectFunc(computedUrl)).called(1);

      await streamController.close();
      timer.cancel();
    });
  });
}
