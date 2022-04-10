import 'package:flash/flash.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_campus/src/shared/components/index.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:mini_campus/src/shared/libs/index.dart';

class LogInView extends ConsumerStatefulWidget {
  const LogInView({Key? key}) : super(key: key);

  @override
  _LogInViewState createState() => _LogInViewState();
}

class _LogInViewState extends ConsumerState<LogInView> {
  final formKey = GlobalKey<FormBuilderState>();

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
    final _dialog = ref.read(dialogProvider);
    final themeMode = ref.watch(themeNotifierProvider.notifier).state.value;
    final auth = ref.read(fbAuthProvider);

    final currentAppUser = ref
        .watch(fbAuthUserStreamProvider.select((value) => value.value != null));

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: formKey,
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
                const SizedBox(height: 15),
                Text(
                  'MiniCampus - with students at heart',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Divider(color: greyTextShade),
                const SizedBox(height: 20),
                Text(
                  'Continue with your student email',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                CustomFormField(
                  context: context,
                  controller: emailCtlr,
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
                const SizedBox(height: 20),
                CustomRoundedButton(
                  text: 'Sign In',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      final _data = formKey.currentState!.value;

                      modalLoader(context);

                      // ? login
                      final result = await auth.signInWithEmailAndPassword(
                          emailCtlr.text.trim().toLowerCase(),
                          _data['password']);

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
                        if (currentAppUser) {
                          ref.watch(fbAppUserProvider.notifier).state = result;

                          routeToWithClear(context, const ProfileCheckView());
                        }
                      }
                    }
                  },
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
      ),
    );
  }
}
