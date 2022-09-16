library firebase_storage_service;

import 'dart:io' show File;

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

/// {@template storage_service}
/// Firebase Storage Service
///
/// a wrapper service class around the firebase storage service
///
/// {@endtemplate}
class FirebaseStorageService {
  FirebaseStorageService._();

  /// {@macro storage_service}
  static final instance = FirebaseStorageService._();

  static final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  /// upload a single [file] to given [path]
  ///
  /// returns uploaded file download_url
  Future<String> uploadFile({required File file, required String path}) async {
    final fileRef = _storage.ref().child(path);

    await fileRef.putFile(file);

    final _downloadUrl = await fileRef.getDownloadURL();

    return _downloadUrl;
  }

  /// delete file at [path]
  Future<void> deleteFile({required String path}) async {
    await _storage.ref().child(path).delete();
  }

  /// delete file from given file download [url]
  Future<void> deleteFileFromUrl({required String url}) async {
    await _storage.refFromURL(url).delete();
  }
}
