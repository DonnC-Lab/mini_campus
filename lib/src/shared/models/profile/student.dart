// general shared student model
// ignore_for_file: invalid_annotation_target

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../index.dart';

part 'student.freezed.dart';
part 'student.g.dart';

@freezed
class Student with _$Student {
  const Student._();

  factory Student({
    String? id,

    /// student institution email
    required String email,
    String? name,
    String? alias,
    String? profilePicture,
    @Default('') String whatsappNumber,
    @Default('') String about,

    /// to use for targeted notification
    String? gender,

    /// will automatically be picked on the fly from student email using extension
    //int? year,

    /// student resident during campus
    @Default('') String campusLocation,

    /// full department name, Electronic Engineering
    required String department,
    required String faculty,

    /// tee, tcw ...
    required String departmentCode,

    /// fetched from student org email
    String? studentNumber,
    @JsonKey(name: 'createdOn', fromJson: firestoreDateOnFromJson, toJson: firestoreDateOnToJson)
        required DateTime createdOn,
  }) = _Student;

  factory Student.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    //Map<String, dynamic>? json = doc.data;
    Student st = Student.fromJson(doc.data()!);
    return st.copyWith(id: doc.id);
  }

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}
