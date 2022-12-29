import 'package:flutter/material.dart';
import 'package:zamazon/widgets/customSearchDelegate.dart';
import 'package:zamazon/views/ProductPage.dart';
import 'package:zamazon/globals.dart';

// helper function to create appbar. Used in multiple pages so I made it
// a class

class DefaultAppBar extends StatelessWidget with PreferredSizeWidget {
  const DefaultAppBar(
    BuildContext context, {
    super.key,
    this.title,
  });

  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.orange,
      foregroundColor: Colors.black,
      elevation: 0,
      title: title ?? Container(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
