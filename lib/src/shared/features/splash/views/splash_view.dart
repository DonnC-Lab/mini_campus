import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:mini_campus/src/shared/libs/index.dart';

class SplashView extends ConsumerWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(fbAuthProvider);

    ref.listen<int?>(
      clockProvider,
      (int? oldValue, int? elapsed) {
        if (elapsed == 2) {
          // check if user is already logged
          var isCurrentlyLogged = auth.checkCurrentUser;

          //debugLogger(isCurrentlyLogged, name: 'splashView');

          if (isCurrentlyLogged == null) {
            routeToWithClear(context, const LogInView());
          } else {
            ref.watch(fbAppUserProvider.notifier).state = AppFbUser(
              uid: isCurrentlyLogged.uid,
              email: isCurrentlyLogged.email!,
              photoURL: isCurrentlyLogged.photoURL,
              displayName: isCurrentlyLogged.displayName,
            );

            routeToWithClear(context, const ProfileCheckView());
          }
        }
      },
    );

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ZoomIn(child: const Text('Mini Campus')),
        ),
      ),
    );
  }
}
