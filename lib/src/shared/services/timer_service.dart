import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final clockProvider =
    StateNotifierProvider.autoDispose<Clock, int?>((_) => Clock());

class Clock extends StateNotifier<int?> {
  Clock() : super(0) {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = elapsed++;
    });
  }

  int elapsed = 0;

  late final Timer _timer;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
