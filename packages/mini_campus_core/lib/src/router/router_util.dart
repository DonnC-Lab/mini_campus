// a handy navigation function
import 'package:circular_clip_route/circular_clip_route.dart';
import 'package:flutter/material.dart';
import 'package:mini_campus_core/src/features/splash/views/splash_view.dart';
import 'package:mini_campus_core/src/models/drawer_page.dart';
import 'package:page_transition/page_transition.dart';

/// go to [routeTo] widget page
void routeTo(
  BuildContext context,
  Widget routeTo, {
  PageTransitionType transition = PageTransitionType.leftToRight,
  bool showTransition = true,
}) {
  Navigator.of(context).push(
    showTransition
        ? PageTransition<dynamic>(type: transition, child: routeTo)
        : MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => routeTo,
          ),
  );
}

/// go to profile
void routeToProfile(
  BuildContext context,
  BuildContext gContext,
  Widget routeTo,
) {
  Navigator.push(
    context,
    CircularClipRoute<void>(
      builder: (context) => routeTo,
      expandFrom: gContext,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastOutSlowIn.flipped,
      opacity: ConstantTween(1),
      transitionDuration: const Duration(seconds: 1),
    ),
  );
}

/// route to next view while clearing navigation history
void routeToWithClear(
  BuildContext context,
  Widget routeTo, {
  PageTransitionType transition = PageTransitionType.leftToRight,
}) {
  Navigator.of(context).pushReplacement(
    PageTransition<void>(type: transition, child: routeTo),
  );
}

/// pop navigation stack
void routeBack(BuildContext context) {
  return Navigator.of(context).pop();
}

/// route back to splash screen
void routeBackWithClear(
  BuildContext context, {
  List<DrawerPage> drawerPages = const [],
}) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<dynamic>(
      builder: (c) => SplashView(drawerModulePages: drawerPages),
    ),
    (route) => false,
  );
}
