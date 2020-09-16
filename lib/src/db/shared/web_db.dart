import 'package:moor/moor_web.dart';

class SharedDB {
  static constructDatabase(path) {
    return WebDatabase(path);
  }
}
