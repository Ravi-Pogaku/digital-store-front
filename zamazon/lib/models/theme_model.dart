import 'db_utils.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:zamazon/models/themes.dart';

class ThemeModel {
  Future insertTheme(Themes theme) async {
    final db = await DBUtils.init();
    return db.insert(
      'themes',
      theme.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Themes> getThemesWithId(int id) async {
    final db = await DBUtils.init();
    final List maps =
        await db.query('themes', where: 'id = ?', whereArgs: [id]);

    print('MAPS: $maps');

    if (maps.isEmpty) {
      final defaultTheme = Themes(id: 0, themeValue: 0);
      insertTheme(defaultTheme);
      return defaultTheme;
    }

    return Themes.fromMap(maps[0]);
  }
}
