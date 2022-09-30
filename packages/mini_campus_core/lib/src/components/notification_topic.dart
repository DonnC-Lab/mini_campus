import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:mini_campus_core/src/extensions/index.dart';
import 'package:mini_campus_core/src/models/index.dart';

/// {@template notify_topic}
/// get all relevent student topic based on student profile

/// proper topics
///
/// [
///   gender,
///   all
///   dptCode,
///   faculty,
///   enrollment year - part 1 part 2...
///   uni
/// ]
/// {@endtemplate}
class NotificationTopic {
  /// {@macro notify_topic}
  NotificationTopic({required this.student, this.university = Uni.nust}) {
    _topics = [];
    _computeTopics();
  }

  /// current student model
  final Student student;

  /// student uni
  final Uni university;

  late List<String> _topics;

  /// notification topics
  List<String> get topics => _topics;

  void _computeTopics() {
    _topics = ['all'];

    _topics
      ..add(student.departmentCode)
      ..add(student.gender!)
      ..add(university.name.toUpperCase())
      ..add(student.faculty)
      ..add(
        getStudentNumberFromEmail(
          student.email,
          UniEmailDomain.uniDomains
              .firstWhere((uni) => uni.university == university),
        )!
            .stringYear,
      );
  }
}
