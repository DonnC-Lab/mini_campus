import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_campus/src/drawer_module_pages.dart';
import 'package:mini_campus_core/mini_campus_core.dart';

class MainAppEntry extends StatelessWidget {
  const MainAppEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final _notifier = ref.watch(themeNotifierProvider);

        return FlavorBanner(
          location: BannerLocation.bottomEnd,
          child: ValueListenableBuilder(
            valueListenable: _notifier,
            builder: (ctx, ThemeMode mode, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: FlavorConfig.instance.variables["appTitle"],
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
                    ? SplashView(
                        drawerModulePages: drawerModulePages,
                        flavorConfigs: FlavorConfig.instance.variables,
                      )
                    : OnboardingView(
                        drawerModulePages: drawerModulePages,
                        flavorConfigs: FlavorConfig.instance.variables,
                      ),
              );
            },
          ),
        );
      },
    );
  }
}
