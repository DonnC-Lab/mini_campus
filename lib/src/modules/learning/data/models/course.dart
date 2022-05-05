import 'package:freezed_annotation/freezed_annotation.dart';

part 'course.freezed.dart';
part 'course.g.dart';

@freezed
 class Course with _$Course {
  factory  Course({
    /// course name e.g Engineering Mathematics 1A
   required String name,
   /// course code sma2116
   required String code,
   /// department code e.g tee
   required String dpt,

   /// course part e.g part 2
   required String part,
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
}
