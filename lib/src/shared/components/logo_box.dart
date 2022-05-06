import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';

class LogoBox extends StatelessWidget {
  const LogoBox({
    Key? key,
    this.themeMode = ThemeMode.light,
    this.size = 140,
  }) : super(key: key);

  final ThemeMode themeMode;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      return SizedBox(
        height: size,
        width: size,
        child: ref.watch(themeNotifierProvider).value == ThemeMode.light
            ? Image.asset('assets/images/logo.png')
            : Image.asset('assets/images/logo_dm.png'),
      );
    });
  }
}
