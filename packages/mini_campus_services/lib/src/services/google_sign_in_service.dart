library google_sign_in_service;

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mini_campus_services/mini_campus_services.dart';

/// google service wrapper class
///
/// returns [AppFbUser] on success, else [CustomException]
class GoogleSignInService {
  static final _googleSignIn = GoogleSignIn();

  /// sign in with google
  Future signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();

    try {
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;

        if (googleAuth.idToken != null) {
          final userCredential =
              await FirebaseAuth.instance.signInWithCredential(
            GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken,
            ),
          );

          await userCredential.user?.reload();

          final currentUser =
              await FirebaseAuth.instance.authStateChanges().first;

          // check if email is verified
          if (currentUser!.emailVerified) {
            return AppFbUser.fromFirebaseUser(userCredential.user!);
          } else {
            await currentUser.sendEmailVerification();

            return CustomException(
              message: 'Email provided not verified. A verification link has'
                  ' been sent to your email, check your email'
                  ' to complete process',
            );
          }
        } else {
          return CustomException(message: 'Missing Google ID Token');
        }
      } else {
        return CustomException(message: 'Sign in aborted by user');
      }
    } on FirebaseAuthException catch (e) {
      log(e.message!);

      return CustomException(message: e.message);
    } catch (e) {
      log(e.toString(), level: 3);
      return CustomException(message: e.toString());
    }
  }
}
