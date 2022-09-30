import 'package:mini_campus_constants/mini_campus_constants.dart';

/// validate student email(s) here
extension ValidateStudentEmail on String {
  /// check if current student email is valid based on student uni
  bool get isValidStudentEmailAddress => UniEmailDomain.uniDomains
      .any((domainUni) => trim().endsWith(domainUni.domain));
}
