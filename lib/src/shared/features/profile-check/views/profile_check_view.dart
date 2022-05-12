// check if student profile exist
// if true -> check if base details are captured, else render complete profile page
// if all basic details are not there, render profile complete else, proceed to home page

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';

class ProfileCheckView extends ConsumerWidget {
  const ProfileCheckView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider).value;

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<bool?>(
          future: ref.watch(studentStoreProvider).isStudentProfileComplete(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              bool isProfileComplete = snapshot.data ?? false;

              if (isProfileComplete) {
                ref.read(fbMsgProvider).getToken().then(
                  (value) => WidgetsBinding.instance?.addPostFrameCallback((_) {
                    routeToWithClear(context, const HomeView());
                  }),
                  onError: (_) {
                    WidgetsBinding.instance?.addPostFrameCallback((_) {
                      routeToWithClear(context, const HomeView());
                    });
                  },
                );
              }

              // e
              else {
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  routeToWithClear(context, BasicProfileUpdateView());
                });
              }
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(child: LogoBox(themeMode: themeMode)),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        // todo, a bit of humour, put random funny quotes
                        Text(
                          'just a sec, i forgot to check something..',
                          style:
                              Theme.of(context).textTheme.subtitle1?.copyWith(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: greyTextShade,
                                  ),
                        ),
                        const SizedBox(height: 20),
                        const CircularProgressIndicator(),
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
