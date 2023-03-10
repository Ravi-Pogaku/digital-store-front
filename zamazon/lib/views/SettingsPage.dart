import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/bottomNavBarBLoC.dart';
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

class _SettingsPageWidgetState extends State<SettingsPageWidget>
    with AutomaticKeepAliveClientMixin {
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    currentLanguage = FlutterI18n.currentLocale(context)?.languageCode;

    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        children: [
          marginContainer(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${FlutterI18n.translate(context, "SettingPage.appearance")}:",
                    style: mainTextStyle, softWrap: true, maxLines: 2),
                const ChangeThemeButton(),
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
              child: Text(
                FlutterI18n.translate(context, "SettingPage.order_hist"),
                style: mainTextStyle,
              ),
            ),
          ),

          // Log out button
          TextButton(
            onPressed: () {
              _auth.signOut().then((value) {
                // homepage is the initial page. if someone logs out and back in
                // the provider's page value is still the settings page (4).
                // homepage is 0.
                Provider.of<BottomNavBarBLoC>(context, listen: false)
                    .updatePage(0);
                showSnackBar(context,
                    FlutterI18n.translate(context, "SettingPage.logout"));
              });
            },
            style: ButtonStyle(
                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                backgroundColor: const MaterialStatePropertyAll(Colors.blue),
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
