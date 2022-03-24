import 'dart:developer';

import 'package:deta/deta.dart' show Deta, DetaQuery;
import 'package:dio/dio.dart';
import 'package:dio_client_deta_api/dio_client_deta_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/modules/learning/data/models/course.dart';
import 'package:mini_campus/src/shared/index.dart';

final courseRepProvider = Provider((_) => CourseRepository());

/// deta base repository
class CourseRepository {
  static final _deta =
      Deta(projectKey: donDetaProjectKey, client: DioClientDetaApi(dio: Dio()));

  static final _courseBase = _deta.base(DetaBases.learnCourse);

  Future addCourse(Course course) async {
    try {
      Map payload = course.toJson();
      payload['key'] = course.code;

      final res = await _courseBase.insert(payload, key: course.code);

      log(res.toString());

      return res;
    }

    // er
    catch (e) {
      log('err ' + e.toString());
    }
  }

  Future getAllCoursesByDpt(String dptCode, String part) async {
    try {
      final res = await _courseBase.fetch(
        query: [
          DetaQuery('dpt').equalTo(dptCode).and('part').equalTo(part),
        ],
      );

      log(res.toString());

      return res;
    }

    // er
    catch (e) {
      log(e.toString());
    }
    return null;
  }
}
