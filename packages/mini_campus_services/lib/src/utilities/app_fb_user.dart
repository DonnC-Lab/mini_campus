import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// AppFbUser
///
/// general user object from firebase service
@immutable
class AppFbUser {
  /// [AppFbUser] instance
  const AppFbUser({
    required this.uid,
    required this.email,
    this.photoURL,
    this.displayName,
  });

  /// create a [AppFbUser] from firebase auth [User]
  factory AppFbUser.fromFirebaseUser(User user) {
    return AppFbUser(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName,
      photoURL: user.photoURL,
    );
  }

  /// firebase user id
  final String uid;

  /// user email
  final String email;

  /// user profile url
  final String? photoURL;

  /// user dislay name from firebase auth
  final String? displayName;

  @override
  String toString() {
    return 'AppFbUser(uid: $uid, email: $email, '
        'photoURL: $photoURL, displayName: $displayName)';
  }
}
