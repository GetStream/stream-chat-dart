import 'dart:io';
import 'package:moor/ffi.dart';

class SharedDB {
  static constructDatabase(doc, dbName) {
    return VmDatabase(File(doc));
  }
}
