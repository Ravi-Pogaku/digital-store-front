import 'package:flutter/material.dart';
import 'package:zamazon/globals.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

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
    return DropdownButton<String>(
        value: currentLanguage ?? 'en',
        iconSize: 30,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        items: languages.map(buildLangMenuItem).toList(),
        onChanged: (value) async {
          Locale newLocale = Locale(value!);
          await FlutterI18n.refresh(context, newLocale);
          changeLanguage(value);
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
