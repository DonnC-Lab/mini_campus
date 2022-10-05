// helper extensions
import 'package:campus_market/src/constants/market_enums.dart';

/// convert enum to string value
/// FIXME: redundancy, enum now already have this by default
/// as enum.value.name
extension AdTypeToString on AdType {
  /// get enum string
  String get stringValue => toString().split('.').last;
}

/// convert passed string to its equivalent enum
/// todo: use enhanced enum instead
extension StringToAdType on String {
  /// convert to enum
  AdType get adType {
    switch (toLowerCase()) {
      case 'service':
        return AdType.service;

      default:
        return AdType.ad;
    }
  }
}
