import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/settings_BLoC.dart';
import 'package:zamazon/widgets/genericSnackBar.dart';
import 'package:zamazon/widgets/languageDropDownMenu.dart';
import '../widgets/changeThemeButton.dart';
import 'package:zamazon/authentication/authFunctions.dart';
import 'package:zamazon/views/orderHistory.dart';

class SettingsPageWidget extends StatefulWidget {
  const SettingsPageWidget({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<SettingsPageWidget> createState() => _SettingsPageWidgetState();
}

class _SettingsPageWidgetState extends State<SettingsPageWidget> {
  String? currentLanguage;
  final _auth = Auth();

  static const double mainFontSize = 20;

  // needed in changeThemeButton.dart to fix a problem
  void refreshFromChild() {
    setState(() {});
  }

  // callback? (dunno if this is the correct term)
  // used in languageDropDownMenu.dart
  void changeLanguage(String newLanguage) {
    setState(() {
      currentLanguage = newLanguage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final containerTheme = Provider.of<SettingsBLoC>(context).isDarkMode
        ? Colors.grey[900]
        : Colors.white;

    currentLanguage = FlutterI18n.currentLocale(context)?.languageCode;

    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        // margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: containerTheme,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(FlutterI18n.translate(context, "SettingPage.theme"),
                      style: const TextStyle(fontSize: mainFontSize),
                      softWrap: true,
                      maxLines: 2),
                  ChangeThemeButton(
                    refreshParent: refreshFromChild,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                  FlutterI18n.translate(context, "SettingPage.notification"),
                  style: const TextStyle(fontSize: mainFontSize),
                  softWrap: true,
                  maxLines: 2),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Text(
                  FlutterI18n.translate(context, "SettingPage.legality"),
                  style: const TextStyle(fontSize: mainFontSize),
                  softWrap: true,
                  maxLines: 2),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      FlutterI18n.translate(
                        context,
                        "SettingPage.language",
                      ),
                      style: const TextStyle(fontSize: mainFontSize),
                      softWrap: true,
                      maxLines: 2),
                  LanguageDropDownMenu(
                    currentLanguage: currentLanguage,
                    changeLanguage: changeLanguage,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Order History",
                          style: TextStyle(fontSize: mainFontSize)),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const OrderHistory()));
                          },
                          icon: const Icon(Icons.arrow_forward)),
                    ],
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                _auth.signOut().then((value) {
                  showSnackBar(context,
                      FlutterI18n.translate(context, "SettingPage.logout"));
                });
              },
              style: ButtonStyle(
                  foregroundColor: const MaterialStatePropertyAll(Colors.black),
                  backgroundColor:
                      const MaterialStatePropertyAll(Colors.orange),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ))),
              child: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}
