import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF003AA0);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF004FD2);
  static const Color background = Color(0xFFF7F9FB);
  static const Color surface = Color(0xFFF7F9FB);
  static const Color onSurface = Color(0xFF191C1E);
  static const Color onSurfaceVariant = Color(0xFF454652);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F4F6);
  static const Color outlineVariant = Color(0xFFC5C5D4);
  static const Color secondaryContainer = Color(0xFFC9CFFD);
  static const Color onSecondaryContainer = Color(0xFF51577F);
  static const Color secondaryFixed = Color(0xFFDEE0FF);
  static const Color onSecondaryFixed = Color(0xFF12183D);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF003AA0), Color(0xFF004FD2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
