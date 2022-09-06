// Copyright (c) 2022, DonnC Lab
// https://github.com/DonnC-Lab
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:deta_data_source/src/deta_exception_handler.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:rest_data_source/rest_data_source.dart';

/// {@template deta_data_source}
/// DETA data source using deta provider
/// {@endtemplate}
class DetaDataSource implements RestDataSource {
  /// {@macro deta_data_source}
  DetaDataSource({
    this.driveName,
    this.baseName,
    required this.baseUrl,
  }) : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  late final Dio _dio;

  final String? driveName;

  final String? baseName;

  final String baseUrl;

  @override
  Future add(Map<String, dynamic> payload, {String key = ''}) async {
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
      return detaExceptionHandler(e);
    }
  }

  @override
  Future delete(Map<String, dynamic> payload, {String? key}) async {
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
      return detaExceptionHandler(e);
    }
  }

  @override
  Future deleteFiles(String id) {
    // TODO: implement deleteFiles
    throw UnimplementedError();
  }

  @override
  Future downloadFile(String id) {
    // TODO: implement downloadFile
    throw UnimplementedError();
  }

  @override
  Future listFiles({
    int limit = 1000,
    String prefix = '',
    String? last,
    String? sort,
  }) {
    // TODO: implement listFiles
    throw UnimplementedError();
  }

  @override
  Future query({Map<String, dynamic>? query}) {
    // TODO: implement query
    throw UnimplementedError();
  }

  @override
  Future uploadFile(String filepath,
      {String? directory, String? filename}) async {
    try {
      final ext = path.extension(fileP = path).trim();

      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filepath,
          contentType: MediaType('application', ext),
        )
      });

      final resp = await _dio.post(
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
      return detaExceptionHandler(e);
    }
  }
}
