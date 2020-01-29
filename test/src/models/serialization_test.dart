import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/src/models/serialization.dart';

void main() {
  group('src/models/serialization', () {
    test('should move unknown keys from root to dedicate property', () {
      final result = Serialization.moveKeysToRoot({
        'prop1': 'test',
        'prop2': 123,
        'prop3': true,
      }, [
        'prop1',
        'prop2',
      ]);

      expect(result, {
        'prop1': 'test',
        'prop2': 123,
        'extraData': {
          'prop3': true,
        },
      });
    });

    test('should have empty extraData', () {
      final result = Serialization.moveKeysToRoot({
        'prop1': 'test',
        'prop2': 123,
        'prop3': true,
      }, [
        'prop1',
        'prop2',
        'prop3'
      ]);

      expect(result, {
        'prop1': 'test',
        'prop2': 123,
        'prop3': true,
        'extraData': {},
      });
    });

    test('should return null', () {
      final result = Serialization.moveKeysToRoot(null, [
        'prop1',
        'prop2',
      ]);

      expect(result, null);
    });
  });
}
