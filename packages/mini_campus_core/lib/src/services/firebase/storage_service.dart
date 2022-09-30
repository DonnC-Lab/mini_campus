import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus_core/mini_campus_core.dart';
import 'package:mini_campus_services/mini_campus_services.dart';
import 'package:path/path.dart';

/// [CStorageService] provider DI
final cloudStorageProvider = Provider((_) => CStorageService());

/// firebase cloud storage service
class CStorageService {
  final _service = FirebaseStorageService.instance;

  /// upload multiple images
  ///
  /// return uploaded files download urls
  Future<List<String>> uploadMultipleMediaFile({
    required List<String> images,
    required String path,
  }) async {
    try {
      final imageUrls = await Future.wait(
        images.map(
          (_image) => _service.uploadFile(
            file: File(_image),
            path: '$path/${basename(_image)}',
          ),
        ),
      );

      debugLogger(imageUrls, name: 'uploadMultipleMediaFile');

      return imageUrls;
    }

    // fb err
    on firebase_core.FirebaseException catch (e) {
      debugLogger(e.message);
      return const [];
    }

    // err
    catch (e) {
      debugLogger(e.toString());
      return const [];
    }
  }

  /// delete file at [path]
  Future<void> deleteMediaFile({required String path}) async {
    try {
      await _service.deleteFile(path: path);
    } on firebase_core.FirebaseException catch (e) {
      debugLogger(e.message);
    } catch (e) {
      debugLogger(e.toString());
    }
  }

  /// delete all ad files
  Future<void> deleteMultipleFilesFromUrl({
    required List<String> imagesUrl,
  }) async {
    try {
      await Future.wait(
        imagesUrl.map((url) => _service.deleteFileFromUrl(url: url)).toList(),
      );
    } catch (e) {
      debugLogger(e.toString());
    }
  }
}
