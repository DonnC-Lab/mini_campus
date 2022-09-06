import 'package:mini_campus_constants/src/enums.dart';

/// all available university email domains
class UniEmailDomain {
  /// all available university email domains
  UniEmailDomain(this.domain, {this.university = Uni.nust});

  /// uni domain
  final String domain;

  /// university
  final Uni university;

  /// get all available uni domains
  static List<UniEmailDomain> get uniDomains => [
        UniEmailDomain('@students.nust.ac.zw'),
      ];
}
