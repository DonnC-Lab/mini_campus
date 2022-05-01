import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/modules/learning/data/models/resource/file_resource.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:mini_campus/src/shared/libs/index.dart';

final resRepProvider = Provider((_) => FileResourceRepository());

final resFilterProvider =
    AutoDisposeFutureProviderFamily<List<FileResource>, Map<String, dynamic>>(
        (ref, filter) {
  final api = ref.read(resRepProvider);

  return api.fetchFilteredResources(filter);
});

/// deta base repository
class FileResourceRepository {
  static final DetaRepository _detaRepository =
      DetaRepository(baseName: DetaBases.learnResource);

  Future addFileResource(FileResource fileResource) async {
    try {
      var year = fileResource.year;
      var fname = fileResource.resource.filename;

      var _key = '$year' '_' + fname;

      final res = await _detaRepository.addBaseData(
        fileResource.toJson(),
        key: _key,
      );

      debugLogger(res.toString());

      return res;
    }

    // er
    catch (e) {
      // a possible duplicate error
      debugLogger('err ' + e.toString());
    }
  }

  Future<List<FileResource>> fetchFilteredResources(
      Map<String, dynamic> filter) async {
    try {
      final res = await _detaRepository.queryBase(
          query: DetaQuery('dpt')
              .equalTo(filter['dptCode'])
              .and('part')
              .equalTo(filter['part'])
              .and('category')
              .equalTo(filter['category'])
              .query);

      List items = res;

      var i = items.map((e) => FileResource.fromJson(e)).toList();
      debugLogger(i.toString());
      return i;
    }

    // er
    catch (e) {
      debugLogger(e.toString());
    }
    return const [];
  }

  Future<List<FileResource>> getAllFileResources() async {
    try {
      final res = await _detaRepository.queryBase();

      List items = res;

      var i = items.map((e) => FileResource.fromJson(e)).toList();
      debugLogger(i.toString());
      return i;
    }

    // er
    catch (e) {
      debugLogger(e.toString());
    }
    return const [];
  }
}
