class FirebasePaths {
  static const String _parentMarketPath = 'campus_market';

  /// main root node for ads
  static const String ads = '$_parentMarketPath/ads';

  /// main root node for ads
  static String ad(String adId) => '$_parentMarketPath/ads/$adId';

  // --------------------- storage paths ---------------------
  static String adsGallery = 'ads-gallery';

  /// path to Ads gallery
  ///
  /// stored per Ad id folder
  static String adStorage(String id, String fname) => '$adsGallery/$id/$fname';

  /// store user related ad files
  static String adStorageUserFolder(String id) => '$adsGallery/$id';
}
