import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mini_campus/src/drawer_module_pages.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:relative_scale/relative_scale.dart';

import '../models/feedback_model.dart';
import '../services/fdbk_service.dart';

class FeedbackView extends ConsumerStatefulWidget {
  const FeedbackView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends ConsumerState<FeedbackView> {
  final formKey = GlobalKey<FormBuilderState>();

  double _studentRating = 0;

  String _moduleName = 'other';

  @override
  Widget build(BuildContext context) {
    final dialog = ref.watch(dialogProvider);

    final student = ref.watch(studentProvider);

    final api = ref.read(fdbkProvider);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FormBuilder(
            key: formKey,
            child: RelativeBuilder(builder: (context, height, width, sy, sx) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Write to us',
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        ?.copyWith(fontSize: 21),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Help us help you get the best experience 😉',
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        ?.copyWith(fontSize: 13, color: greyTextShade),
                  ),
                  const SizedBox(height: 20),
                  CustomDDField(
                    context: context,
                    validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required(context, errorText: '')],
                    ),
                    title: 'Module',
                    formName: 'module',
                    items: drawerModulePages
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text(e.drawerItem.name),
                            value: e,
                            onTap: () {
                              setState(() {
                                _moduleName = e.drawerItem.name;
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    allowHalfRating: true,
                    itemPadding: EdgeInsets.symmetric(horizontal: sx(13)),
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return const Icon(
                            Icons.sentiment_very_dissatisfied,
                            color: Colors.red,
                          );
                        case 1:
                          return const Icon(
                            Icons.sentiment_dissatisfied,
                            color: Colors.redAccent,
                          );
                        case 2:
                          return const Icon(
                            Icons.sentiment_neutral,
                            color: Colors.amber,
                          );
                        case 3:
                          return const Icon(
                            Icons.sentiment_satisfied,
                            color: Colors.lightGreen,
                          );
                        case 4:
                          return const Icon(
                            Icons.sentiment_very_satisfied,
                            color: Colors.green,
                          );
                      }

                      return const SizedBox.shrink();
                    },
                    onRatingUpdate: (rating) {
                      setState(() {
                        _studentRating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomFormField(
                    autoFocus: false,
                    context: context,
                    formName: 'message',
                    title: 'Feedback',
                    maxLength: 300,
                    hintText: 'your feedback message to us 😀',
                    keyboardType: TextInputType.multiline,
                    maxLines: 7,
                    enforceLength: true,
                    validator: FormBuilderValidators.compose(
                      [FormBuilderValidators.required(context, errorText: '')],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomRoundedButton(
                      text: 'Submit',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();

                          final _data = formKey.currentState!.value;

                          modalLoader(context);

                          final fdbc = FeedbackModel(
                            student: student!.id!,
                            message: _data['message'],
                            rate: _studentRating,
                            module: _moduleName,
                          );

                          final res = await api.addFeedback(fdbc);

                          Navigator.of(context, rootNavigator: true).pop();

                          if (res == null) {
                            dialog.showTopFlash(context,
                                title: 'Feedback',
                                style: FlashBehavior.fixed,
                                mesg:
                                    'Failed to add your feedback, please try again later');
                          }

                          // e
                          else {
                            dialog.showTopFlash(context,
                                title: 'Feedback',
                                mesg:
                                    'Thank you for your feedback 😀, we appreciate your time');

                            setState(() {
                              _moduleName = '';
                              _studentRating = 0.0;
                            });

                            formKey.currentState?.reset();
                          }
                        }
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
