library firebase_auth_service;

import 'dart:developer' show log;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_campus_services/mini_campus_services.dart';

/// {@template auth_service}
/// Firebase Authentication Service
///
/// returns [AppFbUser] on success
///
/// general auth service, returns [CustomException] on exception
/// {@endtemplate}
class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// get current firebase auth user
  User? get getUser => _firebaseAuth.currentUser;

  /// get current [AppFbUser] from current firebase user
  AppFbUser get currentUser => AppFbUser.fromFirebaseUser(getUser!);

  /// stream [AppFbUser] auth changes
  Stream<AppFbUser?> authStateChanges() => _firebaseAuth
      .authStateChanges()
      .map((user) => user == null ? null : AppFbUser.fromFirebaseUser(user));

  /// {@macro auth_service}
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithCredential(
        EmailAuthProvider.credential(email: email, password: password),
      );

      await userCredential.user?.reload();

      final _user = await _firebaseAuth.authStateChanges().first;

      // check if email is verified
      if (_user!.emailVerified) {
        return AppFbUser.fromFirebaseUser(userCredential.user!);
      } else {
        await _user.sendEmailVerification();

        return CustomException(
          message:
              'Email provided not verified. A verification link has been sent'
              ' to your email, check your email to complete process',
        );
      }
    } on FirebaseAuthException catch (e) {
      log(e.message!);

      return CustomException(message: e.message);
    } catch (e) {
      log(e.toString(), level: 3);
      return CustomException(message: e.toString());
    }
  }

  /// {@macro auth_service}
  Future registerNewUser(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AppFbUser.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      log(e.message!);

      return CustomException(message: e.message);
    } catch (e) {
      log(e.toString(), level: 3);
      return CustomException(message: e.toString());
    }
  }

  /// forgot password, send reset instructions to email
  Future sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      log(e.message!);

      return CustomException(message: e.message);
    } catch (e) {
      log(e.toString(), level: 3);
      return CustomException(message: e.toString());
    }
  }

  /// logout of firebase
  Future signOut() async => _firebaseAuth.signOut();
}
