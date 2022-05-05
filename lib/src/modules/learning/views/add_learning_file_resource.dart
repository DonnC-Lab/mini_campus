import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../data/models/course.dart';
import '../data/models/resource/file_resource.dart';
import '../data/models/resource/resource.dart';
import '../services/course_repo.dart';
import '../services/resource_repo.dart';
import '../services/storage_service.dart';
import 'admin/add_file_elevated.dart';

final coursesProvider =
    FutureProviderFamily<List<Course>?, Map>((ref, filters) {
  final cP = ref.read(courseRepProvider);

  return cP.getAllCoursesByDpt(filters['code'], filters['part']);
});

class AddLearningFileResource extends ConsumerStatefulWidget {
  const AddLearningFileResource({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddLearningFileResourceState();
}

class _AddLearningFileResourceState
    extends ConsumerState<AddLearningFileResource> {
  final formKey = GlobalKey<FormBuilderState>();

  Course? _selectedCourse;

  @override
  Widget build(BuildContext context) {
    final dialog = ref.watch(dialogProvider);

    final coursesApi = ref.read(courseRepProvider);

    final resourceApi = ref.read(resRepProvider);

    // final course = ref.watch(_selectedCourseProvider);

    final driveRepo = ref.watch(learningStorageProvider);

    final studentProfile = ref.watch(studentProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Resource'),
          actions: [
            IconButton(
              tooltip: 'refresh form',
              onPressed: () {
                formKey.currentState?.reset();

                ref.refresh(courseRepProvider);

                setState(() {
                  _selectedCourse = null;
                });
              },
              icon: const Icon(Icons.refresh),
            ),
            GestureDetector(
              onLongPressEnd: (details) {
                routeTo(context, const AddFileElevated());
              },
              child: const Icon(Icons.shield, color: Colors.transparent),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FormBuilder(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⚠ \nYou can only add files that match your current part & stream',
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        fontSize: 13,
                        color: greyTextShade,
                      ),
                ),
                const SizedBox(height: 20),
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
                studentProfile!.departmentCode.isNotEmpty
                    ? FutureBuilder<List<Course>?>(
                        future: coursesApi.getAllCoursesByDpt(
                          studentProfile.departmentCode,
                          studentProfile.email.studentNumber.stringYear,
                        ),
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            final data = snapshot.data;

                            return CustomDDField(
                              context: context,
                              formName: 'course',
                              title: 'Course',
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context),
                              ]),
                              items: data!
                                  .map(
                                    (e) => DropdownMenuItem(
                                      child: Text(e.name),
                                      value: e,
                                      onTap: () {
                                        setState(() {
                                          _selectedCourse = e;
                                        });
                                      },
                                    ),
                                  )
                                  .toList(),
                            );
                          }

                          // loader
                          else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        }),
                      )
                    : const SizedBox.shrink(),
                _selectedCourse == null
                    ? const SizedBox.shrink()
                    : Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16, bottom: 10),
                          child: Text(_selectedCourse!.code),
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

                        var courseCode = _selectedCourse!.code;

                        debugLogger(_data.toString());

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
                              '${studentProfile.departmentCode}/${studentProfile.email.studentNumber.stringYear}/${_data['category']}/${_data['year']}/$courseCode',
                          filename: '$courseCode.pdf',
                        );

                        if (uploadRes == null) {
                          Navigator.of(context, rootNavigator: true).pop();

                          // reset course provider
                          setState(() {
                            _selectedCourse = null;
                          });

                          dialog.showTopFlash(context,
                              title: 'Upload File',
                              mesg:
                                  'Failed to upload your file resource 🙁, try again later!');

                          return;
                        }

                        dialog.showToast('file uploaded');

                        dialog.showToast('saving resource..');

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

                          setState(() {
                            _selectedCourse = null;
                          });

                          dialog.showTopFlash(context,
                              title: 'File Resource',
                              mesg:
                                  'Your file resource has been added successfully 😃.\nWe appreciate your help');
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
