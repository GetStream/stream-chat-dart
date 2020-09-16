import 'dart:io';
import 'package:moor/ffi.dart';

class SharedDB {
  static constructDatabase(doc) {
    return VmDatabase(File(doc));
  }
}
