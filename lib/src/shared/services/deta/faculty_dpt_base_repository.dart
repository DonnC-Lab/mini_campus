import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:mini_campus/src/shared/libs/index.dart';

final fDptRepProvider = Provider((_) => FacultyDptBaseRepository());

/// deta base repository
class FacultyDptBaseRepository {
  static final DetaRepository _detaRepository =
      DetaRepository(baseName: DetaBases.facultyDpt);

  Future<List<FacultyDpt>> getFacultyDptByFaculty(Faculty faculty) async {
    try {
      final res = await _detaRepository.queryBase(
        query: DetaQuery('faculty').equalTo(faculty.name).query,
      );

      debugLogger(res.toString());

      List items = res;

      return items.map((e) => FacultyDpt.fromJson(e)).toList();
    }

    // er
    catch (e) {
      debugLogger(e.toString());
    }
    return [];
  }

  Future<List<FacultyDpt>> getAllFacultyDpt() async {
    try {
      final res = await _detaRepository.queryBase();

      debugLogger(res.toString());

      List items = res;

      return items.map((e) => FacultyDpt.fromJson(e)).toList();
    }

    // er
    catch (e) {
      debugLogger(e.toString());
    }
    return [];
  }
}
