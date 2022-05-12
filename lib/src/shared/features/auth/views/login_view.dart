import 'package:flash/flash.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:mini_campus/src/shared/libs/index.dart';
import 'package:relative_scale/relative_scale.dart';

import 'register_view.dart';
import 'social_btn.dart';

class LogInView extends ConsumerStatefulWidget {
  const LogInView({Key? key}) : super(key: key);

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
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailCtlr.text.trim());

      // todo check for student domain on email here
      if (emailValid) {
        setState(() {
          isEmailValid = true;
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
    final auth = ref.read(fbAuthProvider);
    final gAuth = ref.read(googleAuthProvider);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: RelativeBuilder(builder: (context, height, width, sy, sx) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LogoBox(themeMode: themeMode),
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
                SocialBtn(
                  asset: 'assets/images/google.svg',
                  name: 'Student Google Account',
                  onTap: () async {
                    modalLoader(context);

                    final result = await gAuth.signInWithGoogle();

                    Navigator.of(context, rootNavigator: true).pop();

                    if (result is CustomException) {
                      _dialog.showBasicsFlash(
                        context,
                        flashStyle: FlashBehavior.fixed,
                        mesg: result.message ??
                            'failed to sign in with device student google account',
                      );
                    }

                    // success
                    else {
                      ref.watch(fbAppUserProvider.notifier).state = result;

                      routeToWithClear(context, const ProfileCheckView());
                    }
                  },
                ),
                Divider(color: greyTextShade, height: sy(50)),
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
                        .copyWith(primary: greyTextShade),
                  ),
                  child: TextField(
                    controller: emailCtlr,
                    decoration: InputDecoration(
                      hintText: 'Your email',
                      hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: greyTextShade,
                      ),
                      suffix: isEmailValid
                          ? const Icon(Icons.done, color: greenishColor)
                          : const SizedBox.shrink(),
                      filled: fillField,
                      fillColor: greyTextShade.withOpacity(0.1),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeMode == ThemeMode.light
                              ? greyTextShade.withOpacity(0.1)
                              : fieldDMFillText,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ThemeData().colorScheme.copyWith(
                          primary: greyTextShade,
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
                        color: greyTextShade,
                      ),
                      filled: fillField,
                      fillColor: greyTextShade.withOpacity(0.1),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeMode == ThemeMode.light
                              ? greyTextShade.withOpacity(0.1)
                              : fieldDMFillText,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
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
                        _dialog.showBasicsFlash(
                          context,
                          mesg: 'email or password is required to continue',
                        );
                        return;
                      }

                      if (!isEmailValid) {
                        _dialog.showBasicsFlash(
                          context,
                          mesg: 'a valid student email is required to continue',
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
                        _dialog.showBasicsFlash(
                          context,
                          flashStyle: FlashBehavior.fixed,
                          mesg:
                              result.message ?? 'failed to sign in to account',
                        );
                      }

                      // success
                      else {
                        ref.watch(fbAppUserProvider.notifier).state = result;

                        routeToWithClear(context, const ProfileCheckView());
                      }
                    },
                  ),
                ),
                const SizedBox(height: 45),
                RichText(
                  text: TextSpan(
                      text: 'Don\'t have an account?',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.w500, color: greyTextShade),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Sign up',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .appBarTheme
                                        .backgroundColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                routeToWithClear(context, const RegisterView());
                              })
                      ]),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
