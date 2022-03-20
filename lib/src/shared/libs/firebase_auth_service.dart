library firebase_auth_service;

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../index.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AppFbUser get currentUser =>
      AppFbUser.fromFirebaseUser(_firebaseAuth.currentUser!);

  Stream<AppFbUser> authStateChanges() {
    return _firebaseAuth
        .authStateChanges()
        .map((user) => AppFbUser.fromFirebaseUser(user!));
  }

  Future<AppFbUser> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return AppFbUser.fromFirebaseUser(userCredential.user!);
  }

  Future<AppFbUser> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential =
        await _firebaseAuth.signInWithCredential(EmailAuthProvider.credential(
      email: email,
      password: password,
    ));

    return AppFbUser.fromFirebaseUser(userCredential.user!);
  }

  Future registerNewUser(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return AppFbUser.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      log(e.message!);

      return CustomException(message: e.message);
    } catch (e) {
      log(e.toString(), level: 3);
      return CustomException(message: e.toString());
    }
  }

  Future sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future signOut() async {
    return _firebaseAuth.signOut();
  }
}
