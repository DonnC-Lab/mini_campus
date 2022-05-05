class FirebasePaths {
  static const String _parentMarketPath = 'campus_market';

  /// main root node for ads
  static const String ads = '$_parentMarketPath/ads';

  static String studentLikedAdsRoot(String student) =>
      '$_parentMarketPath/likes/$student';

  /// main root node for ads liked by student
  static String studentLikedAds(String student, String adId) =>
      '${studentLikedAdsRoot(student)}/$adId';

  /// main root node for ads
  static String ad(String adId) => '$_parentMarketPath/ads/$adId';

  // --------------------- storage paths ---------------------
  static String adsGallery = 'ads-gallery';

  /// store user related ad files
  static String adStorageUserFolder(String id) => '$adsGallery/$id';
}
