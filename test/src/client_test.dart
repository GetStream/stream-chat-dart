import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat/src/api/requests.dart';
import 'package:stream_chat/src/client.dart';
import 'package:stream_chat/src/exceptions.dart';

class MockDio extends Mock implements DioForNative {}

class MockHttpClientAdapter extends Mock implements HttpClientAdapter {}

void main() {
  group('src/client', () {
    group('constructor', () {
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
        expect(client.httpClient.options.connectTimeout, 6000);
        expect(client.httpClient.options.receiveTimeout, 6000);
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
        expect(Logger.root.level, Level.INFO);
        expect(client.httpClient.options.connectTimeout, 10000);
        expect(client.httpClient.options.receiveTimeout, 12000);

        client.logger.warning('test');
        client.logger.config('test config');

        expect(log, ['test']);
      }));
    });

    group('queryChannels', () {
      test('should pass right default parameters', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);

        final queryParams = {
          'payload': json.encode({
            "filter_conditions": null,
            "sort": null,
            "user_details": null,
            "state": true,
            "watch": true,
            "presence": false,
          }),
        };

        when(mockDio.get<String>('/channels', queryParameters: queryParams))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.queryChannels(null, null, null);

        verify(mockDio.get<String>('/channels', queryParameters: queryParams))
            .called(1);
      });

      test('should pass right parameters', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);

        final Map<String, dynamic> queryFilter = {
          "id": {
            "\$in": ["test"],
          },
        };
        final List<SortOption> sortOptions = [];
        final options = {"state": false, "watch": false, "presence": true};

        final Map<String, dynamic> queryParams = {
          'payload': json.encode({
            "filter_conditions": queryFilter,
            "sort": sortOptions,
            "user_details": null,
          }..addAll(options)),
        };

        when(mockDio.get<String>('/channels', queryParameters: queryParams))
            .thenAnswer((_) async {
          return Response(data: '{}', statusCode: 200);
        });

        await client.queryChannels(
          queryFilter,
          sortOptions,
          options,
        );

        verify(mockDio.get<String>('/channels', queryParameters: queryParams))
            .called(1);
      });
    });

    group('error handling', () {
      test('should parse the error correctly', () async {
        final dioHttp = Dio();
        final mockHttpClientAdapter = MockHttpClientAdapter();
        dioHttp.httpClientAdapter = mockHttpClientAdapter;

        final client = Client('api-key', httpClient: dioHttp);

        when(mockHttpClientAdapter.fetch(any, any, any)).thenAnswer(
            (_) async => ResponseBody.fromString('test error', 400));

        expect(client.queryChannels(null, null, null),
            throwsA(ApiError('test error', 400)));
      });
    });
  });
}
