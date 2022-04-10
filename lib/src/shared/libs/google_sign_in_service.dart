library google_sign_in_service;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mini_campus/src/shared/extensions/index.dart';

import '../index.dart';

class GoogleSignInService {
  /// returns [AppFbUser] on success, else [CustomException]
  Future signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();

    final googleUser = await googleSignIn.signIn();

    try {
      if (googleUser != null) {
        // todo verify student email here

        final bool _proceed = googleUser.email.isValidStudentEmail;

        if (_proceed) {
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;

          if (googleAuth.idToken != null) {
            final userCredential = await FirebaseAuth.instance
                .signInWithCredential(GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken,
            ));
            return AppFbUser.fromFirebaseUser(userCredential.user!);
          }

          //
          else {
            return CustomException(message: 'Missing Google ID Token');
            // throw FirebaseException(
            //   plugin: runtimeType.toString(),
            //   code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
            //   message: 'Missing Google ID Token',
            // );
          }
        }

        // not uni email
        else {
          return CustomException(
            message: 'Email provided not a valid student email!',
          );
        }
      }

      // err
      else {
        return CustomException(message: 'Sign in aborted by user');
      }
    }

    // fb err
    on FirebaseAuthException catch (e) {
      debugLogger(e.message!);

      return CustomException(message: e.message);
    }

    // err
    catch (e) {
      debugLogger(e.toString(), level: 3);
      return CustomException(message: e.toString());
    }
  }
}
