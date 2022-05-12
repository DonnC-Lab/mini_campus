import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'shared/features/splash/views/onboarding_view.dart';
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
              localizationsDelegates: const [
                FormBuilderLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              home: ref
                      .watch(sharedPreferencesServiceProvider)
                      .isOnboardingComplete()
                  ? const SplashView()
                  : const OnboardingView(),
            );
          },
        );
      },
    );
  }
}
