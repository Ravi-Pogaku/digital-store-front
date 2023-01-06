import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/globals.dart';
import 'package:zamazon/models/settings_BLoC.dart';

class LanguageDropDownMenu extends StatelessWidget {
  const LanguageDropDownMenu({
    super.key,
    this.currentLanguage,
  });

  final String? currentLanguage;

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsBLoC>(context);

    return DropdownButton<String>(
        value: currentLanguage ?? 'en',
        iconSize: 30,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        items: languages.entries
            .map((e) => buildLangMenuItem(e.key, e.value))
            .toList(),
        onChanged: (selectedLanguage) async {
          settingsProvider.changeLanguage(selectedLanguage!);
        });
  }

  DropdownMenuItem<String> buildLangMenuItem(
          String langCode, String langName) =>
      DropdownMenuItem(
        value: langCode, // langCodes are like 'en' and 'es'
        child: Text(
          '$langName ($langCode)', // langNames are like 'English' and 'Espanol'
          style: const TextStyle(fontSize: 20),
        ),
      );
}
