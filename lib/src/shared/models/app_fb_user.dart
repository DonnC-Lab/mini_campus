import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [AppFbUser] provider
final appFbUserProvider = StateProvider<AppFbUser?>((_) => null);

/// AppFbUser
///
/// general user object from firebase service
@immutable
class AppFbUser {
  const AppFbUser({
    required this.uid,
    required this.email,
    this.photoURL,
    this.displayName,
  });

  final String uid;
  final String email;
  final String? photoURL;
  final String? displayName;

  factory AppFbUser.fromFirebaseUser(User user) {
    return AppFbUser(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName,
      photoURL: user.photoURL,
    );
  }

  @override
  String toString() {
    return 'AppFbUser(uid: $uid, email: $email, photoURL: $photoURL, displayName: $displayName)';
  }
}
