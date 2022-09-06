/// common app firebase collections
class FirestorePath {
  /// students collection
  static String get kStudents => 'students';

  /// get single student
  static String kStudent(String uid) => '$kStudents/$uid';

  /// tokens collection
  static String get kTokens => 'tokens';

  /// get single token
  static String kToken(String uid) => '$kTokens/$uid';
}

/// common storage path
class CloudStoragePath {
  /// path to user profile pic
  ///
  /// stored per User id folder,
  /// leave file name as it will be pre-appended automatically
  static String kProfilePicture(String studentId) => 'profile/$studentId';
}
