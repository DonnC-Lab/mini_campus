library fbmessaging_service;

import 'dart:developer' show log;

import 'package:firebase_messaging/firebase_messaging.dart';

/// {@template fb_message}
/// Firebase Message service class
///
/// - get user token
///
/// - subscribe to topics
///
/// - send & broadcast notifications
/// {@endtemplate}
class FbMessagingService {
  FbMessagingService._();

  /// {@macro fb_message}
  static final instance = FbMessagingService._();

  static final _instance = FirebaseMessaging.instance;

  /// get currently signed in student device token
  Future<String?> getUserToken() async => _instance.getToken();

  /// subscribe current student to all given topics
  Future<void> subscribeTopics(List<String> topics) async {
    try {
      final _subFutures = topics.map(_instance.subscribeToTopic).toList();
      await Future.wait(_subFutures);
    } catch (e) {
      log('[subscribeTopics] failed to subscribe');
    }
  }

  /// send notification to device [token]
  ///
  /// logic should be server side
  Future<void> sendNotification(
    Map<String, dynamic> notificationPayload,
    String token,
  ) async {
    // todo: implement on the server side
    throw UnimplementedError();
  }

  /// broadcast notifications to subscribed [topics]
  ///
  /// logic should be server side
  Future<void> broadcastMessage(
    Map<String, dynamic> notificationPayload,
    List<String> topics,
  ) async {
    // todo: implement on the server side
    throw UnimplementedError();
  }

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
