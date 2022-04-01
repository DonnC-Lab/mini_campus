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
    hintText: hintText,
    labelText: labelText,
    labelStyle: textStyle,
    hintStyle: const TextStyle(fontWeight: FontWeight.w400),
    prefixIcon: prefixIcon,
    suffix: suffixIcon,
    filled: filled,
    fillColor: greyTextShade.withOpacity(0.1),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: themeMode == ThemeMode.light
            ? greyTextShade.withOpacity(0.1)
            : fieldDMFillText,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(8),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red.withOpacity(0.6)),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

/*
InputDecoration(
                    hintText: 'Your email',
                    hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: greyTextShade,
                    ),
                    suffix: isEmailValid
                        ? const Icon(Icons.done, color: greenishColor)
                        : const SizedBox.shrink(),
                    filled: fillField,
                    fillColor: greyTextShade.withOpacity(0.1),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: themeMode == ThemeMode.light
                            ? greyTextShade.withOpacity(0.1)
                            : fieldDMFillText,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),










=========== old ===============
InputDecoration(
    // filled: true,
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
*/
