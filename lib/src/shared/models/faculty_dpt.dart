import 'package:freezed_annotation/freezed_annotation.dart';

part 'faculty_dpt.freezed.dart';
part 'faculty_dpt.g.dart';

@freezed
 class FacultyDpt with _$FacultyDpt {
  factory  FacultyDpt({
    required String dptCode,
   required String dptName,
   required String faculty,
  }) = _FacultyDpt;

  factory FacultyDpt.fromJson(Map<String, dynamic> json) =>
      _$FacultyDptFromJson(json);
}

