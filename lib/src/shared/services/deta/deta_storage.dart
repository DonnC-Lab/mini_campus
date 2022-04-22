import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:mini_campus/src/shared/libs/index.dart';

final detaStorageProvider =
    ProviderFamily<DetaStorageRepository, DetaDriveInit>((ref, detaDriveInit) {
  return DetaStorageRepository(detaDriveInit);
});

final detaStorageFileDownloaderProvider =
    FutureProviderFamily<dynamic, DetaDriveInit>((ref, detaDriveInit) {
      
  return DetaStorageRepository(detaDriveInit).download(detaDriveInit.filename!);
});

class DetaStorageRepository {
  final DetaDriveInit detaDriveInit;

  DetaStorageRepository(this.detaDriveInit);

  Future getAllFiles({
    int limit = 1000,
    String prefix = '',
    String last = '',
  }) async {
    final drive =
        DetaDrive(drive: detaDriveInit.drive, deta: detaDriveInit.deta);

    final files =
        await drive.listFiles(last: last, limit: limit, prefix: prefix);

    if (files is DetaException) {
      throw files;
    }

    return files;
  }

  Future download(String filename) async {
    final drive =
        DetaDrive(drive: detaDriveInit.drive, deta: detaDriveInit.deta);

    final fileByte = await drive.downloadFile(filename);

    if (fileByte is DetaException) {
      throw fileByte;
    }

    return fileByte;
  }

  Future delete(List<String> files) async {
    final drive =
        DetaDrive(drive: detaDriveInit.drive, deta: detaDriveInit.deta);

    final resp = await drive.deleteFiles(files);

    if (resp is DetaException) {
      throw resp;
    }

    return resp;
  }

  Future upload(
    String file,
    Uint8List bytes, {
    String? directory,
    String? filename,
  }) async {
    final drive =
        DetaDrive(drive: detaDriveInit.drive, deta: detaDriveInit.deta);

    final resp = await drive.uploadFile(file, bytes,
        directory: directory, filename: filename);

    if (resp is DetaException) {
      throw resp;
    }

    return resp;
  }
}
