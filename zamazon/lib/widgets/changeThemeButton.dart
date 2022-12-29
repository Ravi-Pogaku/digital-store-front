import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/themeBLoC.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({
    super.key,
    required this.refreshParent,
  });

  // function that setstates in the parent of this widget.
  final Function refreshParent;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeBLoC>(context);

    // bool isDarkMode = themeProvider.isDarkMode;

    return Switch.adaptive(
      value: themeProvider.isDarkMode,
      onChanged: (value) {
        final themeProvider = Provider.of<ThemeBLoC>(context, listen: false);

        themeProvider.toggleTheme(value);

        // isDarkMode = themeProvider.isDarkMode;

        // the settings page sometimes gets stuck on the previous theme
        // setstateing in the settings page seems to fix this.
        refreshParent();
      },
    );
  }
}
