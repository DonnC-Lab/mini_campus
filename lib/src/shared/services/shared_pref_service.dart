import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
}
