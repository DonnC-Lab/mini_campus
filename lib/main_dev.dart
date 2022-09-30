import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/fb_emulator.dart';
import 'package:mini_campus/firebase/dev/firebase_options.dart';
import 'package:mini_campus/src/app.dart';
import 'package:mini_campus/src/http_override.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:mini_campus_core/mini_campus_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// todo: toggle per your option
// ignore: constant_identifier_names
const bool USE_EMULATOR = false;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  debugLogger('Handling a background message: ${message.messageId}');

  await AwesomeNotifications().createNotificationFromJsonData(message.data);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Setup flavor config here
  FlavorConfig(
    name: 'DEV',
    location: BannerLocation.bottomEnd,
    variables: {
      'appTitle': '[Dev] MiniCampus',
      //"detaBaseUrl": '<test-url>',
      'detaBaseUrl': AppUrls.serverDetaBaseUrl,
      'validateStudentEmail': true,
      'byPassEmailVerification': true,
    },
  );

  await AwesomeNotifications().initialize(
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

  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications(
        channelKey: 'mini_campus_channel',
      );
    }
  });

  HttpOverrides.global = CustomHttpOverride();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final sharedPreferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (USE_EMULATOR) {
    await connectToFirebaseEmulator();
  }

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
