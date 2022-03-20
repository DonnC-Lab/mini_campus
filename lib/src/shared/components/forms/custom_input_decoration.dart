// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mini_campus/src/shared/index.dart';

InputDecoration CustomInputDecoration({
  required double radius,
  required TextStyle textStyle,
  String? labelText,
  String? hintText,
  Widget? suffixIcon,
  Widget? prefixIcon,
  bool filled = true,
  ThemeMode themeMode = ThemeMode.system,
}) {
  return InputDecoration(
    filled: true,
    labelText: labelText,
    fillColor: themeMode == ThemeMode.light
        ? bgColor
        // ? fieldFillColor
        : darkModeMainColor,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(
          color: themeMode == ThemeMode.light ? mainWhite : fieldDMFillText),
    ),
    hintText: hintText,
    labelStyle: textStyle,
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
    hintStyle: const TextStyle(fontWeight: FontWeight.bold),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: greyTextShade),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: const BorderSide(color: Colors.red),
    ),
  );
}
