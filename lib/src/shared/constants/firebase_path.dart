class FirestorePath {
  static String get students => 'students';
  static String student(String uid) => '$students/$uid';

  // tokens
  static String get tokens => 'tokens';
  static String token(String uid) => '$tokens/$uid';
}
