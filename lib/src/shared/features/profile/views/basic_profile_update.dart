import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_campus/src/shared/index.dart';

final _selectedFacultyProvider = StateProvider<Faculty?>((_) => null);

final _selectedDptProvider = StateProvider<FacultyDpt?>((_) => null);

class BasicProfileUpdateView extends ConsumerWidget {
   BasicProfileUpdateView({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const _radius = Radius.circular(30);

    final studentProfile = ref.watch(studentProvider);

    final studentService = ref.watch(studentStoreProvider);

    final _dialog = ref.read(dialogProvider);

    final faculty = ref.watch(_selectedFacultyProvider);

    final deptFs = ref.read(fDptRepProvider);

    final dpt = ref.watch(_selectedDptProvider);

    final themeMode = ref.watch(themeNotifierProvider.notifier).state.value;

   // debugLogger(studentProfile, name: 'basic-profile-update');

    return SafeArea(
      child: Scaffold(
        body: Column(
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
            Center(
              child: Column(
                children: [
                  Text(
                    'MiniCampus',
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        ?.copyWith(fontSize: 37),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Update your profile',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
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
                          readOnly: true,
                          context: context,
                          formName: 'name',
                          initialText: studentProfile?.name ?? '',
                          title: 'Fullname',
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required(context)]),
                        ),
                        CustomFormField(
                          context: context,
                          formName: 'alias',
                          initialText: studentProfile?.alias ?? '',
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
                                        .watch(
                                            _selectedFacultyProvider.notifier)
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
                          text: 'Update',
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

                              final _updated = studentProfile?.copyWith(
                                gender: _data['gender'],
                                department: dpt.dptName,
                                departmentCode: dpt.dptCode,
                                faculty: faculty.name,
                                alias: _data['alias'],
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
                                _dialog
                                    .showToast('Account updated successfully');

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
      ),
    );
  }
}
