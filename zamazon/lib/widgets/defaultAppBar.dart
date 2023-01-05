import 'package:flutter/material.dart';

// helper function to create appbar. Used in multiple pages so I made it
// a class

class DefaultAppBar extends StatelessWidget with PreferredSizeWidget {
  const DefaultAppBar({
    super.key,
    this.title,
    this.backgroundColor,
    this.foregroundColor,
  });

  final Widget? title;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: backgroundColor ?? Colors.orange,
      foregroundColor: foregroundColor ?? Colors.black,
      elevation: 0,
      title: title,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
