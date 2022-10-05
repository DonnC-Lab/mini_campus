import 'package:campus_market/src/constants/fb_paths.dart';
import 'package:campus_market/src/constants/general_constants.dart';
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

class AddProduct extends ConsumerStatefulWidget {
  const AddProduct({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddProductState();
}

class _AddProductState extends ConsumerState<AddProduct> {
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
                CustomDDField(
                  context: context,
                  validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required(errorText: '')],
                  ),
                  title: 'Product Category',
                  formName: 'category',
                  items: selectableMarketCategories
                      .map(
                        (e) => DropdownMenuItem(value: e, child: Text(e.name)),
                      )
                      .toList(),
                ),
                CustomFormField(
                  context: context,
                  formName: 'name',
                  title: 'Product Name',
                  hintText: 'e.g Calculator',
                  validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required(errorText: '')],
                  ),
                ),
                CustomFormField(
                  context: context,
                  formName: 'price',
                  title: 'Product Price',
                  hintText: r'price in USD $',
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
                  title: 'Product Description',
                  maxLength: 250,
                  hintText: 'short description about your Ad',
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  enforceLength: true,
                  validator: FormBuilderValidators.compose(
                    [FormBuilderValidators.required(errorText: '')],
                  ),
                ),
                const ImageAddPreviewPad(title: 'Ad Image'),
                SizedBox(height: sy(20)),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: CustomRoundedButton(
                    text: 'Submit',
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        final _data = formKey.currentState!.value;

                        final negotiable =
                            await ref.read(dialogProvider).showDialogFlash(
                                      context,
                                      title: 'Ad Price',
                                      mesg: 'Is this Ad price negotiable?',
                                      okButtonText: 'YES',
                                      cancelButtonText: 'NO',
                                    ) ??
                                false;

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

                            AppDialog.showToast('Ad image uploaded');
                          } else {
                            AppDialog.showToast('failed to upload Ad image');
                          }
                        }

                        final ad = AdService(
                          name: _data['name'] as String,
                          type: AdType.ad,
                          price:
                              double.tryParse(_data['price'].toString()) ?? 0.0,
                          images: imgs,
                          isNegotiable: negotiable,
                          isRequest:
                              _data['category'] == MarketCategory.requests,
                          category: _data['category'] as MarketCategory,
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
                              title: 'Ad',
                              mesg: 'Your Ad has been added successfully',
                            );
                          } else {
                            AppDialog.showTopFlash(
                              context,
                              title: 'Ad',
                              mesg: 'Failed to add your Ad, try again later',
                            );
                          }
                        } else {
                          AppDialog.showTopFlash(
                            context,
                            title: 'Ad',
                            mesg: 'Failed to add your Ad, try again later',
                          );
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
          },
        ),
      ),
    );
  }
}
