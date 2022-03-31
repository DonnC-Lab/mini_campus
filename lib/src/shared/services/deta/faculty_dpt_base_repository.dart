import 'dart:developer';

import 'package:deta/deta.dart' show Deta, DetaQuery;
import 'package:dio/dio.dart';
import 'package:dio_client_deta_api/dio_client_deta_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';

final fDptRepProvider = Provider((_) => FacultyDptBaseRepository());

/// deta base repository
class FacultyDptBaseRepository {
  static final _deta =
      Deta(projectKey: donDetaProjectKey, client: DioClientDetaApi(dio: Dio()));

  static final _fDeptBase = _deta.base(DetaBases.facultyDpt);

  Future addFacultyDepartment(FacultyDpt facultyDpt) async {
    try {
      final res =
          await _fDeptBase.put(facultyDpt.toJson(), key: facultyDpt.dptCode);

      log(res.toString());

      return res;
    }

    // er
    catch (e) {
      log(e.toString());
    }
  }

  Future<List<FacultyDpt>?> getFacultyDptByFaculty(Faculty faculty) async {
    try {
      final res = await _fDeptBase.fetch(
        query: [
          DetaQuery('faculty').equalTo(faculty.name),
        ],
      );

      log(res.toString());

      List items = res['items'];

      return items.map((e) => FacultyDpt.fromJson(e)).toList();
    }

    // er
    catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<FacultyDpt>?> getAllFacultyDpt() async {
    try {
      final res = await _fDeptBase.fetch();

      log(res.toString());

      List items = res['items'];

      return items.map((e) => FacultyDpt.fromJson(e)).toList();
    }

    // er
    catch (e) {
      log(e.toString());
    }
    return null;
  }
}
