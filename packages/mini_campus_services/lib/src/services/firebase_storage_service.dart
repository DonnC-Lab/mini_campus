library firebase_storage_service;

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseStorageService {
  FirebaseStorageService._();
  static final instance = FirebaseStorageService._();

  static final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> uploadFile({required File file, required String path}) async {
    final fileRef = _storage.ref().child(path);

    await fileRef.putFile(file);

    final _downloadUrl = await fileRef.getDownloadURL();

    return _downloadUrl;
  }

  Future<void> deleteFile({required String path}) async {
    await _storage.ref().child(path).delete();
  }

  Future<void> deleteFileFromUrl({required String url}) async {
    await _storage.refFromURL(url).delete();
  }
}
