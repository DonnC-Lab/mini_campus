import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_campus/src/shared/components/index.dart';
import 'package:mini_campus/src/shared/index.dart';

class LogInView extends ConsumerStatefulWidget {
  const LogInView({Key? key}) : super(key: key);

  @override
  _LogInViewState createState() => _LogInViewState();
}

class _LogInViewState extends ConsumerState<LogInView> {
  final emailCtlr = TextEditingController();
  final pwdCtlr = TextEditingController();

  bool fillField = true;

  bool isEmailValid = false;

  @override
  void initState() {
    super.initState();
    emailCtlr.addListener(() {
      // check for valid email

      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailCtlr.text.trim());

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
    final themeMode = ref.watch(themeNotifierProvider).value;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              themeMode == ThemeMode.light
                  ? SvgPicture.asset(
                      'assets/images/logo.svg',
                    )
                  : SvgPicture.asset(
                      'assets/images/logo_dm.svg',
                    ),
              const SizedBox(height: 30),
              Text(
                'Sign in',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(fontSize: 42),
              ),
              const SizedBox(height: 20),
              Text(
                'MiniCampus - with students at heart',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const SizedBox(height: 20),
              const Divider(color: greyTextShade),
              const SizedBox(height: 30),
              Text(
                'Continue with your student email',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              CustomFormField(
                context: context,
                formName: 'email',
                hintText: 'Your email',
                title: 'Email',
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: greyTextShade,
                ),
                suffixIcon: isEmailValid
                    ? const Icon(Icons.done, color: greenishColor)
                    : const SizedBox.shrink(),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
              ),
              CustomFormField(
                context: context,
                formName: 'password',
                hintText: 'Your password',
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                title: 'Password',
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: greyTextShade,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
              ),
              // Theme(
              //   data: Theme.of(context).copyWith(
              //     colorScheme:
              //         ThemeData().colorScheme.copyWith(primary: greyTextShade),
              //   ),
              //   child: TextField(
              //     controller: emailCtlr,
              //     decoration: InputDecoration(
              //       hintText: 'Your email',
              //       hintStyle: const TextStyle(fontWeight: FontWeight.bold),
              //       prefixIcon: const Icon(
              //         Icons.email_outlined,
              //         color: greyTextShade,
              //       ),
              //       suffix: isEmailValid
              //           ? const Icon(Icons.done, color: greenishColor)
              //           : const SizedBox.shrink(),
              //       filled: fillField,
              //       fillColor: greyTextShade.withOpacity(0.1),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: themeMode == ThemeMode.light
              //               ? greyTextShade.withOpacity(0.1)
              //               : fieldDMFillText,
              //         ),
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: const BorderSide(color: Colors.transparent),
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 30),
              // Theme(
              //   data: Theme.of(context).copyWith(
              //     colorScheme: ThemeData().colorScheme.copyWith(
              //           primary: greyTextShade,
              //         ),
              //   ),
              //   child: TextField(
              //     controller: pwdCtlr,
              //     keyboardType: TextInputType.visiblePassword,
              //     obscureText: true,
              //     decoration: InputDecoration(
              //       hintText: 'Password',
              //       hintStyle: const TextStyle(fontWeight: FontWeight.bold),
              //       prefixIcon: const Icon(
              //         Icons.lock_outline,
              //         color: greyTextShade,
              //       ),
              //       filled: fillField,
              //       fillColor: greyTextShade.withOpacity(0.1),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: themeMode == ThemeMode.light
              //               ? greyTextShade.withOpacity(0.1)
              //               : fieldDMFillText,
              //         ),
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: const BorderSide(color: Colors.transparent),
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: fillField ? bluishColorShade : bluishColor,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // ! goto HomeView
                  routeTo(context, const HomeView());
                },
                child: Text(
                  'Sign in',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              // const SizedBox(height: 35),
              // Text(
              //   FakeDataRepo.policyStatement,
              //   style: Theme.of(context).textTheme.bodyText1?.copyWith(
              //       fontWeight: FontWeight.w500, color: greyTextShade),
              // ),
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
                                  color: themeMode == ThemeMode.light
                                      ? fieldDMFillText
                                      : mainWhite,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // ! go to signup page
                            })
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
