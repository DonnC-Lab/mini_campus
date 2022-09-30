import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_campus_components/mini_campus_components.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:mini_campus_core/mini_campus_core.dart';
import 'package:mini_campus_core/src/services/firebase/student_service.dart';

final _selectedFacultyProvider = StateProvider<Faculty?>((_) => null);

final _selectedDptProvider = StateProvider<FacultyDepartment?>((_) => null);

/// update student profile
class BasicProfileUpdateView extends ConsumerWidget {
  /// update profile
  BasicProfileUpdateView({
    super.key,
    required this.drawerModulePages,
  });

  /// app modules
  final List<DrawerPage> drawerModulePages;

  /// form builder form key
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const _radius = Radius.circular(30);

    final studentProfile = ref.watch(studentProvider);

    final studentService = ref.watch(studentStoreProvider);

    final _dialog = ref.read(dialogProvider);

    final faculty = ref.watch(_selectedFacultyProvider);

    final facultyRepository = ref.read(facultyRepositoryProvider);

    final dpt = ref.watch(_selectedDptProvider);

    final studentUni = ref.watch(studentUniProvider);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Center(child: LogoBox()),
            const SizedBox(height: 20),
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
            const SizedBox(height: 40),
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
                            [FormBuilderValidators.required()],
                          ),
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
                            FormBuilderValidators.required(),
                          ]),
                          items: ['Male', 'Female']
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                        ),
                        CustomDDField(
                          context: context,
                          formName: 'faculty',
                          title: 'Faculty',
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          items: Faculty(name: '', uni: studentUni)
                              .uniFaculties
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  onTap: () {
                                    ref
                                        .watch(
                                          _selectedFacultyProvider.notifier,
                                        )
                                        .state = e;
                                  },
                                  child: Text(e.name),
                                ),
                              )
                              .toList(),
                        ),
                        if (faculty != null)
                          FutureBuilder<List<FacultyDepartment>>(
                            future: facultyRepository.getFacultyDepartments(
                              facultyName: faculty.name,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData || snapshot.hasError) {
                                final _dpts = snapshot.data ?? [];

                                return CustomDDField(
                                  context: context,
                                  formName: 'dpt',
                                  trailing: _dpts.isEmpty
                                      ? GestureDetector(
                                          onTap: () {
                                            formKey.currentState?.patchValue(
                                              {'faculty': null},
                                            );

                                            ref.invalidate(
                                              _selectedFacultyProvider,
                                            );
                                          },
                                          child: const Icon(
                                            Icons.refresh,
                                            color: Colors.blue,
                                          ),
                                        )
                                      : null,
                                  title: 'Department',
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                  items: _dpts
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          onTap: () {
                                            ref
                                                .watch(
                                                  _selectedDptProvider.notifier,
                                                )
                                                .state = e;
                                          },
                                          child: Text(e.dptName),
                                        ),
                                      )
                                      .toList(),
                                );
                              }

                              //
                              else {
                                return const CircularProgressIndicator
                                    .adaptive();
                              }
                            },
                          )
                        else
                          const SizedBox.shrink(),
                        const SizedBox(height: 20),
                        CustomRoundedButton(
                          text: 'Update',
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              final _data = formKey.currentState!.value;

                              if (faculty == null || dpt == null) {
                                _dialog.showBasicFlash(
                                  context,
                                  mesg:
                                      'faculty or department is required to proceed',
                                );
                                return;
                              }

                              modalLoader(context);

                              final _updated = studentProfile?.copyWith(
                                gender: _data['gender'] as String?,
                                department: dpt.dptName,
                                departmentCode: dpt.dptCode,
                                faculty: faculty.name,
                                alias: _data['alias'] as String?,
                              );

                              final result =
                                  await studentService.updateStudent(_updated!);

                              Navigator.of(context, rootNavigator: true).pop();

                              if (result == null) {
                                _dialog.showBasicFlash(
                                  context,
                                  flashStyle: FlashBehavior.fixed,
                                  mesg: 'failed to update your MC account!',
                                );
                              }

                              // success
                              else {
                                AppDialog.showToast(
                                  'Account updated successfully',
                                );

                                routeToWithClear(
                                  context,
                                  HomeView(
                                    drawerModulePages: drawerModulePages,
                                  ),
                                );
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
