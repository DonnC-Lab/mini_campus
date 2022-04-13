import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../index.dart';

final pickedImgProvider = StateProvider<XFile?>((_) => null);

Future<void> customImgPicker(WidgetRef ref, bool isCamera) async {
  final _picker = ImagePicker();

  String error = 'No Error Detected';

  // todo consider picking multiple images too

  try {
    final resultImg = await _picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 25,
    );

    ref.read(pickedImgProvider.notifier).state = resultImg;
  }
  //
  on Exception catch (e) {
    error = e.toString();
    debugLogger(error, name: 'customImgPicker', error: e);
  }
}
