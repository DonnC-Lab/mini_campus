import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus_core/src/providers/shared_providers.dart';

/// {@template logo_box}
/// Custom Logo Widget
///
/// A uniform logo sized box adaptive to app theme
/// {@endtemplate}
class LogoBox extends StatelessWidget {
  /// {@macro logo_box}
  const LogoBox({
    super.key,
    this.size = 140,
    this.logoDarkMode = 'assets/images/logo_dm.png',
    this.logoLightMode = 'assets/images/logo.png',
  });

  /// custom light mode logo
  final String logoLightMode;

  /// custom dark mode logo
  final String logoDarkMode;

  /// logo width and height: uniform sized box
  final double size;

  @override
  Widget build(BuildContext context) => Consumer(
        builder: (_, ref, __) {
          return SizedBox(
            height: size,
            width: size,
            child: ref.watch(themeNotifierProvider).value == ThemeMode.light
                ? Image.asset(logoLightMode)
                : Image.asset(logoLightMode),
          );
        },
      );
}
