import 'package:freezed_annotation/freezed_annotation.dart';

part 'faculty_department.freezed.dart';
part 'faculty_department.g.dart';

@freezed
class FacultyDepartment with _$FacultyDepartment {
  factory FacultyDepartment({
    required String dptCode,
    required String dptName,

    /// as picked from [Faculty]
    required String faculty,
  }) = _FacultyDepartment;

  factory FacultyDepartment.fromJson(Map<String, dynamic> json) =>
      _$FacultyDepartmentFromJson(json);
}
