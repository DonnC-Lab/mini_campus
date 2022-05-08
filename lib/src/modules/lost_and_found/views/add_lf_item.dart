import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../data/models/item_type.dart';
import '../data/models/lost_found_item.dart';
import '../services/data_service.dart';
import '../services/storage_service.dart';

class AddLFItemView extends ConsumerStatefulWidget {
  const AddLFItemView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddLFItemViewState();
}

class _AddLFItemViewState extends ConsumerState<AddLFItemView> {
  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final itemImg = ref.watch(pickedImgProvider);
    final student = ref.watch(studentProvider);

    final storageApi = ref.read(lostFoundStorageProvider);

    final dataApi = ref.read(lostFoundDataProvider);

    final dialog = ref.read(dialogProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Add new item')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: FormBuilder(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDDField(
                  context: context,
                  formName: 'type',
                  title: 'Add',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context, errorText: ''),
                  ]),
                  items: ItemType.itemTypes
                      .map((e) => DropdownMenuItem(
                            child: Text(e.type),
                            value: e,
                            // onTap: () {
                            //   ref.watch(itemTypeProvider.notifier).state = e;
                            // },
                          ))
                      .toList(),
                ),
                CustomFormField(
                  context: context,
                  formName: 'name',
                  title: 'Item Name',
                  hintText: 'short name of the item',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context, errorText: ''),
                  ]),
                ),
                CustomFormField(
                  context: context,
                  formName: 'location',
                  title: 'Location',
                  hintText: 'item encounter e.g campus delta',
                  unfocus: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context, errorText: ''),
                  ]),
                ),
                CustomDateField(
                  context: context,
                  formName: 'date',
                  title: 'Date Encountered',
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context, errorText: ''),
                    (DateTime? dateTime) {
                      if (dateTime != null) {
                        bool isFuture = dateTime.isAfter(DateTime.now());

                        // err text
                        return isFuture ? 'invalid (future) date' : null;
                      }

                      return null;
                    },
                  ]),
                ),
                CustomFormField(
                  context: context,
                  formName: 'desc',
                  title: 'Item description',
                  hintText: 'detailed description of item',
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  maxLength: 100,
                  enforceLength: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context, errorText: ''),
                  ]),
                ),
                const ImageAddPreviewPad(title: 'Item Image'),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomRoundedButton(
                    text: 'Submit',
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        final _data = formKey.currentState!.value;

                        final DateTime _date = _data['date'];

                        String? uploadedItemImg;

                        modalLoader(context);

                        if (itemImg != null) {
                          // upload img first

                          final uploadRes =
                              await storageApi.uploadItemImage(itemImg.path);

                          uploadedItemImg = uploadRes;

                          debugLogger(uploadRes, name: 'upload-item-img');

                          if (uploadRes != null) {
                            dialog.showToast('item file uploaded');
                          }
                        }

                        dialog.showToast('saving lost-found item..');

                        // add item to db
                        final item = LostFoundItem(
                          name: _data['name'],
                          location: _data['location'],
                          date: _date,
                          type: _data['type'].id,
                          description: _data['desc'],
                          month: DateFormat.MMM().format(_date),
                          uploader: student!.id!,
                          image: uploadedItemImg,
                        );

                        debugLogger(item, name: 'addL&F-item');

                        final result = await dataApi.addLostFound(item);

                        Navigator.of(context, rootNavigator: true).pop();

                        if (result != null) {
                          formKey.currentState?.reset();

                          dialog.showTopFlash(
                            context,
                            title: 'Lost & Found',
                            mesg:
                                'Your Lost & Found item has been added successfully 😀',
                          );
                        } else {
                          dialog.showBasicsFlash(context,
                              flashStyle: FlashBehavior.fixed,
                              mesg:
                                  '🙁 Failed to add lost-found Item. Try again later');
                        }

                        // reset img provider
                        ref.read(pickedImgProvider.notifier).state = null;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
