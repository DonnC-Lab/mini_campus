// ? secure keys, need another way to secure keys
const String donDetaProjectKey = 'a0iayg6n_F2TSaN4MnKogj9bMW4Wj95mYG8FSr5q4';

// additional deta keys per module | project need
const String kingDetaProjectKey = '';

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
}

// deta drives
class DetaDrives {
  /// for learning manager module
  static const String learning = 'learning';

  /// for lost & found module
  static const String lostFound = 'lost_found';
}
