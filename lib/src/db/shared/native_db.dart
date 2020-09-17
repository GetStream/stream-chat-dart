import 'dart:io';
import 'package:moor/ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SharedDB {
  static constructDatabase(dbName) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, dbName);

    return VmDatabase(File(path));
  }
}
