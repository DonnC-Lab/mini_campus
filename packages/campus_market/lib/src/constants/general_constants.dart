import 'package:campus_market/src/constants/market_enums.dart';

/// supported ad types
final List<AdType> adTypes = [AdType.ad, AdType.service];

/// tabbar categories
final List<MarketCategory> marketCategories = [
  MarketCategory.all,
  MarketCategory.clothing,
  MarketCategory.grocery,
  MarketCategory.electronics,
  MarketCategory.accessory,
  MarketCategory.beverages,
  MarketCategory.stationery,
  MarketCategory.printingDesign,
  MarketCategory.other,
  MarketCategory.services,
  MarketCategory.requests,
];

/// selectable market categories
///
/// used when adding an Ad category
final List<MarketCategory> selectableMarketCategories = [
  MarketCategory.clothing,
  MarketCategory.grocery,
  MarketCategory.accessory,
  MarketCategory.electronics,
  MarketCategory.beverages,
  MarketCategory.stationery,
  MarketCategory.printingDesign,
  MarketCategory.other,
  MarketCategory.requests,
];

// ! disturbing tabbar items by retaining state with filtered data
List<MarketCategory> _selectableMarketCategories() {
  final _copy = marketCategories
    ..remove(MarketCategory.all)
    ..remove(MarketCategory.services);

  return _copy;
}
