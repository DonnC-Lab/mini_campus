class FirestorePath {
  static String get students => 'students';
  static String student(String uid) => '$students/$uid';

  // tokens
  static String get tokens => 'tokens';
  static String token(String uid) => '$tokens/$uid';
}

class CloudStoragePath {
  /// path to user profile pic
  ///
  /// stored per User id folder, leave file name as it will be pre-appended automatically
  static String profilePicture(String studentId) => 'profile/$studentId';
}
