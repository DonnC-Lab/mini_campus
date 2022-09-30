import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus_core/mini_campus_core.dart';
import 'package:mini_campus_services/mini_campus_services.dart';

/// custom app splash view
///
/// auto navigate to another page after 2 seconds
class SplashView extends ConsumerWidget {
  ///
  const SplashView({
    super.key,
    required this.drawerModulePages,
    this.flavorConfigs = const {},
  });

  /// modules drawer items
  final List<DrawerPage> drawerModulePages;

  /// configs per current flavor
  final Map<String, dynamic> flavorConfigs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthServiceProvider);

    ref.listen<int?>(
      clockProvider,
      (int? oldValue, int? elapsed) {
        if (elapsed == 2) {
          final isCurrentlyLogged = auth.getUser;

          if (isCurrentlyLogged == null) {
            routeToWithClear(
              context,
              LogInView(
                drawerModulePages: drawerModulePages,
                flavorConfigs: flavorConfigs,
              ),
            );
          } else {
            ref.watch(fbAppUserProvider.notifier).state = AppFbUser(
              uid: isCurrentlyLogged.uid,
              email: isCurrentlyLogged.email!,
              photoURL: isCurrentlyLogged.photoURL,
              displayName: isCurrentlyLogged.displayName,
            );

            routeToWithClear(
              context,
              ProfileCheckView(
                drawerModulePages: drawerModulePages,
                flavorConfigs: flavorConfigs,
              ),
            );
          }
        }
      },
    );

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Center(child: LogoBox()),
              Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator.adaptive(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
