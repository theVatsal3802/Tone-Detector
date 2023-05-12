import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Colors.green.shade700,
      onPrimary: Colors.white,
      secondary: Colors.grey.shade300,
      onSecondary: Colors.black,
      error: Colors.red.shade900,
      onError: Colors.white,
      background: Colors.white70,
      onBackground: Colors.black,
      surface: Colors.grey.shade700,
      onSurface: Colors.black,
    ),
  );
}
