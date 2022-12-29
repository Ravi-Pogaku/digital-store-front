// function to show snackbar because all our snackbars were just text
// so I made a helper function to reduce the repeated code.

import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: const TextStyle(fontSize: 25),
      ),
    ),
  );
}
