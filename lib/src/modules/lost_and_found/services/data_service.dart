import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:mini_campus/src/shared/libs/index.dart';

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
  static final DetaRepository _detaRepository =
      DetaRepository(baseName: DetaBases.lostFound);

  Future addLostFound(LostFoundItem lostFoundItem) async {
    try {
      final res = await _detaRepository.addBaseData(lostFoundItem.toJson());

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
    try {
      final res = await _detaRepository.queryBase(
        query: DetaQuery('type')
            .equalTo(filter.type)
            .and('month')
            .equalTo(filter.month)
            .query,
      );

      List items = res;

      return items.map((e) => LostFoundItem.fromJson(e)).toList();
    }

    // er
    catch (e) {
      debugLogger(e, error: e);

      return const [];
    }
  }
}
