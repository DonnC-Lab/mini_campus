import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'shared/features/admin/pages/home.dart';
import 'shared/index.dart';

class MainAppEntry extends StatelessWidget {
  const MainAppEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final _notifier = ref.watch(themeNotifierProvider);

        return ValueListenableBuilder(
          valueListenable: _notifier,
          builder: (ctx, ThemeMode mode, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MiniCampus',
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: mode,
              //home: const SplashView(),
              home: const AdminHomeView(),
            );
          },
        );
      },
    );
  }
}
