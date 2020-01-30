import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:stream_chat/src/client.dart';

void main() {
  group('src/client', () {
    final List<String> log = [];

    overridePrint(testFn()) => () {
          log.clear();
          final spec = ZoneSpecification(print: (_, __, ___, String msg) {
            // Add to log instead of printing to stdout
            log.add(msg);
          });
          return Zone.current.fork(specification: spec).run(testFn);
        };

    tearDown(() {
      log.clear();
    });

    test('should create the object correctly', () {
      final client = Client('api-key');

      expect(client.baseURL, Client.defaultBaseURL);
      expect(client.apiKey, 'api-key');
      expect(client.logLevel, Level.WARNING);
      expect(client.dioClient.options.connectTimeout, 6000);
      expect(client.dioClient.options.receiveTimeout, 6000);
    });

    test('should create the object correctly', overridePrint(() {
      final LogHandlerFunction logHandler = (LogRecord record) {
        print(record.message);
      };

      final client = Client(
        'api-key',
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 12),
        logLevel: Level.INFO,
        baseURL: 'test.com',
        logHandlerFunction: logHandler,
      );

      expect(client.baseURL, 'test.com');
      expect(client.apiKey, 'api-key');
      expect(client.logLevel, Level.INFO);
      expect(client.dioClient.options.connectTimeout, 10000);
      expect(client.dioClient.options.receiveTimeout, 12000);

      client.logger.warning('test');
      client.logger.config('test config');

      expect(log, ['test']);
    }));
  });
}
