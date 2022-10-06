import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:mini_campus_core/mini_campus_core.dart';

/// {@template profile_check}
/// check if student profile exist
///
/// if true -> check if base details are captured
/// else render complete profile page
///
/// if all basic details are not there, render profile complete
/// else, proceed to home page
/// {@endtemplate}
class ProfileCheckView extends ConsumerWidget {
  /// {@macro profile_check}
  const ProfileCheckView({
    super.key,
    required this.drawerModulePages,
    this.flavorConfigs = const {},
  });

  /// app modules drawer items
  final List<DrawerPage> drawerModulePages;

  /// app configs per current flavor
  final Map<String, dynamic> flavorConfigs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<bool?>(
          future: ref.watch(studentStoreProvider).isStudentProfileComplete(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final isProfileComplete = snapshot.data ?? false;

              if (isProfileComplete) {
                ref.read(cloudMessagingProvider).tokenSubscribe().then(
                  (_) => WidgetsBinding.instance.addPostFrameCallback((_) {
                    routeToWithClear(
                      context,
                      HomeView(
                        drawerModulePages: drawerModulePages,
                        flavorConfigs: flavorConfigs,
                      ),
                    );
                  }),
                  onError: (_) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      routeToWithClear(
                        context,
                        HomeView(
                          drawerModulePages: drawerModulePages,
                          flavorConfigs: flavorConfigs,
                        ),
                      );
                    });
                  },
                );
              }

              // e
              else {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  routeToWithClear(
                    context,
                    BasicProfileUpdateView(
                      drawerModulePages: drawerModulePages,
                    ),
                  );
                });
              }
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Center(child: LogoBox()),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        // TODO: a bit of humour, put random funny quotes
                        Text(
                          'just a sec, i forgot to check something..',
                          style:
                              Theme.of(context).textTheme.subtitle1?.copyWith(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.kGreyShadeColor,
                                  ),
                        ),
                        const SizedBox(height: 20),
                        const CircularProgressIndicator.adaptive(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
