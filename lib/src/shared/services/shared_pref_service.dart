import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesServiceProvider =
    Provider<SharedPreferencesService>((ref) => throw UnimplementedError());

class SharedPreferencesService {
  SharedPreferencesService(this.sharedPreferences);
  final SharedPreferences sharedPreferences;

  static const onboardingCompleteKey = 'onboardingComplete';

  static const _kUserThemeKey = 'kUserTheme';

  Future<void> setOnboardingComplete() async {
    await sharedPreferences.setBool(onboardingCompleteKey, true);
  }

  Future<void> setUserTheme(ThemeMode mode) async {
    if (mode == ThemeMode.light) {
      await sharedPreferences.setBool(_kUserThemeKey, true);
    } else {
      await sharedPreferences.setBool(_kUserThemeKey, false);
    }
  }

  /// return true if light mode | false - dark | null if not yet set
  bool? getCurrentUserTheme() => sharedPreferences.getBool(_kUserThemeKey);

  bool isOnboardingComplete() =>
      sharedPreferences.getBool(onboardingCompleteKey) ?? false;
}
