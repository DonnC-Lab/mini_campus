/// categories supported by module
/// used as tabbar items
/// and selectable category when adding Ad
enum MarketCategory {
  /// no category
  none,

  /// all available categories
  all,

  /// clothing
  clothing,

  /// food items
  grocery,

  /// eletricals e.g phones
  electronics,

  /// accessories
  accessory,

  /// beverages can also include, liquor
  beverages,

  /// school items, e.g books, drawing items
  stationery,

  /// copy, printing, logo design
  printingDesign,

  /// used to show Ads that student is requesting
  requests,

  /// show a service type of ad
  /// e.g barber, hairdressing
  services,

  /// any other, which is not yet defined
  other,
}

/// supported Ad type
enum AdType {
  /// no type
  none,

  /// general ad
  ad,

  /// a service type of an ad
  service,
}
