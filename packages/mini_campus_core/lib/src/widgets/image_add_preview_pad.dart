import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus_components/mini_campus_components.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:mini_campus_core/mini_campus_core.dart';

/// image previewer
class ImageAddPreviewPad extends ConsumerWidget {
  /// image previewer
  const ImageAddPreviewPad({super.key, this.title = 'Add Image'});

  /// title to display on previewer pad
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _img = ref.watch(pickedImgProvider);

    return Padding(
      padding: const EdgeInsets.all(5),
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
                  ref.invalidate(pickedImgProvider);
                },
              ),
              IconButton(
                icon: const Icon(Icons.add_a_photo),
                onPressed: () async {
                  final imgSource = await ImageSourceSelector(context);

                  await customImgPicker(ref, isCamera: imgSource);
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: _img == null
                    ? AppColors.kGreyShadeColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: _img == null
                  ? Center(
                      child: IconButton(
                        icon: const Icon(Icons.photo, color: Colors.grey),
                        onPressed: () async {
                          final imgSource = await ImageSourceSelector(context);

                          await customImgPicker(ref, isCamera: imgSource);
                        },
                      ),
                    )
                  : Center(
                      child: Image.file(File(_img.path), fit: BoxFit.cover),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
