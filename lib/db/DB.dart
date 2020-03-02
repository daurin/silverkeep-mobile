import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DB {
  static Database db;

  static Future<void> init() async {
    String path = join(await getDatabasesPath(), 'silverkeep.db');

    print(path);

    if (db != null) {
      return;
    }

    db = await openDatabase(path,
        version: 2, onOpen: _onOpen, onCreate: _onCreate, onUpgrade: _onUprade);
  }

  static _onOpen(Database db) {}

  static _onCreate(Database db, int version) {
    print('Base de datos creada');

    rootBundle.loadString('lib/db/silverkeep.sql')
      .then((String script) {
        List<String> scripts = script.split(";");
        scripts.forEach((v) {
          if (v.isNotEmpty) {
            print(v);
            db.execute(v.trim());
          }
        });
      })
      .catchError((err) {
        print("Error: " + err.toString());
        //throw(err);
      });
  }

  static _onUprade(Database db, int oldVersion, int newVersion) {}

  // static String _getStringFromBytes(ByteData data) {
  //   final buffer = data.buffer;
  //   var list = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  //   return utf8.decode(list);
  // }
}
