import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:mini_campus/src/shared/libs/index.dart';

import '../constants/fb_paths.dart';
import '../models/ad_service.dart';

final marketDbProvider = Provider((ref) => MarketRtdbService(read: ref.read));

final studentLikeStatusStreamProvider =
    StreamProviderFamily<DatabaseEvent, AdService>((ref, ad) {
  final api = ref.read(marketDbProvider);

  return api.studentAdStatus(ad);
});

/// Campus Market Fb RTDB service
class MarketRtdbService {
  final Reader read;

  MarketRtdbService({required this.read});

  final _service = FirebaseRtdbService.instance;

  Future<bool?> addAdService(AdService adService) async {
    final appUser = read(fbAppUserProvider);

    try {
      await _service.setData(
        path: FirebasePaths.ads,
        data: adService.copyWith(student: appUser!.uid).toJson(),
      );

      return true;
    } catch (e) {
      debugLogger(e, name: 'addAdService');
      return null;
    }
  }

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

  Future<bool?> deleteAdService(AdService adService) async {
    try {
      await _service.deleteData(path: FirebasePaths.ad(adService.id!));

      return true;
    } catch (e) {
      debugLogger(e, name: 'deleteAdService');
      return null;
    }
  }

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

  Future<bool?> likeAdService(AdService adService) async {
    final appUser = read(fbAppUserProvider);

    try {
      await _service.addData(
        path: FirebasePaths.studentLikedAds(appUser!.uid, adService.id!),
        data: {
          "ad": adService.id,
          "name": adService.name,
        },
      );

      return true;
    } catch (e) {
      debugLogger(e, name: 'likeAdService');
      return null;
    }
  }

  Stream<DatabaseEvent> studentAdStatus(AdService adService) {
    final appUser = read(fbAppUserProvider);

    DatabaseReference statusRef = FirebaseDatabase.instance
        .ref(FirebasePaths.studentLikedAds(appUser!.uid, adService.id!));

    return statusRef.onValue;
  }

  Future<bool?> dislikeAdService(AdService adService) async {
    final appUser = read(fbAppUserProvider);

    try {
      await _service.deleteData(
          path: FirebasePaths.studentLikedAds(appUser!.uid, adService.id!));

      return true;
    } catch (e) {
      debugLogger(e, name: 'dislikeAdService');
      return null;
    }
  }
}
