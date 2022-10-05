// helper extensions
import 'package:campus_market/src/constants/market_enums.dart';

/// convert enum to string
/// FIXME: use default built-in enum method instead
extension MarketCategoryToString on MarketCategory {
  String get stringValue => toString().split('.').last;
}

/// convert passed string
/// to its equivalent enum
extension StringToMarketCategory on String {
  ///
  MarketCategory get category {
    switch (toLowerCase()) {
      case 'all':
        return MarketCategory.all;

      case 'clothing':
        return MarketCategory.clothing;

      case 'grocery':
        return MarketCategory.grocery;

      case 'accessory':
        return MarketCategory.accessory;

      case 'electronics':
        return MarketCategory.electronics;

      case 'beverages':
        return MarketCategory.beverages;

      case 'stationery':
        return MarketCategory.stationery;

      case 'printingdesign':
        return MarketCategory.printingDesign;

      case 'requests':
        return MarketCategory.requests;

      case 'services':
        return MarketCategory.services;

      case 'other':
        return MarketCategory.other;

      default:
        return MarketCategory.none;
    }
  }
}
