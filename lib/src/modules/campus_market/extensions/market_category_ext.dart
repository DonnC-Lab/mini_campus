// helper extensions
import '../constants/market_enums.dart';

extension MarketCategoryToString on MarketCategory {
  String get stringValue => toString().split('.').last;
}

extension StringToMarketCategory on String {
  MarketCategory get category {
    switch (toLowerCase()) {
      case 'all':
        return MarketCategory.All;

      case 'clothing':
        return MarketCategory.Clothing;

      case 'grocery':
        return MarketCategory.Grocery;

      case 'electronics':
        return MarketCategory.Electronics;

      case 'beverages':
        return MarketCategory.Beverages;

      case 'stationery':
        return MarketCategory.Stationery;

      case 'printingdesign':
        return MarketCategory.PrintingDesign;

      case 'requests':
        return MarketCategory.Requests;

      case 'services':
        return MarketCategory.Services;

      case 'other':
        return MarketCategory.Other;

      default:
        return MarketCategory.None;
    }
  }
}
