import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mini_campus/src/modules/campus_market/constants/market_enums.dart';
import 'package:mini_campus/src/modules/campus_market/models/ad_service.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:relative_scale/relative_scale.dart';

class AddService extends ConsumerStatefulWidget {
  const AddService({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddServiceState();
}

class _AddServiceState extends ConsumerState<AddService> {
  final formKey = GlobalKey<FormBuilderState>();

  final FocusNode _nodeText = FocusNode();

  @override
  Widget build(BuildContext context) {
    final _dialog = ref.watch(dialogProvider);

    final adImg = ref.watch(pickedImgProvider);

    return KeyboardActions(
      config: BuildDoneKeyboardActionConfig(context: context, node: _nodeText),
      // autoScroll: false,
      disableScroll: true,
      tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
      child: Container(
        child: FormBuilder(
          key: formKey,
          child: RelativeBuilder(builder: (context, height, width, sy, sx) {
            return Column(
              children: [
                CustomFormField(
                  context: context,
                  formName: 'name',
                  title: 'Service Name',
                  hintText: 'e.g Barber, Hair Dressing',
                  validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required(context, errorText: '')],
                  ),
                ),
                CustomFormField(
                  context: context,
                  formName: 'price',
                  unfocus: true,
                  title: 'Service Price',
                  hintText: 'general price in USD \$',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(context, errorText: ''),
                      FormBuilderValidators.numeric(context, errorText: ''),
                      FormBuilderValidators.min(context, 0, errorText: '')
                    ],
                  ),
                ),
                CustomFormField(
                  context: context,
                  focusNode: _nodeText,
                  formName: 'description',
                  title: 'Service Description',
                  maxLength: 300,
                  unfocus: true,
                  hintText:
                      'A short description about your the services you offer',
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  enforceLength: true,
                  validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required(context, errorText: '')],
                  ),
                ),
                const ImageAddPreviewPad(title: 'Service Gallery Image'),
                SizedBox(height: sy(20)),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomRoundedButton(
                    text: 'Submit',
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        final _data = formKey.currentState!.value;

                        if (adImg == null) {
                          // img is required
                          return;
                        }

                        final ad = AdService(
                          name: _data['name'],
                          type: AdType.Service,
                          description: _data['description'],
                          createdOn: DateTime.now(),
                        );

                        debugLogger(ad, name: 'addAdService');

                        // reset img provider
                        ref.read(pickedImgProvider.notifier).state = null;
                      }
                    },
                  ),
                ),
                SizedBox(height: sy(30)),
              ],
            );
          }),
        ),
      ),
    );
  }
}
