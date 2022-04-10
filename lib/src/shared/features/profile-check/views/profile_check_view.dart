// check if student profile exist
// if true -> check if base details are captured, else render complete profile page
// if all basic details are not there, render profile complete else, proceed to home page

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';

class ProfileCheckView extends ConsumerStatefulWidget {
  const ProfileCheckView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileCheckViewState();
}

class _ProfileCheckViewState extends ConsumerState<ProfileCheckView> {
  late bool isProfileComplete;
  bool isLoading = false;

  Future<bool?> _checkProfile() async {
    var res = await ref.watch(studentStoreProvider).isStudentProfileComplete();

    return res;
  }

  Future<void> _handler() async {
    String? token = await ref.read(fbMsgProvider).getToken();

    // update user token
    if (token != null) {
      await ref.watch(studentStoreProvider).addNotificationToken(token);
    }

    // subscribe to topics
    await ref.watch(fbMsgProvider).subscribe();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      routeToWithClear(context, const HomeView());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<bool?>(
          future: _checkProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              bool isProfileComplete = snapshot.data ?? false;

              if (isProfileComplete) {
                _handler();
              }

              // e
              else {
                // go to profile update page
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  routeToWithClear(context, const BasicProfileUpdateView());
                });
              }
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: Pulse(
                      infinite: true,
                      child: Text(
                        'Mini Campus',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: greyTextShade),
                      ),
                    ),
                  ),
                  const CircularProgressIndicator(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
