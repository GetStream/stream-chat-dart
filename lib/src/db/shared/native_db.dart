import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:moor/ffi.dart';
import 'package:moor/isolate.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SharedDB {
  static constructDatabase(path) async {
    return VmDatabase(File(path));
  }

  static Future<MoorIsolate> createMoorIsolate(String userId) async {
    WidgetsFlutterBinding.ensureInitialized();
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'db_$userId.sqlite');

    final receivePort = ReceivePort();
    await Isolate.spawn(
      startBackground,
      _IsolateStartRequest(receivePort.sendPort, path),
    );

    return (await receivePort.first as MoorIsolate);
  }

  static void startBackground(_IsolateStartRequest request) {
    final executor = LazyDatabase(() async {
      return VmDatabase(File(request.targetPath));
    });
    final moorIsolate = MoorIsolate.inCurrent(
          () => DatabaseConnection.fromExecutor(executor),
    );
    request.sendMoorIsolate.send(moorIsolate);
  }

}

class _IsolateStartRequest {
  final SendPort sendMoorIsolate;
  final String targetPath;

  _IsolateStartRequest(this.sendMoorIsolate, this.targetPath);
}
