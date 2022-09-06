library fbmessaging_service;

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class FbMessagingService {
  FbMessagingService._();
  static final instance = FbMessagingService._();

  static final _instance = FirebaseMessaging.instance;

  Future<String?> getUserToken() async => await _instance.getToken();

  Future<void> subscribeTopics(List<String> topics) async {
    try {
      final _subFutures =
          topics.map((topic) => _instance.subscribeToTopic(topic)).toList();
      await Future.wait(_subFutures);
    } catch (e) {
      log('[subscribeTopics] failed to subscribe');
    }
  }

  /// todo: perform on server
  Future sendNotification(Map notificationPayload, String token) async {}

  Future broadcastMessage(Map notificationPayload, List<String> topics) async {}

  // Map _getNotificationData(
  //     NotificationPayload notificationPayload, String sendTo,
  //     {bool isTopic = false}) {
  //   final _data = {
  //     "to": isTopic ? '/topics/$sendTo' : sendTo,
  //     "collapse_key": "type_a",
  //     "mutable_content": true,
  //     "content_available": true,
  //     "priority": "high",
  //     "data": {
  //       "click_action": notificationPayload.clickAction,
  //       "content": {
  //         "id": Random().nextInt(99999),
  //         "channelKey": "mini_campus_channel",
  //         "title": notificationPayload.title,
  //         "body": notificationPayload.body,
  //         "notificationLayout": "BigPicture",
  //         "bigPicture": notificationPayload.image,
  //         "displayOnForeground": true,
  //         "displayOnBackground": true,
  //         "showWhen": true,
  //         "summary": "MiniCampus notification",
  //         "hideLargeIconOnExpand": true,
  //         "autoCancel": true,
  //         "privacy": "Private",
  //         "payload": notificationPayload.payload,
  //       },
  //       "actionButtons": [
  //         {
  //           "key": notificationPayload.key,
  //           "label": notificationPayload.label,
  //           "autoCancel": true,
  //           "buttonType": "Default",
  //         }
  //       ],
  //     }
  //   };

  //   return _data;
  // }
}
