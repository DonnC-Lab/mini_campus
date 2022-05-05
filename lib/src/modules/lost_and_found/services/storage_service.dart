import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';

final lostFoundStorageProvider = Provider((_) => StorageService(_.read));

class StorageService {
  final Reader _read;

  StorageService(this._read);

  /// return uploaded filename
  Future uploadItemImage(
    String file, {
    String? directory,
    String? filename,
  }) async {
    final driveInstance = DetaDriveInit(drive: DetaDrives.lostFound);

    final drive = _read(detaStorageProvider(driveInstance));

    try {
      final resp = await drive.upload(
        file,
        directory: directory,
        filename: filename,
      );

      return resp;
    }

    // err
    catch (e) {
      debugLogger(e, error: e, name: 'fetchLFItems');
    }
  }

  Future<File?> downloadItemImageFuture(String filename) async {
    final driveInstance =
        DetaDriveInit(drive: DetaDrives.lostFound, filename: filename);

    final res =
        await _read(detaStorageProvider(driveInstance)).download(filename);

    if (res is File) {
      return res;
    }
    return null;
  }
}
