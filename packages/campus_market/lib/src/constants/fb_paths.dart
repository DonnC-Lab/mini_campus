/// collection paths to firebase
/// firestore
///
/// also contains, drive path to firebase
/// cloud storage
class FirebasePaths {
  static const String _kParentMarketPath = 'campus_market';

  /// main root node for ads
  static const String kAds = '$_kParentMarketPath/ads';

  /// liked ads path
  static String studentLikedAdsRoot(String student) =>
      '$_kParentMarketPath/likes/$student';

  /// main root node for ads liked by student
  static String studentLikedAds(String student, String adId) =>
      '${studentLikedAdsRoot(student)}/$adId';

  /// main root node for ads
  static String ad(String adId) => '$_kParentMarketPath/ads/$adId';

  // --------------------- storage paths ---------------------

  /// ads media path
  static const String kAdsGallery = 'ads-gallery';

  /// store user related ad files
  static String adStorageUserFolder(String id) => '$kAdsGallery/$id';
}
