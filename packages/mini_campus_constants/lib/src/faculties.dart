// ignore_for_file: public_member_api_docs

import 'package:mini_campus_constants/src/mini_campus_constants.dart';

class Faculty {
  Faculty({required this.name, this.uni = Uni.nust});

  final String name;
  final Uni uni;

  List<Faculty> get uniFaculties {
    switch (uni) {
      case Uni.none:
        return const [];
      case Uni.nust:
        return NustFaculty.faculties;
    }
  }
}

// add other uni faculties
class NustFaculty extends Faculty {
  NustFaculty({
    required super.name,
  }) : super();

  static List<NustFaculty> get faculties => [
        NustFaculty(name: 'Engineering'),
        NustFaculty(name: 'Applied Science'),
        NustFaculty(name: 'Built Environment'),
        NustFaculty(name: 'Commerce'),
        NustFaculty(name: 'Comm & Information Scie'),
        NustFaculty(name: 'Medicine'),
        NustFaculty(name: 'Science & Tech Education'),
      ];
}
