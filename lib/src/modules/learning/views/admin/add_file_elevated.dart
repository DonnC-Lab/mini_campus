// elevated rights, student can add any general file

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../../data/models/course.dart';
import '../../data/models/resource/file_resource.dart';
import '../../data/models/resource/resource.dart';
import '../../services/course_repo.dart';
import '../../services/resource_repo.dart';
import '../../services/storage_service.dart';

class AddFileElevated extends ConsumerStatefulWidget {
  const AddFileElevated({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddFileElevatedState();
}

class _AddFileElevatedState extends ConsumerState<AddFileElevated> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final deptFs = ref.read(fDptRepProvider);

    final dialog = ref.watch(dialogProvider);

    final coursesApi = ref.read(courseRepProvider);

    final resourceApi = ref.read(resRepProvider);

    final driveRepo = ref.watch(learningStorageProvider);

    final studentProfile = ref.watch(studentProvider);

    // ----------- selected items ----------------------
    final faculty = ref.watch(_selectedFacultyProvider);

    final dpt = ref.watch(_selectedDptProvider);

    final part = ref.watch(_selectedPartProvider);

    final course = ref.watch(_selectedCourseProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Resource File'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FormBuilder(
            key: formKey,
            child: Column(
              children: [
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
                            ref.watch(_selectedFacultyProvider.notifier).state =
                                e;
                          },
                        ),
                      )
                      .toList(),
                ),
                CustomDDField(
                  context: context,
                  formName: 'part',
                  title: 'Part',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                  items: uniParts
                      .map(
                        (e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                          onTap: () {
                            ref.watch(_selectedPartProvider.notifier).state = e;
                          },
                        ),
                      )
                      .toList(),
                ),
                CustomDDField(
                  context: context,
                  formName: 'category',
                  title: 'Category',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                  items: resourceCategories
                      .map((e) => DropdownMenuItem(child: Text(e), value: e))
                      .toList(),
                ),
                faculty != null
                    ? FutureBuilder<List<FacultyDpt>>(
                        future: deptFs.getFacultyDptByFaculty(faculty),
                        builder: (context, snapshot) {
                          if (snapshot.hasData || snapshot.hasError) {
                            final _dpts = snapshot.data ?? [];

                            return CustomDDField(
                              context: context,
                              formName: 'dpt',
                              trailing: _dpts.isEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        formKey.currentState
                                            ?.patchValue({'faculty': null});

                                        ref.invalidate(
                                            _selectedFacultyProvider);
                                      },
                                      child: const Icon(
                                        Icons.refresh,
                                        color: Colors.blue,
                                      ),
                                    )
                                  : null,
                              title: 'Department',
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                              ]),
                              items: _dpts
                                  .map(
                                    (e) => DropdownMenuItem(
                                      child: Text(e.dptName),
                                      value: e,
                                      onTap: () {
                                        ref
                                            .watch(
                                                _selectedDptProvider.notifier)
                                            .state = e;
                                      },
                                    ),
                                  )
                                  .toList(),
                            );
                          }

                          //
                          else {
                            return const CircularProgressIndicator();
                          }
                        })
                    : const SizedBox.shrink(),
                dpt != null && part != null
                    ? FutureBuilder<List<Course>>(
                        future: coursesApi.getAllCoursesByDpt(
                          dpt.dptCode,
                          part,
                        ),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData || snapshot.hasError) {
                            final data = snapshot.data ?? [];

                            return CustomDDField(
                              context: context,
                              formName: 'course',
                              title: 'Course',
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                              ]),
                              trailing: data.isEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        formKey.currentState?.patchValue({
                                          'dpt': null,
                                        });

                                        ref.invalidate(_selectedDptProvider);
                                      },
                                      child: const Icon(
                                        Icons.refresh,
                                        color: Colors.blue,
                                      ),
                                    )
                                  : null,
                              items: data
                                  .map(
                                    (e) => DropdownMenuItem(
                                      child: Text(e.name),
                                      value: e,
                                      onTap: () {
                                        ref
                                            .watch(_selectedCourseProvider
                                                .notifier)
                                            .state = e;
                                      },
                                    ),
                                  )
                                  .toList(),
                            );
                          }

                          // loader
                          else {
                            return const CircularProgressIndicator();
                          }
                        }),
                      )
                    : const SizedBox.shrink(),
                course == null
                    ? const SizedBox.shrink()
                    : Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16, bottom: 10),
                          child: Text(
                            course.code,
                          ),
                        ),
                      ),
                CustomFormField(
                  unfocus: true,
                  context: context,
                  formName: 'year',
                  title: 'Course Material Year',
                  hintText: 'e.g 2021 for a 2021 paper',
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.integer(context),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomRoundedButton(
                    text: 'Upload & Save',
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        final _data = formKey.currentState!.value;

                        var courseCode = course!.code;

                        modalLoader(context);

                        final fp = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );

                        if (fp == null) {
                          Navigator.of(context, rootNavigator: true).pop();

                          dialog.showTopFlash(context,
                              title: 'Pick File',
                              mesg:
                                  'No file found to be selected 🤔 Please select your ${_data['category']} file and try again');

                          // abort, no file selected
                          return;
                        }

                        final uploadRes = await driveRepo.uploadFileResource(
                          fp.files.first.path!,
                          directory:
                              '${studentProfile!.departmentCode}/${studentProfile.email.studentNumber.stringYear}/${_data['category']}/${_data['year']}/$courseCode',
                          filename: '$courseCode.pdf',
                        );

                        if (uploadRes == null) {
                          Navigator.of(context, rootNavigator: true).pop();

                          // reset course provider
                          ref.read(_selectedCourseProvider.notifier).state =
                              null;

                          dialog.showTopFlash(context,
                              title: 'Upload File',
                              mesg:
                                  'Failed to upload your file resource 🙁, try again later!');

                          return;
                        }

                        debugLogger(uploadRes.toString());

                        dialog.showToast('file uploaded');

                        final res = FileResource(
                          dpt: studentProfile.departmentCode,
                          uploadedBy: studentProfile.id!,
                          createdOn: DateTime.now(),
                          courseCode: courseCode,
                          part: studentProfile.email.studentNumber.stringYear,
                          approvalStatus: 'pending',
                          year: int.parse(_data['year']),
                          category: _data['category'],
                          resource: Resource(
                            filename: '$courseCode.pdf',
                            filepath: uploadRes.toString(),
                            prefix:
                                '${studentProfile.departmentCode}/${studentProfile.email.studentNumber.stringYear}/${_data['category']}/${_data['year']}',
                          ),
                        );

                        final result = await resourceApi.addFileResource(res);

                        Navigator.of(context, rootNavigator: true).pop();

                        if (result != null) {
                          formKey.currentState?.reset();

                          // reset course provider
                          ref.read(_selectedCourseProvider.notifier).state =
                              null;

                          dialog.showTopFlash(context,
                              title: 'File Resource',
                              mesg:
                                  'Your file resource has been added successfully.\nWe appreciate your help');
                        }

                        //
                        else {
                          dialog.showTopFlash(context,
                              title: 'File Resource',
                              mesg:
                                  'Failed to save file resource!\nIt may be that it already exists or something went wrong, try again later!');
                        }
                      }
                    },
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

final dptsProvider = FutureProviderFamily<List<FacultyDpt>?, Faculty>((ref, f) {
  final deptFs = ref.read(fDptRepProvider);

  return deptFs.getFacultyDptByFaculty(f);
});

final coursesProvider =
    FutureProviderFamily<List<Course>?, Map>((ref, filters) {
  final cP = ref.read(courseRepProvider);

  return cP.getAllCoursesByDpt(filters['code'], filters['part']);
});

final facultyDptFacultiesProvider =
    FutureProviderFamily<List<FacultyDpt>, Faculty>((ref, faculty) {
  final deptFs = ref.read(fDptRepProvider);

  return deptFs.getFacultyDptByFaculty(faculty);
});

final _selectedFacultyProvider = StateProvider<Faculty?>((_) => null);

final _selectedDptProvider = StateProvider<FacultyDpt?>((_) => null);

final _selectedPartProvider = StateProvider<String?>((_) => null);

final _selectedCourseProvider = StateProvider<Course?>((_) => null);
