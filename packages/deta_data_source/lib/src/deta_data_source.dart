// Copyright (c) 2022, DonnC Lab
// https://github.com/DonnC-Lab
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:typed_data';

import 'package:deta_data_source/src/deta_exception_handler.dart';
import 'package:dio/dio.dart';
import 'package:dio_client_rest_api/dio_client_rest_api.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:rest_data_source/rest_data_source.dart';

/// {@template deta_data_source}
/// DETA data source using deta provider server wrapper
/// to abstract sensitive server credentials
/// {@endtemplate}
class DetaDataSource implements RestDataSource {
  /// {@macro deta_data_source}
  DetaDataSource({
    this.driveName,
    this.baseName,
    required this.baseUrl,
  }) {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
    _client = DioClientRestApi(dio: _dio);
  }

  late final Dio _dio;

  /// client to make requests to server
  late final DioClientRestApi _client;

  /// DETA drive name to use for storage
  final String? driveName;

  /// DETA collection name for storing documents, NoSQL
  final String? baseName;

  /// DETA base url to (wrapper) server using DETA as a service
  final String baseUrl;

  @override
  Future<dynamic> add(Map<String, dynamic> payload, {String key = ''}) async {
    try {
      final res = await _client.post(
        Uri.parse('/doc-api/add/?base_name=$baseName&key=$key'),
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
  Future<dynamic> delete(Map<String, dynamic> payload, {String? key}) async {
    try {
      final res = await _client.delete<Map<String, dynamic>>(
        Uri.parse('/doc-api/delete/?base_name=$baseName'),
        data: payload,
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        return res.body?['message'];
      }
    }

    //ee
    catch (e) {
      return detaExceptionHandler(e);
    }
  }

  @override
  Future<dynamic> deleteFiles(String id) {
    // TODO: implement deleteFiles
    throw UnimplementedError();
  }

  @override

  /// (todo) implement downloaded file caching seperately
  /// to reduce server requests
  Future<dynamic> downloadFile(String id) async {
    try {
      final fileBytesResp = await _client.get<List<int>>(
        Uri.parse(
          '/file-api/download/?drive_name=$driveName&filename=$id',
        ),
        options: Options(responseType: ResponseType.bytes),
      );

      if (fileBytesResp.statusCode == 200) {
        return Uint8List.fromList(fileBytesResp.body!);
      }
    }

    // error
    catch (e) {
      return detaExceptionHandler(e);
    }
  }

  @override
  Future<dynamic> listFiles({
    int limit = 1000,
    String prefix = '',
    String? last,
    String? sort,
  }) async {
    final _prefix = Uri.encodeComponent(prefix);

    try {
      final resp = await _client.get<Map<String, dynamic>>(
        Uri.parse(
          '/file-api/files/?drive_name=$driveName&limit=$limit&prefix=$_prefix&last=$last',
        ),
      );

      if (resp.statusCode == 200) {
        return resp.body?['message'];
      }
    }

    // error
    catch (e) {
      return detaExceptionHandler(e);
    }
  }

  @override
  Future<dynamic> query({Map<String, dynamic>? query}) async {
    try {
      final res = await _client.post<Map<String, dynamic>>(
        Uri.parse('/doc-api/query/?base_name=$baseName'),
        data: query,
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        return res.body?['message'];
      }
    }

    // error
    catch (e) {
      return detaExceptionHandler(e);
    }
  }

  @override
  Future<dynamic> uploadFile(
    String filepath, {
    String? directory,
    String? filename,
  }) async {
    try {
      final ext = path.extension(filepath).trim();

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filepath,
          contentType: MediaType('application', ext),
        )
      });

      final resp = await _client.post<Map<String, dynamic>>(
        Uri.parse(
          '/file-api/upload/?drive_name=$driveName&filename=$filename&directory=$directory',
        ),
        data: formData,
      );

      if (resp.statusCode == 201 || resp.statusCode == 200) {
        return resp.body?['message'];
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
