import 'market_enums.dart';

/// ad type
final List<AdType> adTypes = [AdType.Ad, AdType.Service];

/// tabbar categories
final List<MarketCategory> marketCategories = [
  MarketCategory.All,
  MarketCategory.Clothing,
  MarketCategory.Grocery,
  MarketCategory.Electronics,
  MarketCategory.Beverages,
  MarketCategory.Stationery,
  MarketCategory.PrintingDesign,
  MarketCategory.Other,
  MarketCategory.Services,
  MarketCategory.Requests,
];

/// used when adding an Ad
final List<MarketCategory> selectableMarketCategories = [
  MarketCategory.Clothing,
  MarketCategory.Grocery,
  MarketCategory.Electronics,
  MarketCategory.Beverages,
  MarketCategory.Stationery,
  MarketCategory.PrintingDesign,
  MarketCategory.Other,
  MarketCategory.Requests,
];

// fixme disturbing tabbar items by retaining state with filtered data
List<MarketCategory> _selectableMarketCategories() {
  var _copy = marketCategories;

  _copy.remove(MarketCategory.All);

  _copy.remove(MarketCategory.Services);

  return _copy;
}
