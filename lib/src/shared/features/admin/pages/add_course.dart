import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_campus/src/modules/learning/data/models/course.dart';
import 'package:mini_campus/src/shared/components/index.dart';
import 'package:mini_campus/src/shared/index.dart';

import 'home.dart';

final dptsProvider = FutureProvider((ref) {
  final deptFs = ref.read(fDptRepProvider);

  return deptFs.getFacultyDptByFaculty(Faculty('Engineering'));
});

class AdminAddCourse extends ConsumerStatefulWidget {
  const AdminAddCourse({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminAddCourseState();
}

class _AdminAddCourseState extends ConsumerState<AdminAddCourse> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final loader = ref.watch(adminLoaderProvider);
    final api = ref.read(courseRepProvider);

    final depts = ref.read(dptsProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Course'),
        ),
        body: SingleChildScrollView(
          child: depts.when(
              data: (data) {
                log(' ========== depts data ===========');

                return FormBuilder(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomDDField(
                        context: context,
                        formName: 'dpt',
                        title: 'Department',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        items: data!
                            .map(
                              (e) => DropdownMenuItem(
                                child: Text(e.dptName),
                                value: e,
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
                              ),
                            )
                            .toList(),
                      ),
                      CustomFormField(
                        context: context,
                        formName: 'name',
                        title: 'Course Name',
                        hintText: 'Engineering Maths 1A',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                      ),
                      CustomFormField(
                        context: context,
                        formName: 'code',
                        title: 'Course Code',
                        hintText: 'e.g SMA1116',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              final _data = formKey.currentState!.value;

                              log(_data.toString());

                              ref.read(loaderProvider.notifier).state = true;

                              final facultyDpt = Course(
                                name: _data['name'],
                                code: _data['code'].toString().toUpperCase(),
                                dpt: _data['dpt'].dptCode,
                                part: _data['part'],
                              );

                              final res = await api.addCourse(facultyDpt);

                              ref.read(loaderProvider.notifier).state = false;

                              //formKey.currentState?.reset();

                              // ScaffoldMessenger.of(context).showSnackBar(
                              //     customSnackBar(context, res.toString()));
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: loader
                            ? const CircularProgressIndicator()
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, st) {
                return const Text(' error ');
              }),
        ),
      ),
    );
  }
}
