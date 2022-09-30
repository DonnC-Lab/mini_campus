import 'package:localregex/localregex.dart';
import 'package:phone_number/phone_number.dart';

/// RegexExtensionForStrings
///
/// Extension methods for the [String] class.
extension RegexExtensionForStrings on String {
  /// clean
  ///
  /// Removes all non-numeric characters from the string.
  String get clean => replaceAll(RegExp(r'\s+'), '');
}

String countryCodeFormat(String number) {
  if (number.length < 9) {
    throw Exception('Mobile number length cannot be less than 9');
  }
  final mobileNumber = number.substring(number.length - 9);
  return '263${mobileNumber.clean}';
}

/// RegexExtensionForNumbers
///
/// Extension methods for the [String] class.
extension RegexExtensionForNumbers on String {
  /// format number
  String? formatNumber() {
    String? number;
    if (LocalRegex.isZimMobile(this) || LocalRegex.isZimVoip(this)) {
      number = countryCodeFormat(this);
    }

    return number;
  }
}

/// helper to try validate contact passed and return
/// formatted international number
///
/// return formatted number or null if invalid
Future<String?> contactHelper(String? number) async {
  if (number != null) {
    if (number.isNotEmpty) {
      // try to see if number is a valid zim number first

      if (!LocalRegex.isZimMobile(number)) {
        // check international format
        try {
          final phoneNumber = await PhoneNumberUtil().parse(number);
          return phoneNumber.nationalNumber;
        } catch (e) {
          // not a valid #
          return null;
        }
      } else {
        // format the zim number

        return number.formatNumber();
      }
    }

    return null;
  }

  return number;
}

/// create a whatsapp link for seller
String? whatsappLink(String? number, String body) {
  if (number == null) {
    return number;
  }

  final _num = number.replaceAll('+', '').trim();

  final _encodedBody = Uri.encodeComponent(body);
  final _url = 'https://wa.me/$_num?text=$_encodedBody';
  return _url;
}
