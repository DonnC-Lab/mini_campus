import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// clock timer notifier
class Clock extends StateNotifier<int?> {
  /// clock timer notifier
  Clock() : super(0) {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = elapsed++;
    });
  }

  /// duration elapsed
  int elapsed = 0;

  late final Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
