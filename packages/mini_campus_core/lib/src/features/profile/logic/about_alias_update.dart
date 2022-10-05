import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_campus_components/mini_campus_components.dart';
import 'package:mini_campus_core/mini_campus_core.dart';
import 'package:mini_campus_core/src/services/firebase/student_service.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

/// modal sheet to update student alias
/// and about fields
void updateAboutAliasModal(
  BuildContext context,
  Student student,
  GlobalKey<FormBuilderState> formKey,
) {
  showMaterialModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    builder: (context) => Consumer(
      builder: (_, ref, __) {
        final studentService = ref.read(studentStoreProvider);

        return SizedBox(
          height: 450,
          width: double.infinity,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: FormBuilder(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Update',
                        style: Theme.of(context).textTheme.headline1?.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    const Divider(),
                    CustomFormField(
                      context: context,
                      formName: 'alias',
                      initialText: student.alias,
                      title: 'Alias Name',
                      validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(errorText: '')],
                      ),
                    ),
                    CustomFormField(
                      context: context,
                      formName: 'about',
                      title: 'About Me',
                      maxLength: 150,
                      unfocus: true,
                      hintText: 'short bio about yourself',
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      initialText: student.about,
                      enforceLength: true,
                      validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required(errorText: '')],
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomRoundedButton(
                      text: 'Update',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          final _data = formKey.currentState!.value;

                          // check for changes, minimize fb writes
                          if (_data['alias'] == student.alias &&
                              _data['about'] == student.about) {
                            AppDialog.showToast('no changes detected');

                            Navigator.pop(context);

                            return;
                          }

                          modalLoader(context);

                          // update student
                          final _student = student.copyWith(
                            alias: _data['alias'] as String?,
                            about: _data['about'] as String,
                          );

                          final _updated =
                              await studentService.updateStudent(_student);

                          Navigator.of(context, rootNavigator: true).pop();

                          if (_updated == null) {
                            AppDialog.showTopFlash(
                              context,
                              title: 'Account',
                              mesg: 'Failed to update account. Try again later',
                            );
                          }

                          // success
                          else {
                            AppDialog.showTopFlash(
                              context,
                              title: 'Account',
                              mesg: 'Your account has been updated!',
                            );

                            Navigator.pop(context);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
