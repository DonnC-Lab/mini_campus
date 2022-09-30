// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Student _$$_StudentFromJson(Map<String, dynamic> json) => _$_Student(
      id: json['id'] as String?,
      email: json['email'] as String,
      name: json['name'] as String?,
      alias: json['alias'] as String?,
      profilePicture: json['profilePicture'] as String?,
      whatsappNumber: json['whatsappNumber'] as String? ?? '',
      about: json['about'] as String? ?? '',
      gender: json['gender'] as String?,
      campusLocation: json['campusLocation'] as String? ?? '',
      department: json['department'] as String,
      faculty: json['faculty'] as String,
      departmentCode: json['departmentCode'] as String,
      studentNumber: json['studentNumber'] as String?,
      createdOn: firestoreDateOnFromJson(json['createdOn'] as Timestamp),
    );

Map<String, dynamic> _$$_StudentToJson(_$_Student instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'alias': instance.alias,
      'profilePicture': instance.profilePicture,
      'whatsappNumber': instance.whatsappNumber,
      'about': instance.about,
      'gender': instance.gender,
      'campusLocation': instance.campusLocation,
      'department': instance.department,
      'faculty': instance.faculty,
      'departmentCode': instance.departmentCode,
      'studentNumber': instance.studentNumber,
      'createdOn': firestoreDateOnToJson(instance.createdOn),
    };
