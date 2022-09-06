library firebase_auth_service;

import 'dart:developer' show log;

import 'package:firebase_auth/firebase_auth.dart';

import 'utilities/index.dart';

/// general auth service, returns [CustomException] on exception
class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get checkCurrentUser => _firebaseAuth.currentUser;

  AppFbUser get currentUser => AppFbUser.fromFirebaseUser(checkCurrentUser!);

  Stream<AppFbUser?> authStateChanges() => _firebaseAuth
      .authStateChanges()
      .map((user) => user == null ? null : AppFbUser.fromFirebaseUser(user));

  /// returns [AppFbUser] on success else [CustomException]
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithCredential(
          EmailAuthProvider.credential(email: email, password: password));

      await userCredential.user?.reload();

      final currentUser = await _firebaseAuth.authStateChanges().first;

      // check if email is verified
      if (currentUser!.emailVerified) {
        return AppFbUser.fromFirebaseUser(userCredential.user!);
      }

      //
      else {
        await currentUser.sendEmailVerification();

        return CustomException(
            message:
                'Email provided not verified. A verification link has been sent to your email, check your email to complete process');
      }
    }

    // fb err
    on FirebaseAuthException catch (e) {
      log(e.message!);

      return CustomException(message: e.message);
    }

    // err
    catch (e) {
      log(e.toString(), level: 3);
      return CustomException(message: e.toString());
    }
  }

  Future registerNewUser(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return AppFbUser.fromFirebaseUser(userCredential.user!);
    }

    // fb err
    on FirebaseAuthException catch (e) {
      log(e.message!);

      return CustomException(message: e.message);
    }

    // err
    catch (e) {
      log(e.toString(), level: 3);
      return CustomException(message: e.toString());
    }
  }

  Future sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    }

    // fb err
    on FirebaseAuthException catch (e) {
      log(e.message!);

      return CustomException(message: e.message);
    }

    // err
    catch (e) {
      log(e.toString(), level: 3);
      return CustomException(message: e.toString());
    }
  }

  Future signOut() async => _firebaseAuth.signOut();
}
