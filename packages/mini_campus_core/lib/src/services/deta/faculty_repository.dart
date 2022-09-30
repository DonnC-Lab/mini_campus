import 'package:deta_data_source/deta_data_source.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:mini_campus_core/mini_campus_core.dart';

/// deta base repository to get uni
/// faculty and department
class FacultyRepository {
  /// detabase faculty repository
  FacultyRepository(Map<String, dynamic> config)
      : _detaRepository = DetaDataSource(
          baseName: DetaBases.kFacultyDepartmentCollection,
          baseUrl: config['detaBaseUrl'] as String,
        );

  late final DetaDataSource _detaRepository;

  /// fetch all or query by [facultyName] all [FacultyDepartment]
  Future<List<FacultyDepartment>> getFacultyDepartments({
    String? facultyName,
  }) async {
    try {
      Map<String, dynamic>? _query;

      if (facultyName != null) {
        _query = DetaQuery('faculty').equalTo(facultyName).query;
      }

      final res = await _detaRepository.query(
        query: _query,
      );

      final items = res as List<Map<String, dynamic>>;

      return items.map(FacultyDepartment.fromJson).toList();
    }

    // er
    catch (e) {
      debugLogger(e.toString(), name: 'getFacultyDepartments');
    }
    return const [];
  }
}
