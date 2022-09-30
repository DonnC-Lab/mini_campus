import 'package:deta_data_source/deta_data_source.dart';

/// [DetaStorageRepository] service class for Deta Drive service
/// acts as cloud storage
class DetaStorageRepository {
  /// create [DetaStorageRepository] instance
  DetaStorageRepository(
    Map<String, dynamic> config,
    this.detaDriveInit,
  ) : _detaRepository = DetaDataSource(
          driveName: detaDriveInit.drive,
          baseName: detaDriveInit.base,
          baseUrl: config['detaBaseUrl'] as String,
        );

  /// deta db fields holder
  final DetaDriveInit detaDriveInit;

  late final DetaDataSource _detaRepository;

  /// get all cloud storage files
  /// return list of files
  Future getAllFiles({
    int limit = 1000,
    String prefix = '',
    String? last,
  }) async {
    final files = await _detaRepository.listFiles(
      last: last,
      limit: limit,
      prefix: prefix,
    );

    if (files is DetaException) {
      throw files;
    }

    return files;
  }

  Future download(String filename) async {
    final fileByte = await _detaRepository.downloadFile(filename);

    if (fileByte is DetaException) {
      throw fileByte;
    }

    return fileByte;
  }

  Future delete(String file) async {
    final resp = await _detaRepository.deleteFiles(file);

    if (resp is DetaException) {
      throw resp;
    }

    return resp;
  }

  Future upload(
    String file, {
    String? directory,
    String? filename,
  }) async {
    final resp = await _detaRepository.uploadFile(
      file,
      directory: directory,
      filename: filename,
    );

    if (resp is DetaException) {
      throw resp;
    }

    return resp;
  }
}
