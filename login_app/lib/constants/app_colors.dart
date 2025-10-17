import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color red = Colors.red;
  static const Color green = Colors.green;

  // Background colors
  static const Color background = Colors.white;
  static const Color onBackground = Colors.black;

  // Primary colors
  static const Color primary = Color.fromRGBO(206, 147, 216, 1);
  static const Color onPrimary = Colors.black;

  // Secondary colors
  static const Color secondary = Color.fromRGBO(244, 143, 177, 1);
  static const Color onSecondary = Colors.white;

  // Tertiary colors
  static const Color tertiary = Color.fromRGBO(255, 204, 128, 1);

  // Outline colors
  static const Color outline = Color(0xFF424242);

  // ColorScheme
  static const ColorScheme lightColorScheme = ColorScheme.light(
    background: background,
    onBackground: onBackground,
    primary: primary,
    onPrimary: onPrimary,
    secondary: secondary,
    onSecondary: onSecondary,
    tertiary: tertiary,
    error: red,
    outline: outline,
  );
}
