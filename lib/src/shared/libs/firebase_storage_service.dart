library firebase_storage_service;

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseStorageService {
  FirebaseStorageService._();
  static final instance = FirebaseStorageService._();

  static final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> uploadFile({
    required File file,
    required String path,
  }) async {
    final _uploadedFile = await _storage.ref(path).putFile(file);

    final _downloadUrl = await _uploadedFile.ref.getDownloadURL();

    return _downloadUrl;
  }

  Future<String> uploadFileCompleter({
    required File file,
    required String path,
  }) async {
    final _uploadedFileRef = _storage.ref().child(path);

    firebase_storage.UploadTask task = _uploadedFileRef.putFile(file);

    final _url = await task
        .whenComplete(() async => await _uploadedFileRef.getDownloadURL());

    return await _url.ref.getDownloadURL();
  }

  Future<void> deleteFileCompleter({
    required String path,
  }) async {
    final _uploadedFileRef = _storage.ref().child(path);

    var task = _uploadedFileRef.delete();

    await task.whenComplete(() async => await _uploadedFileRef.delete());
  }

  Future<void> deleteFile({
    required String path,
  }) async {
    await _storage.ref(path).delete();
  }

  Future<void> deleteAdFile({required String url}) async {
    await _storage.refFromURL(url).delete();
  }
}
