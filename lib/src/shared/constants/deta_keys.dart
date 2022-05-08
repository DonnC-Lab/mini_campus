// deta databases per module / feature
// ! should not be changed when set and used
class DetaBases {
  // general DBs
  static const String learnCourse = 'learn_courseDB';
  static const String facultyDpt = 'faculty_dptDB';

  // learning manager
  static const String learning = 'learningDB';
  static const String learnResource = 'learn_resourceDB';

  // lost and found
  static const String lostFound = 'lostFoundDB';

  // feedback
  static const String feedback = 'feedbackDB';

  // surveys
  static const String survey = 'surveyDB';
}

// deta drives
class DetaDrives {
  /// for learning manager module
  static const String learning = 'learning';

  /// for lost & found module
  static const String lostFound = 'lost_found';
}
