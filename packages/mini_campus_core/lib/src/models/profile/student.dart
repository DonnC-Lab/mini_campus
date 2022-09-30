// ignore_for_file: invalid_annotation_target, public_member_api_docs

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_campus_core/src/utils/date_converter.dart';

part 'student.freezed.dart';
part 'student.g.dart';

@freezed
class Student with _$Student {
  factory Student({
    String? id,

    /// student institution email
    required String email,
    String? name,
    String? alias,
    String? profilePicture,
    @Default('')
        String whatsappNumber,
    @Default('')
        String about,
    String? gender,

    /// student resident during campus
    @Default('')
        String campusLocation,

    /// full department name, Electronic Engineering
    required String department,
    required String faculty,

    /// tee, tcw ...
    required String departmentCode,

    /// fetched from student org email
    String? studentNumber,
    @JsonKey(
      name: 'createdOn',
      fromJson: firestoreDateOnFromJson,
      toJson: firestoreDateOnToJson,
    )
        required DateTime createdOn,
  }) = _Student;
  const Student._();

  factory Student.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final st = Student.fromJson(doc.data()!);
    return st.copyWith(id: doc.id);
  }

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}
