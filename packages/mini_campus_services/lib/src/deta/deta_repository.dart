// ignore_for_file: non_constant_identifier_names

import 'dart:io' show File;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

import '../index.dart';
import 'deta_abstract_repository.dart';
import 'exc_handler.dart';

class DetaRepository extends DetaRepositoryImp {
  static final _cache = FileCacheService();

  late final Dio _dio;

  final String? driveName;

  final String? baseName;

  final String detaBaseUrl;

  /// deta drive cloud storage
  ///
  /// All exceptions return a [DetaRepositoryException]
  DetaRepository({required this.detaBaseUrl, this.driveName, this.baseName})
      : _dio = Dio(BaseOptions(baseUrl: detaBaseUrl));

  @override
  Future queryBase({Map? query}) async {
    try {
      final res = await _dio.post(
        '/doc-api/query/?base_name=$baseName',
        data: query,
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        return res.data['message'];
      }
    }

    //ee
    catch (e) {
      return detaRepositoryExceptionHandler(e);
    }
  }

  @override
  Future addBaseData(Map payload, {String key = ''}) async {
    try {
      final res = await _dio.post(
        '/doc-api/add/?base_name=$baseName&key=$key',
        data: payload,
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        return true;
      }
    }

    //ee
    catch (e) {
      return detaRepositoryExceptionHandler(e);
    }
  }

  @override
  Future deleteBaseData(Map payload, {String? key}) async {
    try {
      final res = await _dio.delete(
        '/doc-api/delete/?base_name=$baseName',
        data: payload,
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        return res.data['message'];
      }
    }

    //ee
    catch (e) {
      return detaRepositoryExceptionHandler(e);
    }
  }

  /// upload a single file to deta drive
  ///
  /// filename is passed must be unique else, existing file will be overwritten
  ///
  /// `directory` - folder to put the file in deta drive e.g home/images/
  @override
  Future uploadFile(
    String filePath, {
    String? directory,
    String? filename,
  }) async {
    try {
      var ext = path.extension(filePath).trim();

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          filePath,
          contentType: MediaType('application', ext),
        )
      });

      var resp = await _dio.post(
        '/file-api/upload/?drive_name=$driveName&filename=$filename&directory=$directory',
        data: formData,
      );

      if (resp.statusCode == 201 || resp.statusCode == 200) {
        return resp.data['message'];
      }

      if (resp.statusCode == 413) {
        throw Exception('File size too large');
      }
    }

    // err
    catch (e) {
      return detaRepositoryExceptionHandler(e);
    }
  }

  /// download deta cloud file
  ///
  /// filename is as received while performing [uploadFile]
  ///
  /// returns [File] on successful
  @override
  Future downloadFile(String fileName) async {
    final cached = await _cache.getFileCache(fileName);

    if (cached != null) {
      return cached;
    }

    try {
      final fileBytesResp = await _dio.get(
        '/file-api/download/?drive_name=$driveName&filename=$fileName',
        options: Options(responseType: ResponseType.bytes),
      );

      if (fileBytesResp.statusCode == 200) {
        final fBytes = Uint8List.fromList(fileBytesResp.data);

        final cachedFile = await _cache.addFileCache(
            fileName, fBytes, path.extension(fileName));

        return cachedFile;
      }
    }

    //ee
    catch (e) {
      return detaRepositoryExceptionHandler(e);
    }
  }

  /// list drive files
  ///
  /// prefix - The prefix that each file name must have.
  ///
  /// last - The last file name seen in a paginated response.
  ///
  /// result
  /// Content-Type: application/json
  /// ```json
  /// {
  ///     "status":"",
  ///     "message": ["file1", "file2", ...]
  /// }
  /// ```
  @override
  Future listFiles({
    int limit = 1000,
    String prefix = '',
    String? last,
  }) async {
    var _prefix = Uri.encodeComponent(prefix);
    try {
      final resp = await _dio.get(
        '/file-api/files/?drive_name=$driveName&limit=$limit&prefix=$_prefix&last=$last',
      );

      if (resp.statusCode == 200) {
        return resp.data['message'];
      }
    }

    //ee
    catch (e) {
      return detaRepositoryExceptionHandler(e);
    }
  }

  /// delete drive file
  @override
  Future deleteFiles(String filename) async {
    try {
      final resp = await _dio
          .delete('/file-api/delete/?drive_name=$driveName&filename=$filename');

      if (resp.statusCode == 200) {
        return resp.data;
      }
    } catch (e) {
      return detaRepositoryExceptionHandler(e);
    }
  }
}
