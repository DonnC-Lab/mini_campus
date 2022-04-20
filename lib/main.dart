import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'debug_settings.dart';
import 'fb_emulator.dart';
import 'firebase_options.dart';
import 'src/app.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  debugLogger('Handling a background message: ${message.messageId}');

  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    // 'resource://drawable/res_app_icon',
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
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
        channelGroupkey: 'basic_channel_group',
        channelGroupName: 'MiniCampus group',
      )
    ],
    debug: USE_EMULATOR,
  );

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications(
          channelKey: 'mini_campus_channel');
    }
  });

  HttpOverrides.global = MyHttpOverrides();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
