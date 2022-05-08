import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../data/survey_model.dart';
import '../services/survey_repository.dart';

class AddSurveyView extends ConsumerStatefulWidget {
  const AddSurveyView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddSurveyViewState();
}

class _AddSurveyViewState extends ConsumerState<AddSurveyView> {
  final formKey = GlobalKey<FormBuilderState>();

  final FocusNode _nodeText = FocusNode();

  @override
  Widget build(BuildContext context) {
    final student = ref.watch(studentProvider);

    final dataApi = ref.read(surveyRepoProvider);

    final dialog = ref.read(dialogProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Survey')),
        body: KeyboardActions(
          config:
              BuildDoneKeyboardActionConfig(context: context, node: _nodeText),
          disableScroll: true,
          tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: FormBuilder(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      customUrlLauncher(helpCreateSurvey);
                    },
                    child: Text(
                      '✍ \nGet started creating your google form survey',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            fontSize: 13,
                            color: bluishColor,
                          ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomFormField(
                    context: context,
                    formName: 'name',
                    title: 'Survey Name',
                    hintText: 'short name of the survey',
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context, errorText: ''),
                    ]),
                  ),
                  CustomFormField(
                    focusNode: _nodeText,
                    unfocus: true,
                    context: context,
                    formName: 'description',
                    title: 'Survey Description',
                    maxLength: 250,
                    hintText: 'survey detailed description',
                    keyboardType: TextInputType.multiline,
                    maxLines: 7,
                    enforceLength: true,
                    validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required(context, errorText: '')],
                    ),
                  ),
                  CustomFormField(
                    context: context,
                    formName: 'link',
                    title: 'Survey Link',
                    hintText: 'google form link of your survey',
                    keyboardType: TextInputType.url,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context, errorText: ''),
                      FormBuilderValidators.url(context, errorText: ''),
                      (String? formLink) {
                        if (formLink != null) {
                          bool isGForm =
                              formLink.startsWith(googleFormPrefixUrl) ||
                                  formLink.startsWith(googleFormShortPrefixUrl);

                          // err text
                          return isGForm ? null : 'invalid G form link';
                        }

                        return null;
                      },
                    ]),
                  ),
                  CustomDateField(
                    context: context,
                    formName: 'date',
                    title: 'Expire On',
                    inputType: InputType.both,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context, errorText: ''),
                      (DateTime? dateTime) {
                        if (dateTime != null) {
                          bool isPast = dateTime.isBefore(DateTime.now());

                          // err text
                          return isPast ? 'invalid (past) date' : null;
                        }

                        return null;
                      },
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomRoundedButton(
                      text: 'Submit',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();

                          final _data = formKey.currentState!.value;

                          final DateTime _expiryDate = _data['date'];

                          modalLoader(context);

                          // add survey to db
                          final survey = SurveyModel(
                            name: _data['name'],
                            expireOn: _expiryDate,
                            owner: student!.id!,
                            description: _data['description'],
                            createdOn: DateTime.now(),
                            link: _data['link'],
                          );

                          final result = await dataApi.addSurvey(survey);

                          Navigator.of(context, rootNavigator: true).pop();

                          if (result != null) {
                            formKey.currentState?.reset();

                            dialog.showTopFlash(
                              context,
                              title: 'Survey',
                              mesg:
                                  'Your survey has been added successfully 😀',
                            );
                          } else {
                            dialog.showBasicsFlash(context,
                                flashStyle: FlashBehavior.fixed,
                                mesg:
                                    '🙁 Failed to add survey. Try again later');
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
      ),
    );
  }
}
