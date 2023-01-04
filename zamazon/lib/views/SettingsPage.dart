import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/settings_BLoC.dart';
import 'package:zamazon/widgets/genericSnackBar.dart';
import 'package:zamazon/widgets/languageDropDownMenu.dart';
import '../widgets/changeThemeButton.dart';
import 'package:zamazon/authentication/authFunctions.dart';

class SettingsPageWidget extends StatefulWidget {
  const SettingsPageWidget({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<SettingsPageWidget> createState() => _SettingsPageWidgetState();
}

class _SettingsPageWidgetState extends State<SettingsPageWidget> {
  String? currentLanguage;
  final _auth = Auth();

  static const TextStyle mainTextStyle = TextStyle(fontSize: 20);

  Widget marginContainer(Widget child) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsBLoC>(context);
    final containerTheme =
        settingsProvider.isDarkMode ? Colors.grey[900] : Colors.white;

    currentLanguage = FlutterI18n.currentLocale(context)?.languageCode;

    return Container(
      decoration: BoxDecoration(
          color: containerTheme,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Column(
        children: [
          marginContainer(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Appearance:',
                    style: mainTextStyle, softWrap: true, maxLines: 2),
                ChangeThemeButton(),
              ],
            ),
          ),

          // Language row
          marginContainer(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    '${FlutterI18n.translate(context, "SettingPage.language")}:',
                    style: mainTextStyle,
                    softWrap: true,
                    maxLines: 2),
                LanguageDropDownMenu(
                  currentLanguage: currentLanguage,
                ),
              ],
            ),
          ),

          // Order history button
          marginContainer(
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/OrderHistory');
              },
              child: const Text(
                'Order History',
                style: mainTextStyle,
              ),
            ),
          ),

          // Log out button
          TextButton(
            onPressed: () {
              _auth.signOut().then((value) {
                showSnackBar(context,
                    FlutterI18n.translate(context, "SettingPage.logout"));
              });
            },
            style: ButtonStyle(
                foregroundColor: const MaterialStatePropertyAll(Colors.black),
                backgroundColor: const MaterialStatePropertyAll(Colors.orange),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                )),
            child: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
