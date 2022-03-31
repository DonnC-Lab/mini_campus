import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_campus/src/shared/components/index.dart';
import 'package:mini_campus/src/shared/index.dart';

class AdminAddDpt extends ConsumerStatefulWidget {
  const AdminAddDpt({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminAddDptState();
}

class _AdminAddDptState extends ConsumerState<AdminAddDpt> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final api = ref.read(fDptRepProvider);

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
                              ),
                            )
                            .toList(),
                      ),
                      CustomFormField(
                        context: context,
                        formName: 'name',
                        title: 'Dept Name',
                        hintText: 'Engineering',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                      ),
                      CustomFormField(
                        context: context,
                        formName: 'code',
                        title: 'Dept Code',
                        hintText: 'e.g tee',
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

                              modalLoader(context);

                              final facultyDpt = FacultyDpt(
                                dptCode: _data['code'].toString().toUpperCase(),
                                dptName: _data['name'],
                                faculty: _data['faculty'].name,
                              );

                              final res =
                                  await api.addFacultyDepartment(facultyDpt);

                              Navigator.of(context, rootNavigator: true).pop();

                              if (res == null) {
                                customSnackBar(context, 'failed to add dept',
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
              Column(
                children: [
                  Expanded(
                    child: FutureBuilder<List<FacultyDpt>?>(
                      future: api.getAllFacultyDpt(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data!;

                          return data.isEmpty
                              ? const Center(child: Text('no results'))
                              : ListView.separated(
                                  itemBuilder: (_, index) {
                                    return ListTile(
                                      leading: const CircleAvatar(),
                                      title: Text(data[index].dptCode),
                                      subtitle: Text(data[index].dptName),
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
