import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';

final learningStorageProvider = Provider((_) => StorageService(_.read));

class StorageService {
  final Reader _read;

  StorageService(this._read);

  /// return uploaded filename
  Future uploadFileResource(
    String file, {
    String? directory,
    String? filename,
  }) async {
    final driveInstance = DetaDriveInit(drive: DetaDrives.learning);

    final drive = _read(detaStorageProvider(driveInstance));

    try {
      final resp = await drive.upload(
        file,
        directory: directory,
        filename: filename,
      );

      debugLogger(resp, name: 'uploadFileResource-Res');

      return resp;
    }

    // err
    catch (e) {
      debugLogger(e, error: e, name: 'uploadFileResource');
    }
  }

  Future<File?> downloadFileResourceFuture(String filename) async {
    final driveInstance =
        DetaDriveInit(drive: DetaDrives.learning, filename: filename);

    final res =
        await _read(detaStorageProvider(driveInstance)).download(filename);

    if (res is File) {
      return res;
    }
    return null;
  }
}
