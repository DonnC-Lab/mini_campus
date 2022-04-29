import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';

class ImageAddPreviewPad extends ConsumerWidget {
  const ImageAddPreviewPad({Key? key, this.title='Add Image'}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _img = ref.watch(pickedImgProvider);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: titleTextStyle(context)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.no_photography),
                tooltip: 'reset image',
                onPressed: () {
                  ref.read(pickedImgProvider.notifier).state = null;
                },
              ),
              IconButton(
                icon: const Icon(Icons.add_a_photo),
                onPressed: () async {
                  final imgSource = await ImageSourceSelector(context);

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
                color: _img == null
                    ? greyTextShade.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: _img == null
                  ? Center(
                      child: IconButton(
                        icon: const Icon(Icons.photo, color: Colors.grey),
                        onPressed: () async {
                          final imgSource = await ImageSourceSelector(context);

                          if (imgSource != null) {
                            await customImgPicker(ref, imgSource);
                          }
                        },
                      ),
                    )
                  : Center(
                      child: Image.file(
                        File(_img.path),
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
