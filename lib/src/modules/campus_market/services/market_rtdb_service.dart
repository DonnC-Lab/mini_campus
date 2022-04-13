import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:mini_campus/src/shared/libs/index.dart';

import '../constants/fb_paths.dart';
import '../models/ad_service.dart';

final marketDbProvider = Provider((ref) => MarketRtdbService(read: ref.read));

/// Campus Market Fb RTDB service
class MarketRtdbService {
  final Reader read;

  MarketRtdbService({
    required this.read,
  });

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
}
