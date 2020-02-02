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
import 'package:stream_chat/src/models/user.dart';

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

    group('search', () {
      test('should pass right default parameters', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);

        final queryParams = {
          'payload': json.encode({
            "filter_conditions": null,
            'query': null,
            'sort': null,
          }),
        };

        when(mockDio.get<String>('/search', queryParameters: queryParams))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.search(null, null, null, null);

        verify(mockDio.get<String>('/search', queryParameters: queryParams))
            .called(1);
      });

      test('should pass right parameters', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);

        final filters = {
          "id": {
            "\$in": ["test"],
          },
        };
        final sortOptions = [SortOption('name')];
        final query = 'query';

        final queryParams = {
          'payload': json.encode({
            "filter_conditions": filters,
            'query': query,
            'sort': sortOptions,
          }),
        };

        when(mockDio.get<String>('/search', queryParameters: queryParams))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.search(
          filters,
          sortOptions,
          query,
          PaginationParams(),
        );

        verify(mockDio.get<String>('/search', queryParameters: queryParams))
            .called(1);
      });
    });

    group('devices', () {
      test('addDevice', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);

        when(mockDio.post<String>('/devices', data: {
          'id': 'test-id',
          'push_provider': 'test',
        })).thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.addDevice('test-id', 'test');

        verify(mockDio.post<String>('/devices',
            data: {'id': 'test-id', 'push_provider': 'test'})).called(1);
      });

      test('getDevices', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);

        when(mockDio.get<String>('/devices'))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.getDevices();

        verify(mockDio.get<String>('/devices')).called(1);
      });

      test('removeDevice', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);

        when(mockDio
                .delete<String>('/devices', queryParameters: {'id': 'test-id'}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.removeDevice('test-id');

        verify(mockDio.delete<String>('/devices',
            queryParameters: {'id': 'test-id'})).called(1);
      });
    });

    test('devToken', () {
      final client = Client('api-key');
      final token = client.devToken('test');

      expect(
        token,
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGVzdCJ9.devtoken',
      );
    });

    group('queryUsers', () {
      test('should pass right default parameters', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);

        final queryParams = {
          'payload': json.encode({
            "filter_conditions": {},
            "sort": null,
            "presence": false,
          }),
        };

        when(mockDio.get<String>('/users', queryParameters: queryParams))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.queryUsers(null, null, null);

        verify(mockDio.get<String>('/users', queryParameters: queryParams))
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
        final options = {"presence": true};

        final Map<String, dynamic> queryParams = {
          'payload': json.encode({
            "filter_conditions": queryFilter,
            "sort": sortOptions,
          }..addAll(options)),
        };

        when(mockDio.get<String>('/users', queryParameters: queryParams))
            .thenAnswer((_) async {
          return Response(data: '{}', statusCode: 200);
        });

        await client.queryUsers(
          queryFilter,
          sortOptions,
          options,
        );

        verify(mockDio.get<String>('/users', queryParameters: queryParams))
            .called(1);
      });
    });

    group('user', () {
      test('updateUser', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);

        final user = User(id: 'test-id');

        final data = {
          'users': {user.id: user.toJson()},
        };

        when(mockDio.post<String>('/users', data: data))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.updateUser(user);

        verify(mockDio.post<String>('/users', data: data)).called(1);
      });

      test('banUser', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);

        when(mockDio.post<String>('/moderation/ban',
                data: {'test': true, 'target_user_id': 'test-id'}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.banUser('test-id', {'test': true});

        verify(mockDio.post<String>('/moderation/ban',
            data: {'test': true, 'target_user_id': 'test-id'})).called(1);
      });

      test('unbanUser', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);

        when(mockDio.delete<String>('/moderation/ban',
                queryParameters: {'test': true, 'target_user_id': 'test-id'}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.unbanUser('test-id', {'test': true});

        verify(mockDio.delete<String>('/moderation/ban',
                queryParameters: {'test': true, 'target_user_id': 'test-id'}))
            .called(1);
      });

      test('muteUser', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);

        when(mockDio.post<String>('/moderation/mute',
                data: {'target_id': 'test-id'}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.muteUser('test-id');

        verify(mockDio.post<String>('/moderation/mute',
            data: {'target_id': 'test-id'})).called(1);
      });

      test('unmuteUser', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);

        when(mockDio.post<String>('/moderation/unmute',
                data: {'target_id': 'test-id'}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await client.unmuteUser('test-id');

        verify(mockDio.post<String>('/moderation/unmute',
            data: {'target_id': 'test-id'})).called(1);
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

    group('api methods', () {
      test('get', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);

        final Map<String, dynamic> queryParams = {
          'test': 1,
        };

        when(mockDio.get<String>('/test', queryParameters: queryParams))
            .thenAnswer((_) async {
          return Response(data: '{}', statusCode: 200);
        });

        await client.get('/test', queryParameters: queryParams);

        verify(mockDio.get<String>('/test', queryParameters: queryParams))
            .called(1);
      });

      test('post', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);

        final Map<String, dynamic> data = {
          'test': 1,
        };

        when(mockDio.post<String>('/test', data: data)).thenAnswer((_) async {
          return Response(data: '{}', statusCode: 200);
        });

        await client.post('/test', data: data);

        verify(mockDio.post<String>('/test', data: data)).called(1);
      });

      test('put', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);

        final Map<String, dynamic> data = {
          'test': 1,
        };

        when(mockDio.put<String>('/test', data: data)).thenAnswer((_) async {
          return Response(data: '{}', statusCode: 200);
        });

        await client.put('/test', data: data);

        verify(mockDio.put<String>('/test', data: data)).called(1);
      });

      test('patch', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);

        final Map<String, dynamic> data = {
          'test': 1,
        };

        when(mockDio.patch<String>('/test', data: data)).thenAnswer((_) async {
          return Response(data: '{}', statusCode: 200);
        });

        await client.patch('/test', data: data);

        verify(mockDio.patch<String>('/test', data: data)).called(1);
      });

      test('delete', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);

        final Map<String, dynamic> queryParams = {
          'test': 1,
        };

        when(mockDio.delete<String>('/test', queryParameters: queryParams))
            .thenAnswer((_) async {
          return Response(data: '{}', statusCode: 200);
        });

        await client.delete('/test', queryParameters: queryParams);

        verify(mockDio.delete<String>('/test', queryParameters: queryParams))
            .called(1);
      });
    });
  });
}
