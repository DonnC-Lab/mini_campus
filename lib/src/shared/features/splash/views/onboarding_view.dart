import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:mini_campus/src/shared/index.dart';

class OnboardingView extends ConsumerWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kHeight = MediaQuery.of(context).size.height;

    final double _imgHeight = kHeight * 0.5;

    Future<void> onDonePress() async {
      await ref.read(sharedPreferencesServiceProvider).setOnboardingComplete();

      routeToWithClear(context, const LogInView());
    }

    final titleStyle = Theme.of(context).textTheme.bodyText1?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: greyTextShade,
        );

    final descStyle = Theme.of(context).textTheme.bodyText2?.copyWith(
          fontSize: 15,
          color: greyTextShade,
        );

    final List<Slide> _slides = [
      Slide(
        title: "MINI-CAMPUS",
        description:
            "An all-in-one students-only app packed with features that brings convinience and smooth campus life just for you",
        pathImage: "assets/onboarding/students.png",
        backgroundColor: mainWhite,
        styleTitle: titleStyle,
        heightImage: _imgHeight,
        styleDescription: descStyle,
      ),
      Slide(
        title: "LEARNING",
        description:
            "Peer-to-peer sharing of learning materials. Easily find latest revision materials",
        pathImage: "assets/onboarding/learning.png",
        backgroundColor: mainWhite,
        heightImage: _imgHeight,
        styleTitle: titleStyle,
        styleDescription: descStyle,
      ),
      Slide(
        title: "MARKET",
        description:
            "Keep campus deals afresh with no boundaries, reach out to all campus friends and potential dealers",
        pathImage: "assets/onboarding/market.png",
        backgroundColor: mainWhite,
        styleTitle: titleStyle,
        heightImage: _imgHeight,
        styleDescription: descStyle,
      ),
      Slide(
        title: "SURVEY",
        description:
            "Having a questionnaire? Easily get it filled up by help from peers and much more..",
        pathImage: "assets/onboarding/survey.png",
        backgroundColor: mainWhite,
        styleTitle: titleStyle,
        heightImage: _imgHeight,
        styleDescription: descStyle,
      ),
    ];

    return IntroSlider(
      slides: _slides,
      onDonePress: onDonePress,
      onSkipPress: onDonePress,
      colorDot: greyTextShade,
      colorActiveDot: bluishColor,
      doneButtonStyle:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(bluishColor)),
      nextButtonStyle:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(bluishColor)),
      skipButtonStyle:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(bluishColor)),
    );
  }
}
