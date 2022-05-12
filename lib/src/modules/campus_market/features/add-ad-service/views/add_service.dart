import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mini_campus/src/modules/campus_market/models/ad_service.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:relative_scale/relative_scale.dart';

import '../../../constants/fb_paths.dart';
import '../../../constants/market_enums.dart';
import '../../../services/market_rtdb_service.dart';

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
    final storageApi = ref.read(gStorageProvider);
    final api = ref.read(marketDbProvider);
    final _dialog = ref.watch(dialogProvider);

    final appUser = ref.watch(fbAppUserProvider);

    final adImg = ref.watch(pickedImgProvider);

    return KeyboardActions(
      config: BuildDoneKeyboardActionConfig(context: context, node: _nodeText),
      disableScroll: true,
      tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
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
                title: 'Service Cost',
                hintText: 'general cost in USD \$',
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
                maxLength: 250,
                hintText: 'short description about the service you offer',
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

                      modalLoader(context);

                      List<String> imgs = [];

                      if (adImg != null) {
                        // upload img to cloud
                        final String? img = await storageApi.uploadMediaFile(
                          image: adImg.path,
                          path: FirebasePaths.adStorageUserFolder(appUser!.uid),
                        );

                        if (img != null) {
                          imgs.add(img);

                          _dialog.showToast('Service image uploaded');
                        } else {
                          _dialog.showToast('failed to upload Service image');
                        }
                      }

                      final ad = AdService(
                        name: _data['name'],
                        type: AdType.Service,
                        price:
                            double.tryParse(_data['price'].toString()) ?? 0.0,
                        images: imgs,
                        isNegotiable: false,
                        isRequest: false,
                        category: MarketCategory.Services,
                        description: _data['description'],
                        createdOn: DateTime.now(),
                      );

                      Navigator.of(context, rootNavigator: true).pop();

                      // save ad
                      final res = await api.addAdService(ad);

                      if (res != null) {
                        if (res) {
                          _dialog.showTopFlash(context,
                              title: 'Service',
                              mesg: 'Your Service has been added successfully');
                        } else {
                          _dialog.showTopFlash(context,
                              title: 'Service',
                              mesg:
                                  'Failed to add your Service, try again later');
                        }
                      } else {
                        _dialog.showTopFlash(context,
                            title: 'Service',
                            mesg:
                                'Failed to add your Service, try again later');
                      }

                      // reset img provider
                      ref.read(pickedImgProvider.notifier).state = null;

                      formKey.currentState?.reset();
                    }
                  },
                ),
              ),
              SizedBox(height: sy(30)),
            ],
          );
        }),
      ),
    );
  }
}
