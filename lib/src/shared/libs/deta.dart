// ignore_for_file: non_constant_identifier_names

import 'dart:developer' show log;
import 'dart:io' show File;

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class DetaRepository {
  static const _detaBaseUrl = 'https://py4k7k.deta.dev';

  late final Dio _dio;

  final String? driveName;

  final String? baseName;

  /// deta drive cloud storage
  ///
  /// All exceptions return a [DetaRepositoryException]
  DetaRepository({this.driveName, this.baseName})
      : _dio = Dio(BaseOptions(baseUrl: _detaBaseUrl));

  String getFileName(File file) {
    return path.basename(file.path);
  }

  Future queryBase({Map? query}) async {
    try {
      final res = await _dio.post(
        '/query/',
        data: {
          'filter': query,
          'base_name': baseName,
        },
      );

      if (res.statusCode == 201) {
        return res.data['message'];
      }
    }

    //ee
    catch (e) {
      return _DetaRepositoryExceptionHandler(e);
    }
  }

  Future addBaseData(Map payload, {String? key}) async {
    try {
      final res = await _dio.post(
        '/add/',
        data: {
          'payload': payload,
          'base_name': baseName,
          'key': key,
        },
      );

      if (res.statusCode == 201) {
        return res.data['message'];
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
        '/delete/',
        data: {
          'payload': payload,
          'base_name': baseName,
          'key': key,
        },
      );

      if (res.statusCode == 201) {
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
        ),
        "drive_name": driveName,
        "filename": filename,
        "directory": directory,
      });

      var resp = await _dio.post(
        '/upload/',
        data: formData,
      );

      if (resp.statusCode == 201) {
        return resp.data['name'];
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
  /// return bytes as List<int> if successful
  Future downloadFile(String fileName) async {
    final fileBytesResp = await _dio.get(
      '/download/',
      queryParameters: {
        'filename': fileName,
        'drive_name': driveName,
      },
      options: Options(responseType: ResponseType.bytes),
    );

    return fileBytesResp.data;

    // if (fileBytesResp.statusCode == 200) {
    //   // List<int> file bytes
    //   return fileBytesResp.data;
    // }

    // try {
    //   final Response<List<int>> fileBytesResp = await _dio.get<List<int>>(
    //     '/download/',
    //     queryParameters: {
    //       'filename': fileName,
    //       'drive_name': driveName,
    //     },
    //     options: Options(responseType: ResponseType.bytes),
    //   );

    //   if (fileBytesResp.statusCode == 200) {
    //     // List<int> file bytes
    //     return fileBytesResp.data;
    //   }
    // }

    // //ee
    // catch (e) {
    //   return _DetaRepositoryExceptionHandler(e);
    // }
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
    try {
      final resp = await _dio.get(
        '/files/',
        queryParameters: {
          'drive_name': driveName,
          'limit': limit,
          'prefix': prefix,
          'last': last,
        },
      );

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
      final resp = await _dio.delete(
        '/delete/',
        queryParameters: {
          'filename': filename,
          'drive_name': driveName,
        },
      );

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

    log(exc.toString());

    return exc;
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
