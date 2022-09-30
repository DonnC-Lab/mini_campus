import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:mini_campus_core/mini_campus_core.dart';

/// custom [Theme] switcher widget
///
/// switch between light and dark app theme mode
class DrawerThemeSwitcher extends ConsumerWidget {
  const DrawerThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider).value;
    final pref = ref.read(sharedPreferencesServiceProvider);

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: themeMode == ThemeMode.light
            ? AppColors.kLightBgColor
            : AppColors.kTextFieldFillColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: themeSwitchButton(
              context: context,
              callback: () async {
                final currentMode = themeMode == ThemeMode.light
                    ? ThemeMode.dark
                    : ThemeMode.light;

                ref.read(themeNotifierProvider).value = currentMode;

                await pref.setUserTheme(currentMode);
              },
              bgColor: colorBtnBg(isDarkModeBtn: false, themeMode: themeMode),
              icon: Icons.light_mode,
              title: 'Light',
            ),
          ),
          Expanded(
            child: themeSwitchButton(
              context: context,
              callback: () async {
                final currentMode = themeMode == ThemeMode.light
                    ? ThemeMode.dark
                    : ThemeMode.light;

                ref.read(themeNotifierProvider).value = currentMode;

                await pref.setUserTheme(currentMode);
              },
              bgColor: colorBtnBg(themeMode: themeMode),
              icon: Icons.dark_mode,
              title: 'Dark',
            ),
          ),
        ],
      ),
    );
  }
}
