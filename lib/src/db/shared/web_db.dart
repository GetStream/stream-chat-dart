import 'package:moor/moor_web.dart';

class SharedDB {
  static constructDatabase(path, dbName) {
    return WebDatabase(dbName);
  }
}
