import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';

class SplashView extends ConsumerWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<int?>(
      clockProvider,
      (int? oldValue, int? elapsed) {
        if (elapsed == 2) {
          routeToWithClear(context, const LogInView());
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
