import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mini_campus/src/modules/campus_market/models/ad_service.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:relative_scale/relative_scale.dart';

import '../../../constants/general_consts.dart';
import '../../../constants/market_enums.dart';
import '../../../services/market_rtdb_service.dart';

class AddProduct extends ConsumerStatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddProductState();
}

class _AddProductState extends ConsumerState<AddProduct> {
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
              CustomDDField(
                context: context,
                validator: FormBuilderValidators.compose(
                  [FormBuilderValidators.required(context, errorText: '')],
                ),
                title: 'Product Category',
                formName: 'category',
                items: selectableMarketCategories()
                    .map(
                      (e) => DropdownMenuItem(child: Text(e.name), value: e),
                    )
                    .toList(),
              ),
              CustomFormField(
                context: context,
                formName: 'name',
                title: 'Product Name',
                hintText: 'e.g Calculator',
                validator: FormBuilderValidators.compose(
                  [FormBuilderValidators.required(context, errorText: '')],
                ),
              ),
              CustomFormField(
                context: context,
                formName: 'price',
                title: 'Product Price',
                hintText: 'price in USD \$',
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
                title: 'Product Description',
                maxLength: 250,
                unfocus: true,
                hintText: 'short description about your Ad',
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                enforceLength: true,
                validator: FormBuilderValidators.compose(
                  [FormBuilderValidators.required(context, errorText: '')],
                ),
              ),
              const ImageAddPreviewPad(title: 'Ad Image'),
              SizedBox(height: sy(20)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomRoundedButton(
                  text: 'Submit',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      final _data = formKey.currentState!.value;

                      final bool negotiable = await _dialog.showDialogFlash(
                            context,
                            title: 'Ad Price',
                            mesg: 'Is this Ad price negotiable?',
                            okButtonText: 'YES',
                            cancelButtonText: 'NO',
                          ) ??
                          false;

                      modalLoader(context);

                      List<String> imgs = [];

                      if (adImg != null) {
                        // upload img to cloud
                        final String? img = await storageApi.uploadMediaFile(
                          image: adImg.path,
                          path: '',
                          // path: FirebasePaths.adStorageUserFolder(appUser!.uid),
                        );

                        if (img != null) {
                          imgs.add(img);

                          _dialog.showToast('Ad image uploaded');
                        } else {
                          _dialog.showToast('failed to upload Ad image');
                        }
                      }

                      final ad = AdService(
                        name: _data['name'],
                        type: AdType.Ad,
                        price:
                            double.tryParse(_data['price'].toString()) ?? 0.0,
                        images: imgs,
                        isNegotiable: negotiable,
                        isRequest: _data['category'] == MarketCategory.Requests,
                        category: _data['category'],
                        description: _data['description'],
                        createdOn: DateTime.now(),
                      );

                      Navigator.of(context, rootNavigator: true).pop();

                      // save ad
                      final res = await api.addAdService(ad);

                      debugLogger(res);

                      if (res != null) {
                        if (res) {
                          _dialog.showTopFlash(context,
                              title: 'Ad',
                              mesg: 'Your Ad has been added successfully');
                        } else {
                          _dialog.showTopFlash(context,
                              title: 'Ad',
                              mesg: 'Failed to add your Ad, try again later');
                        }
                      } else {
                        _dialog.showTopFlash(context,
                            title: 'Ad',
                            mesg: 'Failed to add your Ad, try again later');
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
