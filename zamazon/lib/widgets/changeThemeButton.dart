import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/settings_BLoC.dart';

class ChangeThemeButton extends StatelessWidget {
  const ChangeThemeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsBLoC>(context);

    return Transform.scale(
      scale: 1.5, // makes the switch 50% bigger
      child: Switch.adaptive(
        value: settingsProvider.isDarkMode,
        onChanged: (value) {
          // changes the current theme to other theme,
          //i.e. light -> dark and dark -> light
          settingsProvider.toggleTheme(value);
        },
        activeThumbImage: Image.asset(
          'assets/icons/darkmode.png',
        ).image,
        // I dont like the consistent naming, should be activeThumbColor
        activeColor: Colors.black,
        activeTrackColor: Colors.white,
        inactiveThumbImage: Image.asset(
          'assets/icons/lightmode.png',
        ).image,
        inactiveThumbColor: Colors.transparent,
        inactiveTrackColor: Colors.grey,
      ),
    );
  }
}
