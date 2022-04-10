import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:mini_campus/src/shared/libs/index.dart';

final studentStoreProvider = Provider((ref) {
  final appUser = ref.watch(fbAppUserProvider);

  return FirestoreStudentService(uid: appUser!.uid, read: ref.read);
});

class FirestoreStudentService {
  FirestoreStudentService({
    required this.uid,
    required this.read,
  });

  final String uid;

  final Reader read;

  final _service = FirestoreService.instance;

  /// add | update firebase messaging token for this current user [Student]
  Future<void> addNotificationToken(String token) async {
    var tokenPayload = await _getStudentNotificationToken();

    if (tokenPayload == null) {
      await _service.addData(
        collectionName: FirestorePath.token(uid),
        data: {"token": token},
      );
    }

    // e
    else {
      if (tokenPayload.exists) {
        var _serverToken = tokenPayload.data()!['token'];

        if (_serverToken != token) {
          await _service.setData(
            path: FirestorePath.token(uid),
            data: {"token": token},
            merge: true,
          );
        }
      }

      // add new
      else {
        await _service.addData(
          collectionName: FirestorePath.token(uid),
          data: {"token": token},
        );
      }
    }
  }

  Future<String?> getToken({String? studentId}) async {
    try {
      final _token = await _getStudentNotificationToken(studentId: studentId);

      return _token!['token'];
    } catch (e) {
      return null;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> _getStudentNotificationToken(
      {String? studentId}) async {
    try {
      final st =
          await _service.getData(path: FirestorePath.token(studentId ??= uid));

      return st;
    } catch (e) {
      return null;
    }
  }

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

  Future<bool?> checkStudent({String? studentId}) async {
    try {
      final cu = await _service.getData(
          path: FirestorePath.student(studentId ??= uid));

      return cu.exists;
    } catch (e) {
      return null;
    }
  }

  /// check for basic details needed for student profile to use services
  Future<bool?> isStudentProfileComplete() async {
    final appUser = read(fbAppUserProvider);

    try {
      bool? res = false;

      final cs = await checkStudent();

      if (cs == null) {
        res = cs;
      }

      //
      else {
        if (!cs) {
          res = cs;
        }

        // profle complete?
        else {
          final _profile = await getStudentProfile();

          if (_profile != null) {
            bool isComplete = _profile.name!.isNotEmpty &&
                _profile.gender!.isNotEmpty &&
                _profile.department.isNotEmpty &&
                _profile.faculty.isNotEmpty &&
                _profile.departmentCode.isNotEmpty &&
                _profile.email!.isNotEmpty;

            if (isComplete) {
              // update profile here
              read(studentProvider.notifier).state = _profile;
              return true;
            }

            res = isComplete;
          }
        }
      }

      read(studentProvider.notifier).state = Student(
        id: appUser!.uid,
        email: appUser.email.toLowerCase(),
        profilePicture: appUser.photoURL,
        department: '',
        faculty: '',
        departmentCode: '',
        createdOn: DateTime.now(),
      );

      return res;
    }

    // err
    catch (e) {
      read(studentProvider.notifier).state = Student(
        id: appUser!.uid,
        email: appUser.email.toLowerCase(),
        profilePicture: appUser.photoURL,
        department: '',
        faculty: '',
        departmentCode: '',
        createdOn: DateTime.now(),
      );

      return null;
    }
  }

  /// fetch user profile
  Future<Student?> getStudentProfile({String? studentId}) async {
    try {
      final cu = await _service.getData(
          path: FirestorePath.student(studentId ??= uid));

      return Student.fromFirestore(cu);
    } catch (e) {
      return null;
    }
  }

  Stream<Student> getStudentStream({String? studentId}) =>
      _service.documentStream(
        path: FirestorePath.student(studentId ??= uid),
        builder: (data, documentId) => Student.fromJson(data!),
      );

  Future<Student?> updateStudent(Student student) async {
    try {
      await _service.setData(
        path: FirestorePath.student(uid),
        data: student.toJson(),
        merge: true,
      );
      var s = await getStudentProfile(studentId: student.id);
      return s;
    } catch (e) {
      return null;
    }
  }
}
