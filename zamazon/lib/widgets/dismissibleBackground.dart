import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/settings_BLoC.dart';

// the items in your shopping cart and wishlist are dismissbles.
// this background appears when you swipe to delete an item.

class DismissibleBackground extends StatelessWidget {
  const DismissibleBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Provider.of<SettingsBLoC>(context).isDarkMode
            ? Colors.grey[700]
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: const [
          Spacer(),
          Icon(Icons.delete),
        ],
      ),
    );
  }
}
