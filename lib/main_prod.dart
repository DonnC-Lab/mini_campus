import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus_core/mini_campus_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase/prod/firebase_options.dart';
import 'src/app.dart';
import 'src/http_override.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  debugLogger('Handling a background message: ${message.messageId}');

  await AwesomeNotifications().createNotificationFromJsonData(message.data);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Setup flavor config here
  FlavorConfig(
    variables: {
      "appTitle": "MiniCampus",
      "detaBaseUrl": McAppUrls.serverDetaBaseUrl,
    },
  );

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'mini_campus_channel',
        channelName: 'MiniCampus',
        channelDescription: 'Notification channel for MiniCampus',
        enableVibration: true,
        enableLights: true,
        playSound: true,
        importance: NotificationImportance.High,
        channelShowBadge: true,
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupkey: 'basic_channel_group',
        channelGroupName: 'MiniCampus group',
      )
    ],
  );

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications(
          channelKey: 'mini_campus_channel');
    }
  });

  HttpOverrides.global = CustomHttpOverride();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final sharedPreferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesServiceProvider
            .overrideWithValue(SharedPreferencesService(sharedPreferences))
      ],
      child: const MainAppEntry(),
    ),
  );
}
