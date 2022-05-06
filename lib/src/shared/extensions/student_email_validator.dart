// validate student email(s) here

import 'package:mini_campus/debug_settings.dart';

import '../constants/index.dart';

extension ValidateStudentEmail on String {
  bool get isValidStudentEmail {
    if (VALIDATE_STUDENT_EMAIL) {
      // TODO: consider looping thru available added global uni domains
      return trim().endsWith(nustEmailDomain);
    }

    return true;
  }

  bool get isValidStudentEmailAddress => trim().endsWith(nustEmailDomain);
}
