import 'package:stream_chat/src/models/channel.dart';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('src/models/channel', () {
    const jsonExample = '''
      {
        "id": "test",
        "type": "livestream",
        "cid": "test:livestream",
        "cats": true,
        "fruit": ["bananas", "apples"]
      }      
      ''';

    test('should parse json correctly', () {
      final channel = Channel.fromJson(json.decode(jsonExample));
      expect(channel.id, equals("test"));
      expect(channel.type, equals("livestream"));
      expect(channel.cid, equals("test:livestream"));
      expect(channel.extraData["cats"], equals(true));
      expect(channel.extraData["fruit"], equals(["bananas", "apples"]));
    });

    test('should serialize to json correctly', () {
      final channel = Channel("type", "id", "a:a", null, null, true, null, null,
          null, null, 0, [], {"name": "cool"});

      expect(
        channel.toJson(),
        {
          'id': 'type',
          'type': 'id',
          'cid': 'a:a',
          'config': null,
          'created_by': null,
          'frozen': true,
          'last_message_at': null,
          'created_at': null,
          'updated_at': null,
          'deleted_at': null,
          'member_count': 0,
          'members': [],
          'name': 'cool'
        },
      );
    });
  });
}
