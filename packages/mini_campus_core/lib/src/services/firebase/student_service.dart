import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:mini_campus_core/mini_campus_core.dart';
import 'package:mini_campus_services/mini_campus_services.dart';

/// [FirestoreStudentService] provider DI
final studentStoreProvider = Provider((ref) {
  final appUser = ref.watch(fbAppUserProvider);

  return FirestoreStudentService(uid: appUser?.uid ?? '', ref: ref);
});

/// [Student] profile provider
final studentProfileProvider =
    FutureProviderFamily<Student?, String>((ref, uid) {
  final api = ref.watch(studentStoreProvider);

  return api.getStudentProfile(studentId: uid);
});

/// firestore student service
class FirestoreStudentService {
  /// firestore student service
  FirestoreStudentService({
    required this.uid,
    required this.ref,
  });

  /// student firebase doc id
  final String uid;

  /// riverpod reader to access other providers
  final Ref ref;

  final _service = FirestoreService.instance;

  /// add | update firebase messaging token for this current user [Student]
  Future<void> addNotificationToken(String token) async {
    final tokenPayload = await _getStudentNotificationToken();

    if (tokenPayload == null) {
      await _service.setData(
        path: FirestorePath.kToken(uid),
        data: {'token': token},
      );
    }

    // e
    else {
      if (tokenPayload.exists) {
        final _serverToken = tokenPayload.data()!['token'];

        if (_serverToken != token) {
          await _service.setData(
            path: FirestorePath.kToken(uid),
            data: {'token': token},
            merge: true,
          );
        }
      }

      // add new
      else {
        await _service.setData(
          path: FirestorePath.kToken(uid),
          data: {'token': token},
        );
      }
    }
  }

  /// get student device token
  ///
  /// if [studentId] is null, use currently logged in student instead
  Future<String?> getToken({String? studentId}) async {
    try {
      final _token = await _getStudentNotificationToken(studentId: studentId);

      return _token?.data()!['token'] as String;
    } catch (e) {
      return null;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> _getStudentNotificationToken({
    String? studentId,
  }) async {
    try {
      final st =
          await _service.getData(path: FirestorePath.kToken(studentId ??= uid));

      return st;
    } catch (e) {
      return null;
    }
  }

  /// save student to firestore
  Future<Student?> addStudent(Student student) async {
    try {
      await _service.setData(
        path: FirestorePath.kStudent(student.id!),
        data: student.toJson(),
      );

      return student;
    } catch (e) {
      debugLogger(e, name: 'addStudent');
      return null;
    }
  }

  /// check if student with [studentId] exists
  Future<bool?> checkStudent({String? studentId}) async {
    try {
      final cu = await _service.getData(
        path: FirestorePath.kStudent(studentId ??= uid),
      );

      return cu.exists;
    } catch (e) {
      return null;
    }
  }

  /// check for basic details needed for student profile to use services
  Future<bool?> isStudentProfileComplete() async {
    final appUser = ref.read(fbAppUserProvider);

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

          // debugLogger(_profile, name: 'isStudentProfileComplete');

          if (_profile != null) {
            final isComplete = _profile.name!.isNotEmpty &&
                _profile.gender != null &&
                _profile.department.isNotEmpty &&
                _profile.faculty.isNotEmpty &&
                _profile.departmentCode.isNotEmpty &&
                _profile.email.isNotEmpty;

            ref.read(studentProvider.notifier).state = _profile;

            return isComplete;
          }
        }
      }

      ref.read(studentProvider.notifier).state = Student(
        id: appUser!.uid,
        email: appUser.email.toLowerCase(),
        profilePicture: appUser.photoURL,
        department: '',
        faculty: '',
        departmentCode: '',
        createdOn: DateTime.now(),
        studentNumber: getStudentNumberFromEmail(
          appUser.email,
          UniEmailDomain.uniDomains
              .firstWhere((uni) => uni.university == ref.read(studentUniProvider)),
        )?.studentNumber,
      );

      return res;
    }

    // err
    catch (e) {
      debugLogger(e, name: 'isStudentProfileComplete');
      ref.read(studentProvider.notifier).state = Student(
        id: appUser!.uid,
        email: appUser.email.toLowerCase(),
        profilePicture: appUser.photoURL,
        department: '',
        faculty: '',
        departmentCode: '',
        createdOn: DateTime.now(),
        studentNumber: getStudentNumberFromEmail(
          appUser.email,
          UniEmailDomain.uniDomains
              .firstWhere((uni) => uni.university == ref.read(studentUniProvider)),
        )?.studentNumber,
      );

      return null;
    }
  }

  /// fetch user profile
  Future<Student?> getStudentProfile({String? studentId}) async {
    try {
      final cu = await _service.getData(
        path: FirestorePath.kStudent(studentId ??= uid),
      );

      return Student.fromFirestore(cu);
    } catch (e) {
      debugLogger(e, name: 'getStudentProfile');
      return null;
    }
  }

  /// return [Stream] of [Student]
  Stream<Student> getStudentStream({String? studentId}) =>
      _service.documentStream(
        path: FirestorePath.kStudent(studentId ??= uid),
        builder: (data, documentId) => Student.fromJson(data!),
      );

  /// update student profile
  ///
  /// also update student shared pref profile
  Future<Student?> updateStudent(Student student) async {
    try {
      await _service.setData(
        path: FirestorePath.kStudent(uid),
        data: student.toJson(),
        merge: true,
      );
      final s = await getStudentProfile(studentId: student.id);
      ref.read(studentProvider.notifier).state = s;

      // update cache too
      final _sharedPref = ref.read(sharedPreferencesServiceProvider);

      await _sharedPref.setCurrentStudent(s!);

      return s;
    } catch (e) {
      return null;
    }
  }
}
