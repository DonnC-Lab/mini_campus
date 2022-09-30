import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus_core/mini_campus_core.dart';
import 'package:mini_campus_core/src/services/firebase/student_service.dart';
import 'package:mini_campus_services/mini_campus_services.dart';

/// [CMessageService] provider
final cloudMessagingProvider = Provider((_) => CMessageService(_.read));

/// a firebase Cloud Messaging service
class CMessageService {
  /// a firebase Cloud Messaging service
  CMessageService(this.read);
  static final _service = FbMessagingService.instance;

  /// riverpod reader to access other providers
  final Reader read;

  /// get & set token if not present
  /// and subscribe current student to topics
  Future<void> tokenSubscribe() async {
    final sharedPref = read(sharedPreferencesServiceProvider);

    try {
      final cachedToken = sharedPref.userCachedToken();

      if (cachedToken.isEmpty) {
        final t = await _service.getUserToken() ?? '';

        if (t == cachedToken) {
          return;
        }

        // add token
        await read(studentStoreProvider).addNotificationToken(t);

        // set new
        await sharedPref.setUserFcmToken(t);

        // subscribe to topics also
        await _service.subscribeTopics(
          NotificationTopic(
            student: read(studentProvider)!,
            university: read(studentUniProvider),
          ).topics,
        );
      }
    } catch (e) {
      debugLogger(e, error: e, name: 'getToken');
    }
  }
}
