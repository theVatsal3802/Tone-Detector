import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color(0xff00704a),
      onPrimary: Colors.white,
      secondary: Colors.grey.shade300,
      onSecondary: const Color(0xff27251f),
      error: Colors.red.shade900,
      onError: Colors.white,
      background: Colors.white,
      onBackground: const Color(0xff27251f),
      surface: Colors.grey.shade700,
      onSurface: const Color(0xff27251f),
    ),
  );
}
