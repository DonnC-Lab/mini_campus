import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:mini_campus/src/shared/libs/index.dart';

final lostFoundStorageProvider = Provider((_) => StorageService(_.read));

class StorageService {
  final Reader _read;

  StorageService(this._read);

  /// return uploaded filename
  Future uploadItemImage(
    String file,
    Uint8List bytes, {
    String? directory,
    String? filename,
  }) async {
    // pass keys associated with this function, can be changed or use mulitple
    final detaInstance = Deta(projectKey: donDetaProjectKey);

    final driveInstance = DetaDriveInit(detaInstance, DetaDrives.lostFound);

    final drive = _read(detaStorageProvider(driveInstance));

    try {
      final resp = await drive.upload(
        file,
        bytes,
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

  // todo: add download progress
  AsyncValue downloadItemImage(String filename) {
    // pass keys associated with this function, can be changed or use mulitple
    final detaInstance = Deta(projectKey: donDetaProjectKey);

    final driveInstance =
        DetaDriveInit(detaInstance, DetaDrives.lostFound, filename: filename);

    return _read(detaStorageFileDownloaderProvider(driveInstance));
  }

  Future downloadItemImageFuture(String filename) {
    // pass keys associated with this function, can be changed or use mulitple
    final detaInstance = Deta(projectKey: donDetaProjectKey);

    final driveInstance =
        DetaDriveInit(detaInstance, DetaDrives.lostFound, filename: filename);

    return _read(detaStorageProvider(driveInstance)).download(filename);
  }
}
