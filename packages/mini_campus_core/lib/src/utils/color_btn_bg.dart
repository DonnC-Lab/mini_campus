import 'package:flutter/material.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';

/// determine toggle button color  based on theme
Color colorBtnBg({
  bool isDarkModeBtn = true,
  ThemeMode themeMode = ThemeMode.light,
}) {
  if (isDarkModeBtn) {
    if (themeMode == ThemeMode.light) {
      return Colors.transparent;
    }

    return AppColors.kDarkTextFaintColor;
  } else {
    if (themeMode == ThemeMode.dark) {
      return Colors.transparent;
    }

    return AppColors.kWhiteColor;
  }
}
