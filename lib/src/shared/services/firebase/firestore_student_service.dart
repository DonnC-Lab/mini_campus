import 'dart:async';

import 'package:mini_campus/src/shared/index.dart';
import 'package:mini_campus/src/shared/libs/index.dart';

class FirestoreStudentService {
  FirestoreStudentService({required this.uid});

  final String uid;

  final _service = FirestoreService.instance;

  Future<Student?> addStudent(Student student) async {
    try {
      await _service.setData(
        path: FirestorePath.student(uid),
        data: student.toJson(),
      );

      return student;
    } catch (e) {
      return null;
    }
  }

  Future<bool?> checkStudent() async {
    try {
      final cu = await _service.getData(path: FirestorePath.student(uid));

      return cu.exists;
    } catch (e) {
      return null;
    }
  }

  Stream<Student> getStudentStream(String? studentId) => _service.documentStream(
        path: FirestorePath.student(studentId ??= uid),
        builder: (data, documentId) => Student.fromJson(data!),
      );

  Future<Student?> updatestudent(Student student) async {
    try {
      await _service.setData(
        path: FirestorePath.student(uid),
        data: student.toJson(),
        merge: true,
      );
      return student;
    } catch (e) {
      return null;
    }
  }
}
