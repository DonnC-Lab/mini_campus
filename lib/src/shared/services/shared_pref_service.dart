import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesServiceProvider =
    Provider<SharedPreferencesService>((ref) => throw UnimplementedError());

class SharedPreferencesService {
  SharedPreferencesService(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  static const _kOnboardingCompleteKey = 'kOnBoarding';

  static const _kUserThemeKey = 'kUserTheme';

  static const _kUserFCMTokenKey = 'kUserFCMToken';

  static const _kTopicSetKey = 'kUserTopics';

  static const _kStudentKey = 'kStudent';

  Future<void> setOnboardingComplete() async {
    await sharedPreferences.setBool(_kOnboardingCompleteKey, true);
  }

  bool isOnboardingComplete() =>
      sharedPreferences.getBool(_kOnboardingCompleteKey) ?? false;

  Future<void> setTopicSubSetting() async {
    await sharedPreferences.setBool(_kTopicSetKey, true);
  }

  bool isUserSubToTopics() => sharedPreferences.getBool(_kTopicSetKey) ?? false;

  Future<void> setUserFcmToken(String token) async {
    await sharedPreferences.setString(_kUserFCMTokenKey, token);
  }

  String userCachedToken() =>
      sharedPreferences.getString(_kUserFCMTokenKey) ?? '';

  Future<void> setUserTheme(ThemeMode mode) async {
    if (mode == ThemeMode.light) {
      await sharedPreferences.setBool(_kUserThemeKey, true);
    } else {
      await sharedPreferences.setBool(_kUserThemeKey, false);
    }
  }

  /// return true if light mode | false - dark | null if not yet set
  bool? getCurrentUserTheme() => sharedPreferences.getBool(_kUserThemeKey);

  /// to share [Student] model across different modules universally without state management
  Future<void> setCurrentStudent(Student student) async {
    var _noTimestamp = student.toJson();

    _noTimestamp.remove('createdOn');

    await sharedPreferences.setString(_kStudentKey, jsonEncode(_noTimestamp));
  }

  /// easy way to get currently logged in `cached` student with no state management
  Student? getCachedCurrentStudent() {
    final _cs = sharedPreferences.getString(_kStudentKey);

    if (_cs == null) {
      return null;
    }

    // add date
    var _decoded = jsonDecode(_cs) as Map<String, dynamic>;

    // FIXME: fake just a quick fix
    _decoded['createdOn'] = DateTime.now();

    return Student.fromJson(_decoded);
  }
}
