import 'package:moor/moor_web.dart';

class SharedDB {
  static constructDatabase(dbName) async {
    return WebDatabase(dbName);
  }
}
