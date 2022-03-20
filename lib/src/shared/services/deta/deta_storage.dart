import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/constants/index.dart';
import 'package:mini_campus/src/shared/libs/index.dart';

final detaStoreRepProvider = Provider((ref) {
  return DetaStorageRepository();
});

final detaStorageRepProvider = FutureProvider((ref) {
  return DetaStorageRepository().getAllFiles();
});

final detaFileDownloaderProvider =
    FutureProviderFamily<dynamic, String>((ref, filename) {
  return DetaStorageRepository().download(filename);
});

class DetaStorageRepository {
  final _deta =
      Deta(projectId: donDetaProjectId, projectKey: donDetaProjectKey);

  Future getAllFiles() async {
    final drive = DetaDrive(drive: 'donn', deta: _deta);

    final files = await drive.listFiles();

    if (files is DetaException) {
      throw files;
    }

    return files;
  }

  Future download(String filename) async {
    final drive = DetaDrive(drive: 'donn', deta: _deta);

    final fileByte = await drive.downloadFile(filename);

    if (fileByte is DetaException) {
      throw fileByte;
    }

    return fileByte;
  }

  Future delete(List<String> files) async {
    final drive = DetaDrive(drive: 'donn', deta: _deta);

    final resp = await drive.deleteFiles(files);

    if (resp is DetaException) {
      throw resp;
    }

    return resp;
  }

  Future upload(String file, Uint8List bytes,
      {String? directory, String? filename}) async {
    final drive = DetaDrive(drive: 'donn', deta: _deta);

    final resp = await drive.uploadFile(file, bytes,
        directory: directory, filename: filename);

    if (resp is DetaException) {
      throw resp;
    }

    return resp;
  }
}
