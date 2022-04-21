import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:relative_scale/relative_scale.dart';

import '../data/models/lost_found_item.dart';
import 'item_image.dart';

// ignore: non_constant_identifier_names
void ItemDetails(BuildContext context, LostFoundItem item) {
  showMaterialModalBottomSheet(
    context: context,
    isDismissible: true,
    useRootNavigator: true,
    builder: (context) =>
        RelativeBuilder(builder: (context, height, width, sy, sx) {
      return SizedBox(
        height: 350,
        width: double.infinity,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text(
                  'Details',
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                )),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ItemImage(
                      img: item.image,
                      size: 80,
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style:
                              Theme.of(context).textTheme.headline1?.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.location,
                          style:
                              Theme.of(context).textTheme.subtitle2?.copyWith(
                                    fontSize: 12,
                                    color: greyTextShade,
                                  ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      DateFormat.yMMMMd().format(item.date),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          ?.copyWith(fontSize: 11, color: greyTextShade),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  item.description,
                  maxLines: 5,
                  style: Theme.of(context).textTheme.subtitle2?.copyWith(
                        fontSize: 13,
                        color: greyTextShade,
                      ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                Text(
                  'Added By',
                  style: Theme.of(context).textTheme.headline1?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const ItemImage(
                      img: 'assets/images/product-1.png',
                      size: 40,
                      radius: 40,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Admin',
                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }),
  );
}
