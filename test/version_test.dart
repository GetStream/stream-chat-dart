import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/version.dart';

void main() {
  test('stream chat version matches pubspec', () {
    final String pubspecPath = '${Directory.current.path}/pubspec.yaml';
    final String pubspec = File(pubspecPath).readAsStringSync();
    final RegExp regex = RegExp('version:\s*(.*)');
    final RegExpMatch match = regex.firstMatch(pubspec);
    expect(match, isNotNull);
    expect(PACKAGE_VERSION, match.group(1).trim());
  });
}
