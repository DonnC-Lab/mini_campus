import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_campus/src/modules/learning/data/models/course.dart';
import 'package:mini_campus/src/modules/learning/data/models/resource/file_resource.dart';
import 'package:mini_campus/src/modules/learning/data/models/resource/resource.dart';
import 'package:mini_campus/src/shared/components/index.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:mini_campus/src/shared/services/deta/resource_repo.dart';

import 'home.dart';

final dptsProvider = FutureProviderFamily<List<FacultyDpt>?, Faculty>((ref, f) {
  final deptFs = ref.read(fDptRepProvider);

  return deptFs.getFacultyDptByFaculty(f);
});

final coursesProvider =
    FutureProviderFamily<List<Course>?, Map>((ref, filters) {
  final cP = ref.read(courseRepProvider);

  return cP.getAllCoursesByDpt(filters['code'], filters['part']);
});

final _selectedFacultyProvider = StateProvider<Faculty?>((_) => null);

final _selectedDptProvider = StateProvider<FacultyDpt?>((_) => null);

final _selectedPartProvider = StateProvider<String?>((_) => null);

final _selectedCourseProvider = StateProvider<Course?>((_) => null);

class AdminAddFile extends ConsumerStatefulWidget {
  const AdminAddFile({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminAddFileState();
}

class _AdminAddFileState extends ConsumerState<AdminAddFile> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final loader = ref.watch(adminLoaderProvider);

    final cosRep = ref.read(courseRepProvider);
    final deptFs = ref.read(fDptRepProvider);

    final api = ref.read(courseRepProvider);

    final resApi = ref.read(resRepProvider);

    final dpt = ref.watch(_selectedDptProvider);

    final part = ref.watch(_selectedPartProvider);

    final course = ref.watch(_selectedCourseProvider);

    //
    final driveRepo = ref.watch(detaStoreRepProvider);

    final faculty = ref.watch(_selectedFacultyProvider);

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.add),
              text: 'Add',
            ),
            Tab(
              icon: Icon(Icons.list),
              text: 'View',
            ),
          ])),
          body: TabBarView(
            children: [
              SingleChildScrollView(
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
                                  ref
                                      .watch(_selectedFacultyProvider.notifier)
                                      .state = e;
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
                                  ref
                                      .watch(_selectedPartProvider.notifier)
                                      .state = e;
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
                            .map((e) =>
                                DropdownMenuItem(child: Text(e), value: e))
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
                      dpt != null
                          ? FutureBuilder<List<Course>?>(
                              future: api.getAllCoursesByDpt(
                                dpt.dptCode,
                                part!,
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
                      // file uploader tab
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: loader
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    final _data = formKey.currentState!.value;

                                    var courseCode = course?.code;

                                    log(_data.toString());

                                    modalLoader(context);

                                    var fp =
                                        await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['pdf'],
                                    );

                                    if (fp != null) {
                                      var bytes =
                                          await File(fp.files.first.path!)
                                              .readAsBytes();

                                      final uploadRes = await driveRepo.upload(
                                        fp.files.first.path!,
                                        bytes,
                                        directory:
                                            '${dpt?.dptCode}/$part/${_data['category']}/${_data['year']}/$courseCode/',
                                        filename: '$courseCode.pdf',
                                      );

                                      log(uploadRes.toString());

                                      Fluttertoast.showToast(
                                          msg: 'file uploaded');

                                      Fluttertoast.showToast(
                                          msg: 'saving resource..');

                                      final res = FileResource(
                                        dpt: dpt!.dptCode,
                                        uploadedBy: "admin",
                                        createdOn: DateTime.now(),
                                        courseCode: courseCode!,
                                        part: part,
                                        approvalStatus:
                                            'approved', // for admin only
                                        year: int.parse(_data['year']),
                                        category: _data['category'],
                                        resource: Resource(
                                          filename: '$courseCode.pdf',
                                          filepath: uploadRes.toString(),
                                          prefix:
                                              '${dpt.dptCode}/$part/${_data['category']}/${_data['year']}',
                                        ),
                                      );

                                      final result =
                                          await resApi.addFileResource(res);

                                      Navigator.of(context, rootNavigator: true)
                                          .pop();

                                      if (result != null) {
                                        formKey.currentState?.reset();

                                        Fluttertoast.showToast(
                                            msg: 'resource added!');
                                      }

                                      //
                                      else {
                                        Fluttertoast.showToast(
                                            msg: 'failed to add resource');
                                      }
                                    }

                                    //e
                                    else {
                                      Fluttertoast.showToast(
                                          msg: 'file is required');
                                    }
                                  }
                                },
                                child: const Text('Upload & Save'),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: FutureBuilder<List<FileResource>?>(
                      future: resApi.getAllFileResources(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data!;

                          return data.isEmpty
                              ? const Center(child: Text('no results'))
                              : ListView.separated(
                                  itemBuilder: (_, index) {
                                    return ListTile(
                                      leading: const CircleAvatar(),
                                      title:
                                          Text(data[index].resource.filename),
                                      subtitle: Text(
                                          '${data[index].year.toString()} | ${data[index].part}'),
                                    );
                                  },
                                  separatorBuilder: (_, x) =>
                                      const SizedBox(height: 10),
                                  itemCount: data.length,
                                );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
