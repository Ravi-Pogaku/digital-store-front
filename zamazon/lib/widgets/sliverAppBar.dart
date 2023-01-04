import 'package:flutter/material.dart';

// sliver app bar for nestedScrollView in homepage.dart.
// required for cool hiding and reappearing appbar

class MySliverAppBar extends StatelessWidget {
  const MySliverAppBar({super.key, required this.title, this.actions});

  final Widget title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      backgroundColor: Colors.orange,
      foregroundColor: Colors.black,
      elevation: 0.0,
      title: title,
      actions: actions,
    );
  }
}
