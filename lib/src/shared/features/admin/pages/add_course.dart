import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_campus/src/modules/learning/data/models/course.dart';
import 'package:mini_campus/src/shared/components/index.dart';
import 'package:mini_campus/src/shared/index.dart';

final dptsProvider = FutureProvider((ref) {
  final deptFs = ref.read(fDptRepProvider);

  return deptFs.getFacultyDptByFaculty(Faculty('Engineering'));
});

final _selectedFacultyProvider = StateProvider<Faculty?>((_) => null);

final _selectedDptProvider = StateProvider<FacultyDpt?>((_) => null);

class AdminAddCourse extends ConsumerStatefulWidget {
  const AdminAddCourse({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminAddCourseState();
}

class _AdminAddCourseState extends ConsumerState<AdminAddCourse> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final api = ref.read(courseRepProvider);

    final deptFs = ref.read(fDptRepProvider);

    final faculty = ref.watch(_selectedFacultyProvider);
    final dpt = ref.watch(_selectedDptProvider);

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
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
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

                                modalLoader(context);

                                final facultyDpt = Course(
                                  name: _data['name'],
                                  code: _data['code'].toString().toUpperCase(),
                                  dpt: dpt!.dptCode,
                                  part: _data['part'],
                                );

                                var res = await api.addCourse(facultyDpt);

                                Navigator.of(context, rootNavigator: true)
                                    .pop();

                                if (res == null) {
                                  customSnackBar(
                                      context, 'failed to add course',
                                      bgColor: Colors.red);
                                }

                                //
                                else {
                                  formKey.currentState?.reset();

                                  customSnackBar(context, res.toString());
                                }
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: FutureBuilder<List<Course>?>(
                      future: api.getAllCourses(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data!;

                          return data.isEmpty
                              ? const Center(child: Text('no results'))
                              : ListView.separated(
                                  itemBuilder: (_, index) {
                                    return ListTile(
                                      leading: const CircleAvatar(),
                                      title: Text(
                                          '${data[index].code} | ${data[index].part}'),
                                      trailing: Text(data[index].dpt),
                                      subtitle: Text(data[index].name),
                                    );
                                  },
                                  separatorBuilder: (_, x) =>
                                      const SizedBox(height: 10),
                                  itemCount: data.length,
                                );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
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
