import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';

class DrawerThemeSwitcher extends ConsumerWidget {
  const DrawerThemeSwitcher({Key? key}) : super(key: key);

  @override
   Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider).value;
    
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: themeMode == ThemeMode.light ? bgColor : fieldDMFillText,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: themeSwitchButton(
              context: context,
              callback: () => ref.read(themeNotifierProvider).value =
                  themeMode == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light,
              bgColor: colorBtnBg(false, themeMode),
              icon: Icons.light_mode,
              title: 'Light',
            ),
          ),
          Expanded(
            child: themeSwitchButton(
              context: context,
              callback: () => ref.read(themeNotifierProvider).value =
                  themeMode == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light,
              bgColor: colorBtnBg(true, themeMode),
              icon: Icons.dark_mode,
              title: 'Dark',
            ),
          ),
        ],
      ),
    );
  }
}
