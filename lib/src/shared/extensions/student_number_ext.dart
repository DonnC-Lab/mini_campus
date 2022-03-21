// get student number from passed email

import 'package:mini_campus/src/shared/constants/index.dart';

class StudentNumber {
  final String stringYear;
  final int intYear;
  final String studentNumber;

  StudentNumber(this.stringYear, this.intYear, this.studentNumber);

  StudentNumber copyWith({
    String? stringYear,
    int? intYear,
    String? studentNumber,
  }) {
    return StudentNumber(
      stringYear ?? this.stringYear,
      intYear ?? this.intYear,
      studentNumber ?? this.studentNumber,
    );
  }
}

extension GetStudentNumberFromEmail on String {
  StudentNumber get studentNumber {
    final studentNum = replaceAll(nustEmailDomain, '').trim();

    return _computeSn(studentNum);
  }
}

StudentNumber _computeSn(String studentNumber) {
  StudentNumber sn = StudentNumber('undefined', -1, studentNumber);

  try {
    String _year = studentNumber.substring(2, 4).trim();
    int _enrollment = int.parse('20$_year');

    // minus
    final today = DateTime.now().year;

    int diff = today - _enrollment;

    String _studentY = '';

    switch (diff) {
      case 0:
        _studentY = '1st Year';
        break;

      case 1:
        _studentY = '1st Year';
        break;

      case 2:
        _studentY = '2nd Year';
        break;

      case 3:
        _studentY = '3rd Year';
        break;

      case 4:
        _studentY = '4th Year';
        break;

      case 5:
        _studentY = '5th Year';
        break;

      case 6:
        _studentY = '6th Year';
        break;

      case 7:
        _studentY = '7th Year';
        break;

      case 8:
        _studentY = '8th Year';
        break;

      case 9:
        _studentY = '9th Year';
        break;

      default:
        _studentY = 'undefined';
    }

    sn.copyWith(stringYear: _studentY, intYear: diff);
  }

  // error
  catch (e) {
    // pass
  }

  return sn;
}
