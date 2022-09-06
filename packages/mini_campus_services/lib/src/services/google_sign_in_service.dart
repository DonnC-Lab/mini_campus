library google_sign_in_service;

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'utilities/index.dart';

class GoogleSignInService {
  /// returns [AppFbUser] on success, else [CustomException]
  Future signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();

    final googleUser = await googleSignIn.signIn();

    try {
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        if (googleAuth.idToken != null) {
          final userCredential = await FirebaseAuth.instance
              .signInWithCredential(GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ));

          // if (BYPASS_EMAIL_VALIDATION_CHECK) {
          //   return AppFbUser.fromFirebaseUser(userCredential.user!);
          // }

          await userCredential.user?.reload();

          final currentUser =
              await FirebaseAuth.instance.authStateChanges().first;

          // check if email is verified
          if (currentUser!.emailVerified) {
            return AppFbUser.fromFirebaseUser(userCredential.user!);
          }

          //
          else {
            await currentUser.sendEmailVerification();

            return CustomException(
              message:
                  'Email provided not verified. A verification link has been sent to your email, check your email to complete process',
            );
          }
        }

        //
        else {
          return CustomException(message: 'Missing Google ID Token');
        }
      }

      // err
      else {
        return CustomException(message: 'Sign in aborted by user');
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
}
