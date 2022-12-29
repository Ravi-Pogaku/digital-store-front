import 'package:flutter/material.dart';
import 'package:zamazon/models/theme_model.dart';
import 'package:zamazon/models/themes.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeModel _model = ThemeModel();
  int id = 0;
  Themes? getTheme;
  ThemeMode? themeMode;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  Future _addTheme(int mode) async {
    Themes addTheme = Themes(id: id, themeValue: mode);
    await _model.insertTheme(addTheme);
  }

  ThemeMode getCurrentTheme() {
    _model.getThemesWithId(id).then((value) {
      getTheme = value;
    });

    if (getTheme == null) {
      return ThemeMode.light;
    }
    themeMode = getTheme!.themeValue == 1 ? ThemeMode.dark : ThemeMode.light;
    return themeMode!;
  }

  void toggleTheme(bool isOn) {
    isOn ? _addTheme(1) : _addTheme(0);
    _model.getThemesWithId(id).then((value) {
      getTheme = value;
    });
    themeMode = getTheme!.themeValue == 1 ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.grey.shade900,
      primaryColor: Colors.white,
      colorScheme: const ColorScheme.dark(),
      iconTheme: const IconThemeData(color: Colors.white));

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.black,
      colorScheme: const ColorScheme.light(),
      iconTheme: const IconThemeData(color: Colors.black));
}
