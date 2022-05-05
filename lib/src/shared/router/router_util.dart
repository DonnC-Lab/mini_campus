// a handy navigation function
import 'package:circular_clip_route/circular_clip_route.dart';
import 'package:flutter/material.dart';
import 'package:mini_campus/src/shared/features/splash/views/splash_view.dart';
import 'package:page_transition/page_transition.dart';

// go to [routeTo] widget page
routeTo(BuildContext context, Widget routeTo,
    {PageTransitionType transition = PageTransitionType.leftToRight,
    bool showTransition = true}) {
  return Navigator.of(context).push(
    showTransition
        ? PageTransition(
            type: transition,
            child: routeTo
          )
        : MaterialPageRoute(
            builder: (BuildContext context) => routeTo
          ),
  );
}

routeToProfile(BuildContext context, var gContext, Widget routeTo) {
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
routeToWithClear(BuildContext context, Widget routeTo,
    {PageTransitionType transition = PageTransitionType.leftToRight}) {
  return Navigator.of(context).pushReplacement(
    PageTransition(type: transition, child: routeTo),
  );
}

routeBack(BuildContext context) {
  return Navigator.of(context).pop();
}

/// route back to splash screen
routeBackWithClear(BuildContext context) {
  return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (c) => const SplashView()), (route) => false);
}
