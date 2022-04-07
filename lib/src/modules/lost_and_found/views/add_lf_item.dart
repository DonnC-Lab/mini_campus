import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:mini_campus/src/shared/components/index.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../data/models/lost_found_item.dart';

class ItemType {
  final String type;
  final String id;
  ItemType({
    required this.type,
    required this.id,
  });

  static List<ItemType> get itemTypes => [
        ItemType(type: 'Lost Item', id: 'lost'),
        ItemType(type: 'Found Item', id: 'found'),
      ];
}

class AddLFItemView extends ConsumerStatefulWidget {
  const AddLFItemView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddLFItemViewState();
}

class _AddLFItemViewState extends ConsumerState<AddLFItemView> {
  final formKey = GlobalKey<FormBuilderState>();

  // grab student profile here

  @override
  Widget build(BuildContext context) {
    final itemImg = ref.watch(pickedImgProvider);

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Add new item'),
          ),
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
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text(e.type),
                            value: e,
                          ),
                        )
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
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Item Image', style: titleTextStyle(context)),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.no_photography),
                              onPressed: () {
                                ref.read(pickedImgProvider.notifier).state =
                                    null;
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_a_photo),
                              onPressed: () async {
                                final imgSource =
                                    await ImageSourceSelector(context);

                                if (imgSource != null) {
                                  await customImgPicker(ref, imgSource);
                                }
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: itemImg == null
                                  ? greyTextShade.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                            child: itemImg == null
                                ? Center(
                                    child: IconButton(
                                      icon: const Icon(Icons.photo,
                                          color: Colors.grey),
                                      onPressed: () async {
                                        final imgSource =
                                            await ImageSourceSelector(context);

                                        if (imgSource != null) {
                                          await customImgPicker(ref, imgSource);
                                        }
                                      },
                                    ),
                                  )
                                : Center(
                                    child: Image.file(
                                      File(itemImg.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();

                          final _data = formKey.currentState!.value;

                          final DateTime _date = _data['date'];

                          if (itemImg != null) {
                            // upload img first
                          }

                          // add item to db
                          final item = LostFoundItem(
                            name: _data['name'],
                            location: _data['location'],
                            date: _date,
                            type: _data['type'].id,
                            description: _data['desc'],
                            month: DateFormat.MMM().format(_date),
                            // TODO Add student id
                            uploader: '',
                          );

                          debugLogger(item, name: 'addL&F-item');

                          // reset img provider
                          ref.read(pickedImgProvider.notifier).state = null;
                        }
                      },
                      child: const Text('Submit'),
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
