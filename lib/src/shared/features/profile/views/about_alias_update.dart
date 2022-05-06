import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:relative_scale/relative_scale.dart';

// ignore: non_constant_identifier_names
void UpdateAboutAliasModal(
  BuildContext context,
  Student student,
  GlobalKey<FormBuilderState> formKey,
) {
  showMaterialModalBottomSheet(
    context: context,
    isDismissible: true,
    useRootNavigator: true,
    builder: (context) =>
        RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Consumer(builder: (_, ref, __) {
        final _dialog = ref.read(dialogProvider);
        final studentService = ref.read(studentStoreProvider);

        return SizedBox(
          height: 450,
          width: double.infinity,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
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
                        [
                          FormBuilderValidators.required(context, errorText: '')
                        ],
                      ),
                    ),
                    CustomFormField(
                      context: context,
                      autoFocus: false,
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
                        [
                          FormBuilderValidators.required(context, errorText: '')
                        ],
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
                            _dialog.showToast('no changes detected');

                            Navigator.pop(context);

                            return;
                          }

                          modalLoader(context);

                          // update student
                          final Student _student = student.copyWith(
                              alias: _data['alias'], about: _data['about']);

                          var _updated =
                              await studentService.updateStudent(_student);

                          Navigator.of(context, rootNavigator: true).pop();

                          if (_updated == null) {
                            _dialog.showTopFlash(context,
                                title: "Account",
                                mesg:
                                    'Failed to update account. Try again later');
                          }

                          // success
                          else {
                            _dialog.showTopFlash(context,
                                title: "Account",
                                mesg: 'Your account has been updated!');

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
      });
    }),
  );
}
