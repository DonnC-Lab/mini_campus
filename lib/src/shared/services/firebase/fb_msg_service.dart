import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/libs/index.dart';
import 'package:mini_campus/src/shared/providers/shared_providers.dart';

import '../index.dart';

final fbMsgProvider = Provider((_) => FbMsgService(_.read));

class FbMsgService {
  static final _service = FbMessagingService.instance;

  final Reader read;

  FbMsgService(this.read);

  Future<String?> getToken() async {
    final sharedPref = read(sharedPreferencesServiceProvider);

    try {
      String cachedToken = sharedPref.userCachedToken();

      var t = await _service.getUserToken();

      if (t == cachedToken) {
        return cachedToken;
      }

      // set new
      await sharedPref.setUserFcmToken(t ?? '');

      return t;
    } catch (e) {
      return null;
    }
  }

  Future<void> subscribe() async {
    final sharedPref = read(sharedPreferencesServiceProvider);

    try {
      if (!sharedPref.isUserSubToTopics()) {
        final student = read(studentProvider);

        await _service.subscribeTopics(student!);
      }
    } catch (e) {
      debugLogger(e, name: 'FbMsgService-subscribe');
      return;
    }
  }
}
