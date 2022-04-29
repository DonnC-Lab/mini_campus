library fbmessaging_service;

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mini_campus/src/shared/index.dart';

// TODO: perform these actions on server
class FbMessagingService {
  FbMessagingService._();
  static final instance = FbMessagingService._();

  static final _instance = FirebaseMessaging.instance;

  Future<String?> getUserToken() async {
    return await _instance.getToken();
  }

  Future<void> subscribeTopics(Student student) async {
    final topics = NotificationTopic(student: student).topics;

    for (var topic in topics) {
      await _instance.subscribeToTopic(topic);
    }
  }

  /// send a notification to individual user [Student]
  Future sendNotification(
      NotificationPayload notificationPayload, String token) async {
    final _data = _getNotificationData(notificationPayload, token);

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=$notifyMsgApiKey',
    };

    final BaseOptions options = BaseOptions(headers: headers);

    try {
      await Dio(options).post(fcmMsgBaseUrl, data: _data);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future broadcastMessage(
      NotificationPayload notificationPayload, List<String> topics) async {
    List<Future> _futures = [];

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=$notifyMsgApiKey',
    };

    final BaseOptions options = BaseOptions(headers: headers);

    for (var topic in topics) {
      final _data =
          _getNotificationData(notificationPayload, topic, isTopic: true);

      _futures.add(Dio(options).post(fcmMsgBaseUrl, data: _data));
    }

    try {
      await Future.wait(_futures);

      return true;
    } catch (e) {
      return false;
    }
  }

  Map _getNotificationData(
      NotificationPayload notificationPayload, String sendTo,
      {bool isTopic = false}) {
    final _data = {
      "to": isTopic ? '/topics/$sendTo' : sendTo,
      "collapse_key": "type_a",
      "mutable_content": true,
      "content_available": true,
      "priority": "high",
      "data": {
        "click_action": notificationPayload.clickAction,
        "content": {
          "id": Random().nextInt(99999),
          "channelKey": "mini_campus_channel",
          "title": notificationPayload.title,
          "body": notificationPayload.body,
          "notificationLayout": "BigPicture",
          "bigPicture": notificationPayload.image,
          "displayOnForeground": true,
          "displayOnBackground": true,
          "showWhen": true,
          "summary": "MiniCampus notification",
          "hideLargeIconOnExpand": true,
          "autoCancel": true,
          "privacy": "Private",
          "payload": notificationPayload.payload,
        },
        "actionButtons": [
          {
            "key": notificationPayload.key,
            "label": notificationPayload.label,
            "autoCancel": true,
            "buttonType": "Default",
          }
        ],
      }
    };

    return _data;
  }
}
