// global app theme
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';

/// app [ThemeData] class
class AppTheme {
  /// app light theme
  static TextTheme lightTextTheme = TextTheme(
    bodyText1: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.kDarkFillColor,
    ),
    headline1: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.kDarkFillColor,
    ),
    headline2: GoogleFonts.inter(
      fontSize: 21,
      fontWeight: FontWeight.w700,
      color: AppColors.kDarkFillColor,
    ),
    headline3: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.kDarkFillColor,
    ),
    headline6: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.kDarkFillColor,
    ),
    button: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.kPrimaryColor,
    ),
  );

  /// dark theme
  static TextTheme darkTextTheme = TextTheme(
    bodyText1: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.kWhiteColor,
    ),
    headline1: GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.kWhiteColor,
    ),
    headline2: GoogleFonts.inter(
      fontSize: 21,
      fontWeight: FontWeight.w700,
      color: AppColors.kWhiteColor,
    ),
    headline3: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.kWhiteColor,
    ),
    headline6: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.kWhiteColor,
    ),
    button: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.kPrimaryColor,
    ),
  );

  /// main light mode theme
  static ThemeData light() => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.kLightBgColor,
        textTheme: lightTextTheme,
        primaryIconTheme: const IconThemeData(color: AppColors.kGreyShadeColor),
        buttonTheme:
            const ButtonThemeData(buttonColor: AppColors.kPrimaryColor),
        appBarTheme: const AppBarTheme(color: AppColors.kPrimaryColor),
      );

  /// main dark mode theme
  static ThemeData dark() => ThemeData(
        brightness: Brightness.dark,
        textTheme: darkTextTheme,
        scaffoldBackgroundColor: AppColors.kDarkMainColor,
        primaryIconTheme: const IconThemeData(color: AppColors.kGreyShadeColor),
        buttonTheme:
            const ButtonThemeData(buttonColor: AppColors.kPrimaryColor),
        appBarTheme: const AppBarTheme(color: AppColors.kPrimaryColor),
      );
}
