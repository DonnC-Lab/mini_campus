import 'package:campus_market/src/constants/fb_paths.dart';
import 'package:campus_market/src/models/ad_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus_core/mini_campus_core.dart';
import 'package:mini_campus_services/mini_campus_services.dart';

/// [MarketRtdbService] provider, DI
final marketDbProvider = Provider((ref) => MarketRtdbService(ref: ref));

/// like status stream
/// stream provider
final studentLikeStatusStreamProvider =
    StreamProviderFamily<DatabaseEvent, AdService>((ref, ad) {
  final api = ref.read(marketDbProvider);

  return api.studentAdStatus(ad);
});

/// Campus Market service
///
/// interfaces with firebase RTDB service for all
/// campus market methods
class MarketRtdbService {
  ///
  MarketRtdbService({required this.ref});

  /// riverpod [Ref] like buildcontext, to access other providers
  final Ref ref;

  final _service = FirebaseRtdbService.instance;

  /// add student Ad or Service to database
  Future<bool?> addAdService(AdService adService) async {
    final appUser = ref.read(fbAppUserProvider);

    try {
      await _service.setData(
        path: FirebasePaths.kAds,
        data: adService.copyWith(student: appUser?.uid).toJson(),
      );

      return true;
    } catch (e) {
      debugLogger(e, name: 'addAdService');
      return null;
    }
  }

  /// update student Ad
  Future<bool?> updateAdService(AdService adService) async {
    try {
      await _service.updateData(
        path: FirebasePaths.ad(adService.id!),
        data: adService.toJson(),
      );

      return true;
    } catch (e) {
      debugLogger(e, name: 'updateAdService');
      return null;
    }
  }

  /// delete passed ad
  Future<bool?> deleteAdService(AdService adService) async {
    try {
      await _service.deleteData(path: FirebasePaths.ad(adService.id!));

      return true;
    } catch (e) {
      debugLogger(e, name: 'deleteAdService');
      return null;
    }
  }

  /// fetch single Ad based on Ad id given
  Future<AdService?> getSingleAdService(String adId) async {
    try {
      final snap = await _service.getData(path: FirebasePaths.ad(adId));

      if (!snap.exists) return null;

      return AdService.fromFbRtdb(snap);
    } catch (e) {
      debugLogger(e, name: 'getSingleAdService');
      return null;
    }
  }

  /// get all ads once [for search page]
  Future<List<AdService>> getAllAdService() async {
    try {
      final snap = await _service.getDataOnceOff(path: FirebasePaths.kAds);

      if (!snap.exists) return const [];

      return snap.children.map(AdService.fromFbRtdb).toList();
    } catch (e) {
      debugLogger(e, name: 'getAllAdService');
      return const [];
    }
  }

  /// add ad to student favorite
  Future<bool?> likeAdService(AdService adService) async {
    final appUser = ref.read(fbAppUserProvider);

    try {
      await _service.addData(
        path: FirebasePaths.studentLikedAds(
          appUser!.uid,
          adService.id!,
        ),
        data: {
          'ad': adService.id,
          'name': adService.name,
        },
      );

      return true;
    } catch (e) {
      debugLogger(e, name: 'likeAdService');
      return null;
    }
  }

  /// get status of ad
  Stream<DatabaseEvent> studentAdStatus(AdService adService) {
    final appUser = ref.read(fbAppUserProvider);

    final statusRef = FirebaseDatabase.instance.ref(
      FirebasePaths.studentLikedAds(appUser!.uid, adService.id!),
    );

    return statusRef.onValue;
  }

  /// unfavorite student ad
  Future<bool?> dislikeAdService(AdService adService) async {
    final appUser = ref.read(fbAppUserProvider);

    try {
      await _service.deleteData(
        path: FirebasePaths.studentLikedAds(
          appUser!.uid,
          adService.id!,
        ),
      );

      return true;
    } catch (e) {
      debugLogger(e, name: 'dislikeAdService');
      return null;
    }
  }
}
