import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/libs/index.dart';
import 'package:path/path.dart';

import '../log_console.dart';

final gStorageProvider = Provider((_) => CloudStorageDatabase());

class CloudStorageDatabase {
  final _service = FirebaseStorageService.instance;

  /// upload media file
  ///
  /// usually image file to path e.g profile/user123
  Future<String?> uploadMediaFile(
      {required String image, required String path}) async {
    try {
      final String fname = basename(image);

      String _fullCloudFilePath = path + '/' + fname;

      debugLogger(_fullCloudFilePath);

      var imageUrl = await _service.uploadFile(
          file: File(image), path: _fullCloudFilePath);

      debugLogger(imageUrl, name: 'uploadMediaFile');

      return imageUrl;
    }

    // fb err
    on firebase_core.FirebaseException catch (e) {
      debugLogger(e.message, error: e, name: 'uploadMediaFile FbExec');

      return null;
    }

    // err
    catch (e) {
      debugLogger(e, error: e, name: 'uploadMediaFile Err');
      return null;
    }
  }

  /// upload multiple images
  ///
  /// return uploaded files download urls
  Future<List<String>> uploadMultipleMediaFile({
    required List<String> images,
    required String path,
  }) async {
    try {
      // compress image first, then attempt uploading
      var imageUrls = await Future.wait(images.map((_image) {
        final String fname = basename(_image);

        String _fullCloudFilePath = path + '/$fname';

        return _service.uploadFile(
            file: File(_image), path: _fullCloudFilePath);
      }));

      debugLogger(imageUrls, name: 'uploadMultipleMediaFile');

      return imageUrls;
    }

    // fb err
    on firebase_core.FirebaseException catch (e) {
      debugLogger(e.message);
      return images;
    }

    // err
    catch (e) {
      debugLogger(e.toString());
      return images;
    }
  }

  Future<void> deleteMediaFile({required String path}) async {
    try {
      await _service.deleteFile(path: path);
    }

    // fb err
    on firebase_core.FirebaseException catch (e) {
      debugLogger(e.message);
    }

    // err
    catch (e) {
      debugLogger(e.toString());
    }
  }

  /// delete all ad files
  Future deleteAllAdFiles({required List<String> imagesUrl}) async {
    try {
      await Future.wait(
          imagesUrl.map((url) => _service.deleteAdFile(url: url)).toList());
    }

    //
    catch (e) {
      debugLogger(e.toString());
    }
  }
}
