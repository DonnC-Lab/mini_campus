// check if student profile exist
// if true -> check if base details are captured, else render complete profile page
// if all basic details are not there, render profile complete else, proceed to home page

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/components/index.dart';
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

  Future<void> _checkProfile() async {
    setState(() {
      isLoading = true;
    });

    var res = await ref.watch(studentStoreProvider).isStudentProfileComplete();

    setState(() {
      isProfileComplete = res ?? false;
      isLoading = false;
    });

    // pop nav
    Navigator.of(context, rootNavigator: true).pop();

    if (isProfileComplete) {
      routeToWithClear(context, const HomeView());
    } else {
      // go to profile update page
      routeToWithClear(context, const BasicProfileUpdateView());
    }
  }

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? modalLoader(context)
          : Center(
              child: Pulse(
                infinite: true,
                child: const Text('Mini Campus'),
              ),
            ),
    );
  }
}
