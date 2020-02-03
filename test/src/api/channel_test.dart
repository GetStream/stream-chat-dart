import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat/src/api/requests.dart';
import 'package:stream_chat/src/client.dart';
import 'package:stream_chat/src/event_type.dart';
import 'package:stream_chat/src/models/event.dart';
import 'package:stream_chat/src/models/member.dart';
import 'package:stream_chat/src/models/message.dart';
import 'package:stream_chat/src/models/reaction.dart';

class MockDio extends Mock implements DioForNative {}

class MockHttpClientAdapter extends Mock implements HttpClientAdapter {}

void main() {
  group('src/api/channel', () {
    group('message', () {
      test('sendMessage', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');
        final message = Message(text: 'hey');

        when(mockDio.post<String>('/channels/messaging/testid/message',
                data: {'message': message.toJson()}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.sendMessage(message);

        verify(mockDio.post<String>('/channels/messaging/testid/message',
            data: {'message': message.toJson()})).called(1);
      });

      test('markRead', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');

        when(mockDio.post<String>('/channels/messaging/testid/read'))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.markRead();

        verify(mockDio.post<String>('/channels/messaging/testid/read'))
            .called(1);
      });

      test('getReplies', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');
        final pagination = PaginationParams();

        when(mockDio.get<String>('/messages/messageid/replies',
                queryParameters: pagination.toJson()))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.getReplies('messageid', pagination);

        verify(mockDio.get<String>('/messages/messageid/replies',
                queryParameters: pagination.toJson()))
            .called(1);
      });

      test('sendAction', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');
        final Map<String, dynamic> data = {'test': true};

        when(mockDio.post<String>('/messages/messageid/action',
                data: {'id': 'testid', 'type': 'messaging', 'form_data': data}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.sendAction('messageid', data);

        verify(mockDio.post<String>('/messages/messageid/action',
                data: {'id': 'testid', 'type': 'messaging', 'form_data': data}))
            .called(1);
      });

      test('getMessagesById', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');
        final messageIds = ['a', 'b'];

        when(mockDio.get<String>('/channels/messaging/testid/messages',
                queryParameters: {'ids': messageIds.join(',')}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.getMessagesById(messageIds);

        verify(mockDio.get<String>('/channels/messaging/testid/messages',
            queryParameters: {'ids': messageIds.join(',')})).called(1);
      });

      test('sendFile', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');
        final file = MultipartFile.fromString('file');

        when(mockDio.post<String>('/channels/messaging/testid/file',
                data: argThat(isA<FormData>(), named: 'data')))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.sendFile(file);

        verify(mockDio.post<String>('/channels/messaging/testid/file',
                data: argThat(isA<FormData>(), named: 'data')))
            .called(1);
      });

      test('sendImage', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');
        final file = MultipartFile.fromString('file');

        when(mockDio.post<String>('/channels/messaging/testid/image',
                data: argThat(isA<FormData>(), named: 'data')))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.sendImage(file);

        verify(mockDio.post<String>('/channels/messaging/testid/image',
                data: argThat(isA<FormData>(), named: 'data')))
            .called(1);
      });

      test('deleteFile', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');
        final url = 'url';

        when(mockDio.delete<String>('/channels/messaging/testid/file',
                queryParameters: {'url': url}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.deleteFile(url);

        verify(mockDio.delete<String>('/channels/messaging/testid/file',
            queryParameters: {'url': url})).called(1);
      });

      test('deleteImage', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');
        final url = 'url';

        when(mockDio.delete<String>('/channels/messaging/testid/image',
                queryParameters: {'url': url}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.deleteImage(url);

        verify(mockDio.delete<String>('/channels/messaging/testid/image',
            queryParameters: {'url': url})).called(1);
      });
    });

    test('sendEvent', () async {
      final mockDio = MockDio();

      when(mockDio.options).thenReturn(BaseOptions());
      when(mockDio.interceptors).thenReturn(Interceptors());

      final client = Client('api-key', httpClient: mockDio);
      final channelClient = client.channel('messaging', id: 'testid');
      final event = Event(type: EventType.any);

      when(mockDio.post<String>('/channels/messaging/testid/event',
              data: {'event': event.toJson()}))
          .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

      await channelClient.sendEvent(event);

      verify(mockDio.post<String>('/channels/messaging/testid/event',
          data: {'event': event.toJson()})).called(1);
    });

    group('reactions', () {
      test('sendReaction', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');
        final reaction = Reaction(type: 'test');

        when(mockDio.post<String>('/messages/messageid/reaction',
                data: {'reaction': reaction.toJson()}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.sendReaction('messageid', reaction);

        verify(mockDio.post<String>('/messages/messageid/reaction',
            data: {'reaction': reaction.toJson()})).called(1);
      });

      test('deleteReaction', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');

        when(mockDio.delete<String>('/messages/messageid/reaction/test'))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.deleteReaction('messageid', 'test');

        verify(mockDio.delete<String>('/messages/messageid/reaction/test'))
            .called(1);
      });

      test('getReactions', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');
        final pagination = PaginationParams();

        when(mockDio.get<String>('/messages/messageid/reactions',
                queryParameters: pagination.toJson()))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.getReactions('messageid', pagination);

        verify(mockDio.get<String>('/messages/messageid/reactions',
                queryParameters: pagination.toJson()))
            .called(1);
      });
    });

    group('channel', () {
      test('addMembers', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');
        final List<Member> members = [Member(invited: true)];
        final message = Message(text: 'test');

        when(mockDio.post<String>('/channels/messaging/testid', data: {
          'add_members': members.map((m) => m.toJson()),
          'message': message.toJson()
        })).thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.addMembers(members, message);

        verify(mockDio.post<String>('/channels/messaging/testid', data: {
          'add_members': members.map((m) => m.toJson()),
          'message': message.toJson()
        })).called(1);
      });

      test('addModerators', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');
        final List<Member> members = [Member(invited: true)];
        final message = Message(text: 'test');

        when(mockDio.post<String>('/channels/messaging/testid', data: {
          'add_moderators': members.map((m) => m.toJson()),
          'message': message.toJson()
        })).thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.addModerators(members, message);

        verify(mockDio.post<String>('/channels/messaging/testid', data: {
          'add_moderators': members.map((m) => m.toJson()),
          'message': message.toJson()
        })).called(1);
      });

      test('inviteMembers', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');
        final List<Member> members = [Member(invited: true)];
        final message = Message(text: 'test');

        when(mockDio.post<String>('/channels/messaging/testid', data: {
          'invites': members.map((m) => m.toJson()),
          'message': message.toJson()
        })).thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.inviteMembers(members, message);

        verify(mockDio.post<String>('/channels/messaging/testid', data: {
          'invites': members.map((m) => m.toJson()),
          'message': message.toJson()
        })).called(1);
      });

      test('removeMembers', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');
        final List<Member> members = [Member(invited: true)];
        final message = Message(text: 'test');

        when(mockDio.post<String>('/channels/messaging/testid', data: {
          'remove_members': members.map((m) => m.toJson()),
          'message': message.toJson()
        })).thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.removeMembers(members, message);

        verify(mockDio.post<String>('/channels/messaging/testid', data: {
          'remove_members': members.map((m) => m.toJson()),
          'message': message.toJson()
        })).called(1);
      });

      test('demoteModerators', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');
        final List<Member> members = [Member(invited: true)];
        final message = Message(text: 'test');

        when(mockDio.post<String>('/channels/messaging/testid', data: {
          'demote_moderators': members.map((m) => m.toJson()),
          'message': message.toJson()
        })).thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.demoteModerators(members, message);

        verify(mockDio.post<String>('/channels/messaging/testid', data: {
          'demote_moderators': members.map((m) => m.toJson()),
          'message': message.toJson()
        })).called(1);
      });

      test('hide', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');

        when(mockDio.post<String>('/channels/messaging/testid/hide',
                data: {'clear_history': true}))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.hide(true);

        verify(mockDio.post<String>('/channels/messaging/testid/hide',
            data: {'clear_history': true})).called(1);
      });

      test('show', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');

        when(mockDio.post<String>('/channels/messaging/testid/show'))
            .thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.show();

        verify(mockDio.post<String>('/channels/messaging/testid/show'))
            .called(1);
      });

      test('banUser', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');

        when(mockDio.post<String>('/moderation/ban', data: {
          'test': true,
          'target_user_id': 'test-id',
          'type': 'messaging',
          'id': 'testid',
        })).thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        final Map<String, dynamic> options = {'test': true};
        await channelClient.banUser('test-id', options);

        verify(mockDio.post<String>('/moderation/ban', data: {
          'test': true,
          'target_user_id': 'test-id',
          'type': 'messaging',
          'id': 'testid',
        })).called(1);
      });

      test('unbanUser', () async {
        final mockDio = MockDio();

        when(mockDio.options).thenReturn(BaseOptions());
        when(mockDio.interceptors).thenReturn(Interceptors());

        final client = Client('api-key', httpClient: mockDio);
        final channelClient = client.channel('messaging', id: 'testid');

        when(mockDio.delete<String>('/moderation/ban', queryParameters: {
          'target_user_id': 'test-id',
          'type': 'messaging',
          'id': 'testid',
        })).thenAnswer((_) async => Response(data: '{}', statusCode: 200));

        await channelClient.unbanUser('test-id');

        verify(mockDio.delete<String>('/moderation/ban', queryParameters: {
          'target_user_id': 'test-id',
          'type': 'messaging',
          'id': 'testid',
        })).called(1);
      });
    });
  });
}
