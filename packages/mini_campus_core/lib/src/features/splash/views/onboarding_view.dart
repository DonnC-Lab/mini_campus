import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:mini_campus_core/mini_campus_core.dart';

/// app initial onboarding view
///
/// used to onboard student to different main
/// app features
class OnboardingView extends ConsumerWidget {
  /// onboarding
  const OnboardingView({
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
    final kHeight = MediaQuery.of(context).size.height;

    final _imgHeight = kHeight * 0.5;

    Future<void> onDonePress() async {
      await ref.read(sharedPreferencesServiceProvider).setOnboardingComplete();

      routeToWithClear(
        context,
        LogInView(
          drawerModulePages: drawerModulePages,
          flavorConfigs: flavorConfigs,
        ),
      );
    }

    final titleStyle = Theme.of(context).textTheme.bodyText1?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: AppColors.kGreyShadeColor,
        );

    final descStyle = Theme.of(context).textTheme.bodyText2?.copyWith(
          fontSize: 15,
          color: AppColors.kGreyShadeColor,
        );

    final _slides = <ContentConfig>[
      ContentConfig(
        title: 'MINI-CAMPUS',
        description:
            'An all-in-one students-only app packed with features that brings '
            'convinience and smooth campus life just for you',
        pathImage: 'assets/onboarding/students.png',
        backgroundColor: AppColors.kWhiteColor,
        styleTitle: titleStyle,
        heightImage: _imgHeight,
        styleDescription: descStyle,
      ),
      ContentConfig(
        title: 'LEARNING',
        description: 'Peer-to-peer sharing of learning materials. '
            'Easily find latest revision materials',
        pathImage: 'assets/onboarding/learning.png',
        backgroundColor: AppColors.kWhiteColor,
        heightImage: _imgHeight,
        styleTitle: titleStyle,
        styleDescription: descStyle,
      ),
      ContentConfig(
        title: 'MARKET',
        description:
            'Keep campus deals afresh with no boundaries, reach out to '
            'all campus friends and potential dealers',
        pathImage: 'assets/onboarding/market.png',
        backgroundColor: AppColors.kWhiteColor,
        styleTitle: titleStyle,
        heightImage: _imgHeight,
        styleDescription: descStyle,
      ),
      ContentConfig(
        title: 'SURVEY',
        description: 'Having a questionnaire? Easily get it filled up by'
            ' help from peers and much more..',
        pathImage: 'assets/onboarding/survey.png',
        backgroundColor: AppColors.kWhiteColor,
        styleTitle: titleStyle,
        heightImage: _imgHeight,
        styleDescription: descStyle,
      ),
    ];

    return IntroSlider(
      listContentConfig: _slides,
      onDonePress: onDonePress,
      onSkipPress: onDonePress,
      indicatorConfig: const IndicatorConfig(
        colorIndicator: AppColors.kGreyShadeColor,
        colorActiveIndicator: AppColors.kPrimaryColor,
      ),
      doneButtonStyle: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(color: AppColors.kWhiteColor),
        ),
        backgroundColor: MaterialStateProperty.all(AppColors.kPrimaryColor),
      ),
      nextButtonStyle: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(color: AppColors.kWhiteColor),
        ),
        backgroundColor: MaterialStateProperty.all(AppColors.kPrimaryColor),
      ),
      skipButtonStyle: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(color: AppColors.kWhiteColor),
        ),
        backgroundColor: MaterialStateProperty.all(AppColors.kPrimaryColor),
      ),
    );
  }
}
