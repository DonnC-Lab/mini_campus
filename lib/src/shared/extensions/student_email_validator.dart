// validate student email(s) here

import 'package:mini_campus/debug_settings.dart';

import '../constants/index.dart';

extension ValidateStudentEmail on String {
  /// validate student email passed
  bool get isValidStudentEmail {
    if (VALIDATE_STUDENT_EMAIL) {
      // TODO: consider looping thru available uni domains
      // ! pass domains as a list of available unis
      return trim().endsWith(nustEmailDomain);
    }

    return true;
  }
}
