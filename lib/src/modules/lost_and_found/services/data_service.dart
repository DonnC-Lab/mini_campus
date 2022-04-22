import 'package:deta/deta.dart' show Deta, DetaQuery;
import 'package:dio/dio.dart';
import 'package:dio_client_deta_api/dio_client_deta_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../data/models/lost_found_filter.dart';
import '../data/models/lost_found_item.dart';

final lostFoundDataProvider = Provider((_) => DataService());

final lfFilterProvider =
    AutoDisposeFutureProviderFamily<List<LostFoundItem>?, LostFoundFilter>(
        (ref, filter) {
  final api = ref.read(lostFoundDataProvider);

  return api.getAllItemsByMonthType(filter);
});

/// deta base, lost-found repository
class DataService {
  static final _detaDioClient = DioClientDetaApi(dio: Dio());

  Future addLostFound(LostFoundItem lostFoundItem) async {
    final _deta = Deta(projectKey: donDetaProjectKey, client: _detaDioClient);
    final _lostFoundBase = _deta.base(DetaBases.lostFound);

    try {
      final res = await _lostFoundBase.insert(lostFoundItem.toJson());

      debugLogger(res, name: 'addLostFound');

      return res;
    }

    // er
    catch (e) {
      debugLogger(e, error: e, name: 'addLostFound');
    }
  }

  Future<List<LostFoundItem>?> getAllItemsByMonthType(
      LostFoundFilter filter) async {
    final _deta = Deta(projectKey: donDetaProjectKey, client: _detaDioClient);
    final _lostFoundBase = _deta.base(DetaBases.lostFound);

    try {
      final res = await _lostFoundBase.fetch(
        query: [
          DetaQuery('type')
              .equalTo(filter.type)
              .and('month')
              .equalTo(filter.month),
        ],
      );

      List items = res['items'];

      return items.map((e) => LostFoundItem.fromJson(e)).toList();
    }

    // er
    catch (e) {
      debugLogger(e, error: e);

      return const [];
    }
  }
}
