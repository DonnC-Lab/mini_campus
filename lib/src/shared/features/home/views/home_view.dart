import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mini_campus/src/drawer_module_pages.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../../profile/views/detailed_profile_update.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late final FirebaseMessaging _messaging;

  int _currentModuleIndex = 0;

  Future<void> initializeFirebaseService() async {
    _messaging = FirebaseMessaging.instance;

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      announcement: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AwesomeNotifications().createNotificationFromJsonData(message.data);
    });
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? message = await _messaging.getInitialMessage();

    if (message != null) {
      AwesomeNotifications().createNotificationFromJsonData(message.data);
    }
  }

  Future<void> setupInteractedMessage() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AwesomeNotifications().createNotificationFromJsonData(message.data);
    });
  }

  // set current student to cache
  void _setStudentCache() async {
    final _sharedPref = ref.read(sharedPreferencesServiceProvider);

    await _sharedPref.setCurrentStudent(ref.read(studentProvider)!);
  }

  @override
  void initState() {
    super.initState();

    _setStudentCache();

    initializeFirebaseService();

    checkForInitialMessage();
    setupInteractedMessage();

    AwesomeNotifications().createdStream.listen((receivedNotification) {});

    AwesomeNotifications().displayedStream.listen((receivedNotification) {});

    AwesomeNotifications().dismissedStream.listen((receivedNotification) {});

    AwesomeNotifications().actionStream.listen((receivedNotification) {
      debugLogger(receivedNotification.toMap(),
          name: 'notification-action-stream');

      // ? use switch..case check received button key type
      if (receivedNotification.buttonKeyPressed == 'VIEW') {
        // * can take necessary custom payload info send here
        // final String? _name = receivedNotification.payload!['argName'];

        // * route to appropriate page or do something
        // routeTo(
        //   context,
        //   PageView(notificationMapPayload: receivedNotification.payload!),
        // );
      }

      // e
      else {
        // ? anything to do here
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider).value;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Mini Campus'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'about MiniCampus app',
              onPressed: () {
                // todo: go to about page
              },
              icon: const Icon(Entypo.info_with_circle),
            ),
          ],
        ),
        drawer: HomeDrawer(
          logo: themeMode == ThemeMode.light
              ? SvgPicture.asset('assets/images/logo.svg')
              : SvgPicture.asset('assets/images/logo_dm.svg'),
          onDrawerItemTap: (index) {
            setState(() {
              _currentModuleIndex = index;
            });
          },
          onCloseIconTap: () {
            _scaffoldKey.currentState?.openEndDrawer();
          },
          onProfileCardTap: () {
            setState(() {
              _currentModuleIndex = -1;
            });
          },
        ),
        body: _currentModuleIndex == -1
            ? const DetailedProfileView(showAppbar: false)
            : drawerModulePages[_currentModuleIndex].page,
      ),
    );
  }
}
