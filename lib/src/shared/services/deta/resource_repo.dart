import 'dart:developer';

import 'package:deta/deta.dart' show Deta, DetaQuery;
import 'package:dio/dio.dart';
import 'package:dio_client_deta_api/dio_client_deta_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/modules/learning/data/models/resource/file_resource.dart';
import 'package:mini_campus/src/shared/index.dart';

final resRepProvider = Provider((_) => FileResourceRepository());

/// deta base repository
class FileResourceRepository {
  static final _deta =
      Deta(projectKey: donDetaProjectKey, client: DioClientDetaApi(dio: Dio()));

  static final _resBase = _deta.base(DetaBases.learnResource);

  Future addFileResource(FileResource fileResource) async {
    try {
      var year = fileResource.year;
      var fname = fileResource.resource.filename;

      var _key = '$year' '_' + fname;

      final res = await _resBase.insert(
        fileResource.toJson(),
        key: _key,
      );

      log(res.toString());

      return res;
    }

    // er
    catch (e) {
      // a possible duplicate error
      log('err ' + e.toString());
    }
  }

  // fix
  Future<List<FileResource>?> getAllFileResourcesByDpt(
      String dptCode, String part) async {
    try {
      final res = await _resBase.fetch(
        query: [
          DetaQuery('dpt').equalTo(dptCode).and('part').equalTo(part),
        ],
      );

      List items = res['items'];

      var i = items.map((e) => FileResource.fromJson(e)).toList();
      log(i.toString());
      return i;
    }

    // er
    catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<FileResource>?> getAllFileResources() async {
    try {
      final res = await _resBase.fetch();

      List items = res['items'];

      var i = items.map((e) => FileResource.fromJson(e)).toList();
      log(i.toString());
      return i;
    }

    // er
    catch (e) {
      log(e.toString());
    }
    return null;
  }
}
