import 'package:flash/flash.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_campus_components/mini_campus_components.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:mini_campus_core/mini_campus_core.dart';
import 'package:mini_campus_core/src/services/firebase/student_service.dart';
import 'package:mini_campus_services/mini_campus_services.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({
    super.key,
    this.logoLightMode,
    this.logoDarkMode,
    required this.drawerModulePages,
  });

  final List<DrawerPage> drawerModulePages;

  final String? logoLightMode;
  final String? logoDarkMode;

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final formKey = GlobalKey<FormBuilderState>();

  final emailCtlr = TextEditingController();

  bool obscure = true;

  bool fillField = true;

  bool isEmailValid = false;

  @override
  void initState() {
    super.initState();
    emailCtlr.addListener(() {
      // check for valid student email

      final emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(emailCtlr.text.trim());

      if (emailValid) {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _dialog = ref.read(dialogProvider);
    final auth = ref.read(firebaseAuthServiceProvider);
    final studentService = ref.read(studentStoreProvider);
    final studentUni = ref.watch(studentUniProvider);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FormBuilder(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: LogoBox(
                      // logoDarkMode: widget.logoDarkMode,
                      // logoLightMode: widget.logoLightMode,
                      ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Sign up',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.copyWith(fontSize: 42),
                ),
                const SizedBox(height: 15),
                Text(
                  'MiniCampus - with students at heart 💝',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Divider(color: AppColors.kGreyShadeColor),
                const SizedBox(height: 20),
                Text(
                  'Register with your student email',
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
                  hintText: 'N0192872X@students.nust.ac.zw',
                  title: 'Email',
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColors.kGreyShadeColor,
                  ),
                  suffixIcon: isEmailValid
                      ? const Icon(
                          Icons.done,
                          color: AppColors.kGreenIndicatorColor,
                        )
                      : const SizedBox.shrink(),
                  validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required()],
                  ),
                ),
                CustomFormField(
                  context: context,
                  formName: 'name',
                  hintText: 'Jane Doe',
                  title: 'Fullname',
                  prefixIcon: const Icon(
                    Icons.person,
                    color: AppColors.kGreyShadeColor,
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                CustomFormField(
                  context: context,
                  formName: 'password1',
                  hintText: 'Your password',
                  obscureText: obscure,
                  keyboardType: TextInputType.visiblePassword,
                  title: 'Password',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.kGreyShadeColor,
                  ),
                  // suffixIcon: GestureDetector(
                  //   onTap: () {
                  //     setState(() {
                  //       obscure = !obscure;
                  //     });
                  //   },
                  //   child: obscure
                  //       ? const Icon(
                  //           Icons.visibility,
                  //           color: AppColors.kGreyShadeColor,
                  //         )
                  //       : const Icon(
                  //           Icons.visibility_off,
                  //           color: AppColors.kGreyShadeColor,
                  //         ),
                  // ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                CustomFormField(
                  context: context,
                  formName: 'password2',
                  hintText: 'confirm password',
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  title: 'Confirm Password',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.kGreyShadeColor,
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(height: 20),
                CustomRoundedButton(
                  text: 'Sign Up',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      final _data = formKey.currentState!.value;

                      if (_data['password1'].toString().trim() !=
                          _data['password2'].toString().trim()) {
                        _dialog.showBasicFlash(
                          context,
                          flashStyle: FlashBehavior.fixed,
                          mesg: 'passwords do not match',
                        );
                        return;
                      }

                      if (!emailCtlr.text.isValidStudentEmailAddress) {
                        _dialog.showBasicFlash(
                          context,
                          flashStyle: FlashBehavior.fixed,
                          mesg: 'not a valid institution student email',
                        );
                        return;
                      }

                      modalLoader(context);

                      // ? register
                      final result = await auth.registerNewUser(
                        emailCtlr.text.trim().toLowerCase(),
                        _data['password2'].toString().trim(),
                      );

                      if (result is CustomException) {
                        Navigator.of(context, rootNavigator: true).pop();

                        _dialog.showBasicFlash(
                          context,
                          flashStyle: FlashBehavior.fixed,
                          mesg: result.message ?? 'failed to create an account',
                        );
                      }

                      // success
                      else {
                        ref.watch(fbAppUserProvider.notifier).state =
                            result as AppFbUser;

                        // save student
                        final student = Student(
                          id: result.uid,
                          name: _data['name'] as String,
                          alias: _data['name'] as String,
                          email: result.email,
                          department: '',
                          faculty: '',
                          about: "Hey 👋 I'm using MiniCampus",
                          departmentCode: '',
                          createdOn: DateTime.now(),

                          // TODO: Add supported Unis based on selection* maybe
                          studentNumber: getStudentNumberFromEmail(
                            result.email,
                            UniEmailDomain.uniDomains.firstWhere(
                              (uni) => uni.university == studentUni,
                            ),
                          )?.studentNumber,
                        );

                        await studentService.addStudent(student);

                        Navigator.of(context, rootNavigator: true).pop();

                        AppDialog.showTopFlash(
                          context,
                          title: 'Account',
                          mesg: 'Your MiniCampus account have been created'
                              ' successfully 😃, sign in to continue',
                        );

                        routeToWithClear(
                          context,
                          LogInView(
                            drawerModulePages: widget.drawerModulePages,
                          ),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 45),
                RichText(
                  text: TextSpan(
                    text: 'Already have a MiniCampus account?',
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.kGreyShadeColor,
                        ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' Sign in',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              color:
                                  Theme.of(context).appBarTheme.backgroundColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            routeTo(
                              context,
                              LogInView(
                                drawerModulePages: widget.drawerModulePages,
                              ),
                            );
                          },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
