import 'package:localregex/format_types.dart';
import 'package:localregex/localregex.dart';
import 'package:phone_number/phone_number.dart';

/// helper to try validate contact passed and return formatted international number
///
/// return formatted number or null if invalid
Future<String?> contactHelper(String? number) async {
  if (number != null) {
    if (number.isNotEmpty) {
      // try to see if number is a valid zim number first

      final _isZw = LocalRegex.isValidZimMobile(number);

      if (!_isZw) {
        // check international format
        try {
          PhoneNumber phoneNumber = await PhoneNumberUtil().parse(number);
          return phoneNumber.nationalNumber;
        } catch (e) {
          // not a valid #
          return null;
        }
      } else {
        // format the zim number
        return LocalRegex.formatNumber(value: number, type: FormatTypes.common);
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
