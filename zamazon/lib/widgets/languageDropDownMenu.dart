import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/globals.dart';
// import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:zamazon/models/settings_BLoC.dart';

class LanguageDropDownMenu extends StatelessWidget {
  const LanguageDropDownMenu({
    super.key,
    this.currentLanguage,
    required this.changeLanguage,
  });

  final String? currentLanguage;
  final ValueChanged<String> changeLanguage;

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsBLoC>(context);

    return DropdownButton<String>(
        value: currentLanguage ?? 'en',
        iconSize: 30,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        items: languages.map(buildLangMenuItem).toList(),
        onChanged: (selectedLanguage) async {
          settingsProvider.changeLanguage(selectedLanguage!);
        });
  }

  DropdownMenuItem<String> buildLangMenuItem(String lang) => DropdownMenuItem(
        value: lang,
        child: Text(
          lang,
          style: const TextStyle(fontSize: 20),
        ),
      );
}
