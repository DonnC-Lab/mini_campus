import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_campus_core/src/services/log_console.dart';

/// picked image holder as [XFile]
/// can be null
final pickedImgProvider = StateProvider<XFile?>((_) => null);

/// pick image based on [isCamera]
///
/// TODO: consider picking multiple images too
Future<void> customImgPicker(
  WidgetRef ref, {
  bool? isCamera,

  /// as percentage, defaults to 25%
  int quality = 25,
}) async {
  if (isCamera == null) {
    ref.invalidate(pickedImgProvider);
    return;
  }

  try {
    final resultImg = await ImagePicker().pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: quality,
    );

    ref.read(pickedImgProvider.notifier).state = resultImg;
  } catch (e) {
    ref.invalidate(pickedImgProvider);
    debugLogger(e, name: 'customImgPicker', error: e);
  }
}
