import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_campus/src/shared/components/index.dart';
import 'package:mini_campus/src/shared/index.dart';

import 'home.dart';

class AdminAddDpt extends ConsumerStatefulWidget {
  const AdminAddDpt({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminAddDptState();
}

class _AdminAddDptState extends ConsumerState<AdminAddDpt> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final loader = ref.watch(adminLoaderProvider);
    final api = ref.read(fDptRepProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Dept'),
        ),
        body: SingleChildScrollView(
          child: FormBuilder(
            key: formKey,
            child: Column(
              children: [
                CustomDDField(
                  context: context,
                  formName: 'faculty',
                  title: 'Faculty',
                  keyboardType: TextInputType.emailAddress,
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

                        ref.read(loaderProvider.notifier).state = true;

                        final facultyDpt = FacultyDpt(
                          dptCode: _data['code'].toString().toUpperCase(),
                          dptName: _data['name'],
                          faculty: _data['faculty'].name,
                        );

                        final res = await api.addFacultyDepartment(facultyDpt);

                        ref.read(loaderProvider.notifier).state = false;

                        formKey.currentState?.reset();

                        ScaffoldMessenger.of(context).showSnackBar(
                            customSnackBar(context, res.toString()));
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
          ),
        ),
      ),
    );
  }
}
