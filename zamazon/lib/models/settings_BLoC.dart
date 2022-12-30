import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class that provides the current theme to components that require it.

class SettingsBLoC extends ChangeNotifier {
  ThemeMode? themeMode;
  String? languageCode;

  // constructor to set the current theme. On a fresh download of this app
  // isDarkMode and languageCode will be null so they are defaulted to
  // lightmode and english respectively.
  SettingsBLoC({bool? isDarkMode, String? languageCode}) {
    if (isDarkMode == null) {
      themeMode = ThemeMode.light; // default to lightmode
    } else {
      themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }

    if (languageCode == null) {
      this.languageCode = 'en'; // default to english
    } else {
      this.languageCode = languageCode;
    }

    print(
        'Initialized settings: language=${this.languageCode} theme=$themeMode');
  }

  // used for widgets' whose colors are not determined by the theme of the
  // parent material app. Look in SignIn-SignUpForm.dart for example.
  bool get isDarkMode {
    return themeMode == ThemeMode.dark;
  }

  // swaps the themeMode between light and dark
  Future<void> toggleTheme(bool isOn) async {
    // used to save simple key value pairs into local storage.
    // stored values are used when app is initialized.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // isOn is the value of the light-dark mode switch.
    // Look in changeThemeButton.dart for the switch.
    if (isOn) {
      prefs.setBool('isDarkMode', true);
      themeMode = ThemeMode.dark;
    } else {
      prefs.setBool('isDarkMode', false);
      themeMode = ThemeMode.light;
    }

    print('Changed theme to ${themeMode.toString()}');
    notifyListeners();
  }

  // changes the language. Look at languageDropDownMenu.dart for usage.
  Future<void> changeLanguage(String? selectedLanguageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (selectedLanguageCode == null) {
      prefs.setString('languageCode', 'en');
      this.languageCode = 'en';
    } else {
      prefs.setString('languageCode', selectedLanguageCode);
      this.languageCode = selectedLanguageCode;
    }

    print('Changed language to $languageCode');
    notifyListeners();
  }
}

class CustomThemes {
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
