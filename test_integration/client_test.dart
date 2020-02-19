import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:stream_chat/src/client.dart';
import 'package:stream_chat/stream_chat.dart';

const API_KEY = '6xjf3dex3n7d';
const TOKEN =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoid2lsZC1icmVlemUtNyJ9.VM2EX1EXOfgqa-bTH_3JzeY0T99ngWzWahSauP3dBMo";

void main() {
  test('test', () async {
    final client = Client(
      '6xjf3dex3n7d',
      logLevel: Level.INFO,
      tokenProvider: (_) async => '',
    );
    final user = User(id: "wild-breeze-7");

    final setUserEvent = await client.setGuestUser(user);
    print(setUserEvent.toJson());

    final queryChannels = await client.queryChannels();
    print('queryChannels.channels.length: ${queryChannels.length}');

    final queryUsers = await client.queryUsers(
        null, [SortOption('created_at', direction: SortOption.DESC)], null);
    print('queryUsers.users.length: ${queryUsers.users.length}');
    expect(queryUsers.users.length, greaterThan(1));

    queryUsers.users.forEach((u) => print(u.createdAt));

    final queryCurrentUser = await client.queryUsers({
      'id': {
        '\$in': [user.id],
      }
    }, null, null);
    print('queryCurrentUser.users.length: ${queryCurrentUser.users.length}');
    expect(queryCurrentUser.users.length, 1);
  });
}
