import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBUtils {
  static Future init() async {
    return openDatabase(
      path.join(await getDatabasesPath(), 'zamazon.db'),
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE themes(id INTEGER PRIMARY KEY, ThemeValue INTEGER)');
      },
      version: 1,
    );
  }
}
