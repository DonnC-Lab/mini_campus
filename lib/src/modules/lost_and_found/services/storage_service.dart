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

  // todo: add download progress
  AsyncValue downloadItemImage(String filename) {
    final driveInstance =
        DetaDriveInit(drive: DetaDrives.lostFound, filename: filename);

    return _read(detaStorageFileDownloaderProvider(driveInstance));
  }

  Future downloadItemImageFuture(String filename) {
    final driveInstance =
        DetaDriveInit(drive: DetaDrives.lostFound, filename: filename);

    return _read(detaStorageProvider(driveInstance)).download(filename);
  }
}
