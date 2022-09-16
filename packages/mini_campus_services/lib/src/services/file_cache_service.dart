import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart'
    show DefaultCacheManager;

/// cache manager, easily cache any file
class FileCacheService {
  static final _cacheManager = DefaultCacheManager();

  /// filename is used as key, used to [get]
  Future<File> add(
    String filename,
    Uint8List bytes,
    String ext, {
    Duration expireAfter = const Duration(days: 30),
  }) async =>
      _cacheManager.putFile(
        filename,
        bytes,
        key: filename,
        eTag: filename,
        fileExtension: ext,
        maxAge: expireAfter,
      );

  /// get cached file
  ///
  /// key == filename used in [add]
  Future<File?> get(String filename) async {
    final res = await _cacheManager.getFileFromCache(filename);

    return res?.file;
  }
}
