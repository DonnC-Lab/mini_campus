// helper extensions
import '../constants/market_enums.dart';

extension AdTypeToString on AdType {
  String get stringValue => toString().split('.').last;
}

extension StringToAdType on String {
  AdType get adType {
    switch (toLowerCase()) {
      case 'service':
        return AdType.Service;

      default:
        return AdType.Ad;
    }
  }
}
