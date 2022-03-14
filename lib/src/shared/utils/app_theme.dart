// global app theme
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_campus/src/shared/index.dart';

class AppTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: fieldDMFillText,
    ),
    headline1: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: fieldDMFillText,
    ),
    headline2: GoogleFonts.inter(
      fontSize: 21,
      fontWeight: FontWeight.w700,
      color: fieldDMFillText,
    ),
    headline3: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: fieldDMFillText,
    ),
    headline6: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: fieldDMFillText,
    ),
    button: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: bluishColor,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: mainWhite,
    ),
    headline1: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: mainWhite,
    ),
    headline2: GoogleFonts.inter(
      fontSize: 21,
      fontWeight: FontWeight.w700,
      color: mainWhite,
    ),
    headline3: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: mainWhite,
    ),
    headline6: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: mainWhite,
    ),
    button: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: bluishColor,
    ),
  );

  static ThemeData light() => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: bgColor,
        textTheme: lightTextTheme,
        primaryIconTheme: const IconThemeData(color: greyTextShade),
        buttonTheme: const ButtonThemeData(buttonColor: bluishColor),
      );

  static ThemeData dark() => ThemeData(
        brightness: Brightness.dark,
        textTheme: darkTextTheme,
        scaffoldBackgroundColor: darkModeMainColor,
        primaryIconTheme: const IconThemeData(color: greyTextShade),
        buttonTheme: const ButtonThemeData(buttonColor: bluishColor),
      );
}
