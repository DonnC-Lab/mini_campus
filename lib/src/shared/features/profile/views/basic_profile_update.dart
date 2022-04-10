import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_campus/src/shared/components/index.dart';
import 'package:mini_campus/src/shared/extensions/index.dart';
import 'package:mini_campus/src/shared/index.dart';

final _selectedFacultyProvider = StateProvider<Faculty?>((_) => null);

final _selectedDptProvider = StateProvider<FacultyDpt?>((_) => null);

class BasicProfileUpdateView extends ConsumerStatefulWidget {
  const BasicProfileUpdateView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BasicProfileUpdateViewState();
}

class _BasicProfileUpdateViewState
    extends ConsumerState<BasicProfileUpdateView> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    const _radius = Radius.circular(30);

    final studentProfile = ref.watch(studentProvider);

    final studentService = ref.watch(studentStoreProvider);

    final appUser = ref.watch(fbAppUserProvider);

    final _dialog = ref.read(dialogProvider);

    final faculty = ref.watch(_selectedFacultyProvider);

    final deptFs = ref.read(fDptRepProvider);

    final dpt = ref.watch(_selectedDptProvider);

    return Scaffold(
      body: Column(
        children: [
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: IconButton(
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //     icon: const Icon(
          //       Icons.chevron_left,
          //       size: 40,
          //     ),
          //   ),
          // ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Text(
                  'MiniCampus',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 10),
                Text(
                  'Update your profile',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                //  color: fadeGreenColor,
                borderRadius: BorderRadius.only(
                  topLeft: _radius,
                  topRight: _radius,
                ),
              ),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                child: FormBuilder(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomFormField(
                        context: context,
                        formName: 'name',
                        hintText: 'Your name',
                        title: 'Fullname',
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required(context)]),
                      ),
                      CustomFormField(
                        context: context,
                        formName: 'alias',
                        initialText: '',
                        hintText: 'your popular known name',
                        title: 'Alias (Optional)',
                      ),
                      CustomDDField(
                        context: context,
                        formName: 'gender',
                        title: 'Gender',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        items: ['Male', 'Female']
                            .map((e) =>
                                DropdownMenuItem(child: Text(e), value: e))
                            .toList(),
                      ),
                      CustomDDField(
                        context: context,
                        formName: 'faculty',
                        title: 'Faculty',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        items: faculties
                            .map(
                              (e) => DropdownMenuItem(
                                child: Text(e.name),
                                value: e,
                                onTap: () {
                                  ref
                                      .watch(_selectedFacultyProvider.notifier)
                                      .state = e;
                                },
                              ),
                            )
                            .toList(),
                      ),
                      faculty != null
                          ? FutureBuilder<List<FacultyDpt>?>(
                              future: deptFs.getFacultyDptByFaculty(faculty),
                              builder: (context, snapshot) {
                                return snapshot.hasData
                                    ? CustomDDField(
                                        context: context,
                                        formName: 'dpt',
                                        title: 'Department',
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              context),
                                        ]),
                                        items: snapshot.data!
                                            .map(
                                              (e) => DropdownMenuItem(
                                                child: Text(e.dptName),
                                                value: e,
                                                onTap: () {
                                                  ref
                                                      .watch(
                                                          _selectedDptProvider
                                                              .notifier)
                                                      .state = e;
                                                },
                                              ),
                                            )
                                            .toList(),
                                      )
                                    : const CircularProgressIndicator();
                              })
                          : const SizedBox.shrink(),
                      const SizedBox(height: 20),
                      CustomRoundedButton(
                        text: 'Sign In',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            final _data = formKey.currentState!.value;

                            if (faculty == null || dpt == null) {
                              _dialog.showBasicsFlash(
                                context,
                                mesg:
                                    'faculty or department is required to proceed',
                              );
                              return;
                            }

                            modalLoader(context);

                            // update profile
                            final _updated = studentProfile?.copyWith(
                              name: _data['name'],
                              gender: _data['gender'],
                              department: dpt.dptName,
                              departmentCode: dpt.dptCode,
                              faculty: faculty.name,
                              alias: _data['alias'],
                              studentNumber:
                                  appUser!.email.studentNumber.studentNumber,
                            );

                            final result =
                                await studentService.updateStudent(_updated!);

                            Navigator.of(context, rootNavigator: true).pop();

                            if (result == null) {
                              _dialog.showBasicsFlash(
                                context,
                                flashStyle: FlashBehavior.fixed,
                                mesg: 'failed to update your MC account!',
                              );
                            }

                            // success
                            else {
                              _dialog.showToast('Account updated successfully');

                              routeToWithClear(context, const HomeView());
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
