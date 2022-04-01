import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:relative_scale/relative_scale.dart';

/// returns true if camera
///
/// false if gallery
// ignore: non_constant_identifier_names
Future<bool?> ImageSourceSelector(BuildContext context) async {
  return await showMaterialModalBottomSheet<bool?>(
    context: context,
    isDismissible: true,
    useRootNavigator: true,
    builder: (context) =>
        RelativeBuilder(builder: (context, height, width, sy, sx) {
      return SizedBox(
        height: 100,
        width: double.infinity,
        // margin: const EdgeInsets.all(10),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Image Source'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      icon: const Icon(Icons.camera_alt),
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      icon: const Icon(Icons.image),
                    )
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
