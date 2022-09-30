import 'package:mini_campus_constants/mini_campus_constants.dart';

/// get student number from passed email
class StudentNumber {
  /// get student number from passed email
  StudentNumber({
    this.stringYear = '',
    this.intYear = 0,
    this.studentNumber = '',
  });

  /// [String] representation of student year
  final String stringYear;

  /// [int] representation of student year
  final int intYear;

  /// uni student number from student uni email
  final String studentNumber;

  /// get student number from passed email
  StudentNumber copyWith({
    String? stringYear,
    int? intYear,
    String? studentNumber,
  }) {
    return StudentNumber(
      stringYear: stringYear ?? this.stringYear,
      intYear: intYear ?? this.intYear,
      studentNumber: studentNumber ?? this.studentNumber,
    );
  }

  @override
  String toString() =>
      'StudentNumber(stringYear: $stringYear, intYear: $intYear,'
      ' studentNumber: $studentNumber)';
}

/// autocompute student number, part and enrollment year
StudentNumber? getStudentNumberFromEmail(
  String studentEmail,
  UniEmailDomain uniDomain,
) {
  // full uni student number
  String? studentNumber;

  // student auto computed enrollment year e.g 2019
  int? _enrollmentYear;

  // different logic tricks to auto get student number
  // and enrollment year from student email
  switch (uniDomain.university) {
    case Uni.nust:
      studentNumber = studentEmail.replaceAll(uniDomain.domain, '').trim();
      final _year = studentNumber.substring(2, 4).trim();
      _enrollmentYear = int.tryParse('20$_year');
      break;

    // other supported unis
    default:
  }

  if (studentNumber == null || _enrollmentYear == null) {
    return null;
  }

  var sn = StudentNumber(studentNumber: studentNumber);

  try {
    final diff = DateTime.now().year - _enrollmentYear;

    var _studentY = 'undefined';

    if (diff <= 1) {
      _studentY = 'Part 1';
    } else {
      _studentY = 'Part $diff';
    }

    sn = sn.copyWith(stringYear: _studentY.toLowerCase(), intYear: diff);
  }

  // error
  catch (e) {
    // pass
  }

  return sn;
}
