import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final clockProvider = StateNotifierProvider.autoDispose<Clock, int?>((ref) {
  return Clock();
});

final clockTimerProvider =
    StateNotifierProvider.autoDispose<ClockTimer, int?>((ref) {
  return ClockTimer();
});

class Clock extends StateNotifier<int?> {
  Clock() : super(0) {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = elapsed++;
    });
  }

  int elapsed = 0;

  late final Timer _timer;

  // 4. cancel the timer when finished
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class ClockTimer extends StateNotifier<int?> {
  // 1. initialize with current time
  ClockTimer() : super(0) {
    // 2. create a timer that fires every second
    _timer = Timer.periodic(const Duration(seconds: 7), (_) {
      // 3. update the state with the current time
      state = elapsed++;
    });
  }

  int elapsed = 0;

  late final Timer _timer;

  // 4. cancel the timer when finished
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
