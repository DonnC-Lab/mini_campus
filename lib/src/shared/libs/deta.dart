// ignore_for_file: non_constant_identifier_names

import 'dart:io' show File;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

import '../services/index.dart';

class DetaRepository {
  static const _detaBaseUrl = 'https://py4k7k.deta.dev';

  static final _cache = _DetaDriveCache();

  late final Dio _dio;

  final String? driveName;

  final String? baseName;

  /// deta drive cloud storage
  ///
  /// All exceptions return a [DetaRepositoryException]
  DetaRepository({this.driveName, this.baseName})
      : _dio = Dio(BaseOptions(baseUrl: _detaBaseUrl));

  String _getFileExt(String filename) {
    return path.extension(filename).replaceAll('.', '').trim();
  }

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
      return _DetaRepositoryExceptionHandler(e);
    }
  }

  Future addBaseData(Map payload, {String key = ''}) async {
    try {
      final res = await _dio.post(
        '/doc-api/add/?base_name=$baseName&key=$key',
        data: payload,
      );

      debugLogger(res, name: 'addBase');

      if (res.statusCode == 201 || res.statusCode == 200) {
        return true;
      }
    }

    //ee
    catch (e) {
      return _DetaRepositoryExceptionHandler(e);
    }
  }

  // TODO: proper implentation
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
      return _DetaRepositoryExceptionHandler(e);
    }
  }

  /// upload a single file to deta drive
  ///
  /// filename is passed must be unique else, existing file will be overwritten
  ///
  /// `directory` - folder to put the file in deta drive e.g home/images/
  Future uploadFile(String filePath,
      {String? directory, String? filename}) async {
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
      return _DetaRepositoryExceptionHandler(e);
    }
  }

  /// download deta cloud file
  ///
  /// filename is as received while performing [uploadFile]
  ///
  /// returns [File] on successful
  Future downloadFile(String fileName) async {
    // check cache first
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

        final cachedFile =
            await _cache.addFileCache(fileName, fBytes, _getFileExt(fileName));

        return cachedFile;
      }
    }

    //ee
    catch (e) {
      return _DetaRepositoryExceptionHandler(e);
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
  Future listFiles({
    int limit = 1000,
    String prefix = '',
    String? last,
  }) async {
    var _prefix = Uri.encodeComponent(prefix);
    try {
      final resp = await _dio.get(
          '/file-api/files/?drive_name=$driveName&limit=$limit&prefix=$_prefix&last=$last');

      if (resp.statusCode == 200) {
        return resp.data['message'];
      }
    }

    //ee
    catch (e) {
      return _DetaRepositoryExceptionHandler(e);
    }
  }

  /// delete drive file
  Future deleteFiles(String filename) async {
    try {
      final resp = await _dio
          .delete('/file-api/delete/?drive_name=$driveName&filename=$filename');

      if (resp.statusCode == 200) {
        return resp.data;
      }
    }

    //ee
    catch (e) {
      return _DetaRepositoryExceptionHandler(e);
    }
  }

  DetaRepositoryException _DetaRepositoryExceptionHandler(Object e) {
    final Exception err = e as Exception;

    DetaRepositoryException exc =
        DetaRepositoryException(message: err.toString());

    if (err is DioError) {
      if (err.type == DioErrorType.response) {
        try {
          var errors = err.response?.data['error'] as List;
          exc.copyWith(message: errors.join(", "));
        } catch (e) {
          try {
            exc.copyWith(message: err.response?.data['detail']);
          } catch (e) {
            exc.copyWith(message: err.message);
          }
        }
      }

      // general err
      else {
        exc.copyWith(message: err.message);
      }
    }

    debugLogger(exc, name: 'deta-exception-handler');

    return exc;
  }
}

/// cache manager for deta images | pdf files *prefferably
class _DetaDriveCache {
  static final _cacheManager = DefaultCacheManager();

  Future<File> addFileCache(String fname, Uint8List bytes, String ext) async =>
      await _cacheManager.putFile(
        fname,
        bytes,
        key: fname,
        eTag: fname,
        fileExtension: ext,
      );

  Future<File?> getFileCache(String fname) async {
    // key == filename
    final res = await _cacheManager.getFileFromCache(fname);

    return res?.file;
  }
}

/// deta exception base class
class DetaRepositoryException implements Exception {
  String? message;

  DetaRepositoryException({this.message = 'Deta: Something went wrong!'});

  @override
  String toString() => 'DetaRepositoryException(message: $message)';

  DetaRepositoryException copyWith({
    String? message,
  }) {
    return DetaRepositoryException(
      message: message ?? this.message,
    );
  }
}
