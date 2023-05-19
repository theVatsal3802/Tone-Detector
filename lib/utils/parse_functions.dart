import 'package:flutter/material.dart';

class ParseFunctions {
  static String getDate({required DateTime date}) {
    String myDate = "${date.day}/${date.month}/${date.year}";
    return myDate;
  }

  static void showSnackbar({
    required String text,
    required BuildContext context,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          textScaleFactor: 1,
        ),
      ),
    );
  }
}
