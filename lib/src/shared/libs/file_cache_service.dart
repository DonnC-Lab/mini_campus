import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// cache manager, easily cache any file
class FileCacheService {
  static final _cacheManager = DefaultCacheManager();

  /// fname is used as key, used to [getFileCache]
  Future<File> addFileCache(
    String fname,
    Uint8List bytes,
    String ext, {
    Duration expireAfter = const Duration(days: 30),
  }) async =>
      await _cacheManager.putFile(
        fname,
        bytes,
        key: fname,
        eTag: fname,
        fileExtension: ext,
        maxAge: expireAfter,
      );

  Future<File?> getFileCache(String fname) async {
    // key == filename
    final res = await _cacheManager.getFileFromCache(fname);

    return res?.file;
  }
}
