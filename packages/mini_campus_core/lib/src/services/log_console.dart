import 'dart:developer' show log;

import 'package:flutter/foundation.dart' show kReleaseMode;

/// only show logs in debug mode
void debugLogger(
  Object? data, {
  String name = '',
  int level = 0,
  Object? error,
  StackTrace? stackTrace,
}) {
  if (!kReleaseMode) {
    log(
      data.toString(),
      name: name,
      level: level,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
