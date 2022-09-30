import 'package:flash/flash.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus_components/mini_campus_components.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:mini_campus_core/mini_campus_core.dart';
import 'package:mini_campus_core/src/features/auth/views/social_btn.dart';
import 'package:mini_campus_services/mini_campus_services.dart';
import 'package:relative_scale/relative_scale.dart';

class LogInView extends ConsumerStatefulWidget {
  const LogInView({
    super.key,
    this.logoLightMode,
    this.logoDarkMode,
    required this.drawerModulePages,
    this.flavorConfigs = const {},
  });

  final List<DrawerPage> drawerModulePages;
  final Map<String, dynamic> flavorConfigs;

  final String? logoLightMode;
  final String? logoDarkMode;

  @override
  _LogInViewState createState() => _LogInViewState();
}

class _LogInViewState extends ConsumerState<LogInView> {
  final emailCtlr = TextEditingController();
  final pwdCtlr = TextEditingController();

  bool obscure = true;

  bool fillField = true;

  bool isEmailValid = false;

  @override
  void initState() {
    super.initState();
    emailCtlr.addListener(() {
      final emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(emailCtlr.text.trim());

      final validStudentEmail = emailCtlr.text.isValidStudentEmailAddress;

      if (emailValid && validStudentEmail) {
        setState(() {
          isEmailValid = true;
        });
      } else {
        setState(() {
          isEmailValid = false;
        });
      }
    });
  }

  @override
  void dispose() {
    emailCtlr.dispose();
    pwdCtlr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _dialog = ref.read(dialogProvider);
    final themeMode = ref.watch(themeNotifierProvider.notifier).state.value;
    final auth = ref.read(firebaseAuthServiceProvider);
    final gAuth = ref.read(googleAuthProvider);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: RelativeBuilder(
            builder: (context, height, width, sy, sx) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LogoBox(
                      // logoDarkMode: widget.logoDarkMode,
                      // logoLightMode: widget.logoLightMode,
                      ),
                  const SizedBox(height: 20),
                  Text(
                    'Sign in',
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        ?.copyWith(fontSize: 42),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'MiniCampus - with students at heart',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Use linked device account',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  SocialButton(
                    asset: 'assets/images/google.svg',
                    name: 'Student Google Account',
                    onTap: () async {
                      modalLoader(context);

                      final result = await gAuth.signInWithGoogle();

                      Navigator.of(context, rootNavigator: true).pop();

                      if (result is CustomException) {
                        _dialog.showBasicFlash(
                          context,
                          flashStyle: FlashBehavior.fixed,
                          mesg: result.message ??
                              'failed to sign in with device student google account',
                        );
                      }

                      // success
                      else {
                        ref.watch(fbAppUserProvider.notifier).state =
                            result as AppFbUser?;

                        routeToWithClear(
                          context,
                          ProfileCheckView(
                            drawerModulePages: widget.drawerModulePages,
                            flavorConfigs: widget.flavorConfigs,
                          ),
                        );
                      }
                    },
                  ),
                  Divider(color: AppColors.kGreyShadeColor, height: sy(50)),
                  Text(
                    'Or continue with student email',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ThemeData()
                          .colorScheme
                          .copyWith(primary: AppColors.kGreyShadeColor),
                    ),
                    child: TextField(
                      controller: emailCtlr,
                      decoration: InputDecoration(
                        hintText: 'Your email',
                        hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: AppColors.kGreyShadeColor,
                        ),
                        suffix: isEmailValid
                            ? const Icon(
                                Icons.sentiment_very_satisfied,
                                color: AppColors.kGreenIndicatorColor,
                              )
                            : const Icon(
                                Icons.sentiment_dissatisfied,
                                color: AppColors.kRedIndicatorColor,
                              ),
                        filled: fillField,
                        fillColor: AppColors.kGreyShadeColor.withOpacity(0.1),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: themeMode == ThemeMode.light
                                ? AppColors.kGreyShadeColor.withOpacity(0.1)
                                : AppColors.kTextFieldFillColor,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ThemeData().colorScheme.copyWith(
                            primary: AppColors.kGreyShadeColor,
                          ),
                    ),
                    child: TextField(
                      controller: pwdCtlr,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.kGreyShadeColor,
                        ),
                        filled: fillField,
                        fillColor: AppColors.kGreyShadeColor.withOpacity(0.1),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: themeMode == ThemeMode.light
                                ? AppColors.kGreyShadeColor.withOpacity(0.1)
                                : AppColors.kTextFieldFillColor,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: sy(30)),
                  Center(
                    child: CustomRoundedButton(
                      text: 'Sign In',
                      onTap: () async {
                        if (emailCtlr.text.isEmpty && pwdCtlr.text.isEmpty) {
                          _dialog.showBasicFlash(
                            context,
                            mesg: 'email or password is required to continue',
                          );
                          return;
                        }

                        if (!isEmailValid) {
                          _dialog.showBasicFlash(
                            context,
                            mesg:
                                'a valid student email is required to continue',
                          );
                          return;
                        }

                        modalLoader(context);

                        final result = await auth.signInWithEmailAndPassword(
                          emailCtlr.text.trim().toLowerCase(),
                          pwdCtlr.text.trim(),
                        );

                        Navigator.of(context, rootNavigator: true).pop();

                        if (result is CustomException) {
                          _dialog.showBasicFlash(
                            context,
                            flashStyle: FlashBehavior.fixed,
                            mesg: result.message ??
                                'failed to sign in to account',
                          );
                        }

                        // success
                        else {
                          ref.watch(fbAppUserProvider.notifier).state =
                              result as AppFbUser?;

                          routeToWithClear(
                            context,
                            ProfileCheckView(
                              drawerModulePages: widget.drawerModulePages,
                              flavorConfigs: widget.flavorConfigs,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 45),
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account?",
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.kGreyShadeColor,
                          ),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Sign up',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    color: Theme.of(context)
                                        .appBarTheme
                                        .backgroundColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              routeTo(
                                context,
                                RegisterView(
                                  drawerModulePages: widget.drawerModulePages,
                                ),
                              );
                            },
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
