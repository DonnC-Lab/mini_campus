import 'dart:convert';

import 'package:flutter/material.dart' show ThemeMode;
import 'package:mini_campus_core/src/models/profile/student.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// common [SharedPreferences] helper service class
class SharedPreferencesService {
  /// common [SharedPreferences] helper service class
  SharedPreferencesService(this.sharedPreferences);

  /// [SharedPreferences] instance
  final SharedPreferences sharedPreferences;

  static const _kOnboardingCompleteKey = 'kOnBoarding';

  static const _kUserThemeKey = 'kUserTheme';

  static const _kUserFCMTokenKey = 'kUserFCMToken';

  static const _kStudentKey = 'kStudent';

  /// set onboarding flag to true
  Future<void> setOnboardingComplete() async {
    await sharedPreferences.setBool(_kOnboardingCompleteKey, true);
  }

  /// [bool] flag to check onboarding status
  bool isOnboardingComplete() =>
      sharedPreferences.getBool(_kOnboardingCompleteKey) ?? false;

  /// set user firebase device token
  Future<void> setUserFcmToken(String token) async {
    await sharedPreferences.setString(_kUserFCMTokenKey, token);
  }

  /// get cached firebase device token, return empty string if
  /// absent
  String userCachedToken() =>
      sharedPreferences.getString(_kUserFCMTokenKey) ?? '';

  /// cache current user theme setting
  Future<void> setUserTheme(ThemeMode mode) async {
    if (mode == ThemeMode.light) {
      await sharedPreferences.setBool(_kUserThemeKey, true);
    } else {
      await sharedPreferences.setBool(_kUserThemeKey, false);
    }
  }

  /// return true if light mode | false - dark | null if not yet set
  bool? getCurrentUserTheme() => sharedPreferences.getBool(_kUserThemeKey);

  /// cache [Student] model across different modules
  /// universally without state management
  Future<void> setCurrentStudent(Student student) async {
    final _noTimestamp = student.toJson()..remove('createdOn');

    await sharedPreferences.setString(_kStudentKey, jsonEncode(_noTimestamp));
  }

  /// easy way to get currently logged in `cached` student
  /// with no state management
  Student? getCachedCurrentStudent() {
    final _cs = sharedPreferences.getString(_kStudentKey);

    if (_cs == null) {
      return null;
    }

    // add date
    final _decoded = jsonDecode(_cs) as Map<String, dynamic>;

    // FIXME: fake just a quick fix
    _decoded['createdOn'] = DateTime.now();

    return Student.fromJson(_decoded);
  }
}
