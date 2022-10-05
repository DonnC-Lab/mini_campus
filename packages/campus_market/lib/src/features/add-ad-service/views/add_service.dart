import 'package:campus_market/src/constants/fb_paths.dart';
import 'package:campus_market/src/constants/market_enums.dart';
import 'package:campus_market/src/models/ad_service.dart';
import 'package:campus_market/src/services/market_rtdb_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mini_campus_components/mini_campus_components.dart';
import 'package:mini_campus_core/mini_campus_core.dart';
import 'package:relative_scale/relative_scale.dart';

class AddService extends ConsumerStatefulWidget {
  const AddService({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddServiceState();
}

class _AddServiceState extends ConsumerState<AddService> {
  final formKey = GlobalKey<FormBuilderState>();

  final FocusNode _nodeText = FocusNode();

  @override
  Widget build(BuildContext context) {
    final storageApi = ref.read(cloudStorageProvider);
    final api = ref.read(marketDbProvider);

    final appUser = ref.watch(fbAppUserProvider);

    final adImg = ref.watch(pickedImgProvider);

    return KeyboardActions(
      config: buildDoneKeyboardActionConfig(context: context, node: _nodeText),
      disableScroll: true,
      tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
      child: FormBuilder(
        key: formKey,
        child: RelativeBuilder(
          builder: (context, height, width, sy, sx) {
            return Column(
              children: [
                CustomFormField(
                  context: context,
                  formName: 'name',
                  title: 'Service Name',
                  hintText: 'e.g Barber, Hair Dressing',
                  validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required(errorText: '')],
                  ),
                ),
                CustomFormField(
                  context: context,
                  formName: 'price',
                  title: 'Service Cost',
                  hintText: r'general cost in USD $',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(errorText: ''),
                      FormBuilderValidators.numeric(errorText: ''),
                      FormBuilderValidators.min(0, errorText: '')
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
                    [FormBuilderValidators.required(errorText: '')],
                  ),
                ),
                const ImageAddPreviewPad(title: 'Service Gallery Image'),
                SizedBox(height: sy(20)),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: CustomRoundedButton(
                    text: 'Submit',
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        final _data = formKey.currentState!.value;

                        modalLoader(context);

                        final imgs = <String>[];

                        if (adImg != null) {
                          // upload img to cloud
                          final uploadedImgs =
                              await storageApi.uploadMultipleMediaFile(
                            images: [adImg.path],
                            path:
                                FirebasePaths.adStorageUserFolder(appUser!.uid),
                          );

                          if (uploadedImgs.isNotEmpty) {
                            imgs.addAll(uploadedImgs);

                            AppDialog.showToast('Service image uploaded');
                          } else {
                            AppDialog.showToast(
                              'failed to upload Service image',
                            );
                          }
                        }

                        final ad = AdService(
                          name: _data['name'] as String,
                          type: AdType.service,
                          price:
                              double.tryParse(_data['price'].toString()) ?? 0.0,
                          images: imgs,
                          isNegotiable: false,
                          isRequest: false,
                          category: MarketCategory.services,
                          description: _data['description'] as String,
                          createdOn: DateTime.now(),
                        );

                        Navigator.of(context, rootNavigator: true).pop();

                        // save ad
                        final res = await api.addAdService(ad);

                        if (res != null) {
                          if (res) {
                            AppDialog.showTopFlash(
                              context,
                              title: 'Service',
                              mesg: 'Your Service has been added successfully',
                            );
                          } else {
                            AppDialog.showTopFlash(
                              context,
                              title: 'Service',
                              mesg:
                                  'Failed to add your Service, try again later',
                            );
                          }
                        } else {
                          AppDialog.showTopFlash(
                            context,
                            title: 'Service',
                            mesg: 'Failed to add your Service, try again later',
                          );
                        }

                        // reset img provider
                        ref.invalidate(pickedImgProvider);

                        formKey.currentState?.reset();
                      }
                    },
                  ),
                ),
                SizedBox(height: sy(30)),
              ],
            );
          },
        ),
      ),
    );
  }
}
