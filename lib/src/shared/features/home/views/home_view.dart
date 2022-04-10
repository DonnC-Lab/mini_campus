import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mini_campus/src/modules/learning/views/learning_view.dart';
import 'package:mini_campus/src/modules/lost_and_found/views/lf_view.dart';
import 'package:mini_campus/src/shared/features/admin/pages/home.dart';
import 'package:mini_campus/src/shared/index.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late final FirebaseMessaging _messaging;

  int _currentModuleIndex = 0;

  final List<DrawerPage> _drawerPages = [
    DrawerPage(
      drawerItem: const DrawerItem(icon: AntDesign.isv, name: 'Campus Market'),
      page: const Center(child: Text('Campus Market')),
    ),
    DrawerPage(
      drawerItem:
          const DrawerItem(icon: Icons.cast_for_education, name: 'Learning'),
      page: const LearningHomeView(),
    ),
    DrawerPage(
      drawerItem: const DrawerItem(icon: Entypo.flag, name: 'Lost & Found'),
      page: const LostFoundView(),
    ),
    DrawerPage(
      drawerItem: const DrawerItem(icon: Entypo.hand, name: 'Report'),
      page: const Center(child: Text('Report')),
    ),
    // ? TODO remove from production
    DrawerPage(
      drawerItem: const DrawerItem(icon: Entypo.shield, name: 'Admin'),
      page: const AdminHomeView(),
    ),
  ];

  Future<void> initializeFirebaseService() async {
    _messaging = FirebaseMessaging.instance;

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      // print('Message data: ${message.data}');

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
      print('Got a message whilst in the foreground opened app!');
      // print('Message data: ${message.data}');

      AwesomeNotifications().createNotificationFromJsonData(message.data);
    });
  }

  @override
  void initState() {
    super.initState();

    initializeFirebaseService();
    checkForInitialMessage();
    setupInteractedMessage();

    AwesomeNotifications().createdStream.listen((receivedNotification) {
      // String? createdSourceText =
      //     AssertUtils.toSimpleEnumString(receivedNotification.createdSource);
      // print('=== createdStream ===');
      // print(createdSourceText);
      // nothing happens when created
    });

    AwesomeNotifications().displayedStream.listen((receivedNotification) {
      // String? createdSourceText = AssertUtils.toSimpleEnumString(
      //     receivedNotification.displayedLifeCycle);
      // print('=== displayedStream ===');
      // print(createdSourceText);
      // nothing happens when displayed
    });

    AwesomeNotifications().dismissedStream.listen((receivedNotification) {
      // nothing happens when dismissed
    });

    AwesomeNotifications().actionStream.listen((receivedNotification) {
      // print('=== actionStream ===');
      // print(receivedNotification.toMap());
      // perform action here when button is pressed
      if (receivedNotification.buttonKeyPressed == 'VIEW') {
        // goto profile page
        // take interested buyer id from payload
        // final String? _uid = receivedNotification.payload!['buyerId'];
        // final String? _name = receivedNotification.payload!['buyerName'];

        // routeTo(
        //   context,
        //   StudentProfileView(interestedBuyerId: _uid!),
        // );
      }

      // e
      else {
        try {
          // goto profile page
          // take interested buyer id from payload
          // final String? _uid = receivedNotification.payload!['buyerId'];
          // final String? _name = receivedNotification.payload!['buyerName'];

          // routeTo(
          //   context,
          //   StudentProfileView(interestedBuyerId: _uid!),
          // );
        } catch (e) {}
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
          actions: const [
            IconButton(
              tooltip: 'about MiniCampus app',
              onPressed: null,
              icon: Icon(Entypo.info_with_circle),
            ),
          ],
        ),
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          _scaffoldKey.currentState?.openEndDrawer();
                        },
                        icon: const Icon(Icons.cancel_outlined),
                      ),
                      themeMode == ThemeMode.light
                          ? SvgPicture.asset('assets/images/logo.svg')
                          : SvgPicture.asset('assets/images/logo_dm.svg'),
                    ],
                  ),
                ),
                const Divider(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (_, index) => GestureDetector(
                        onTap: () {
                          // ref.read(currentModuleIndexProvider) = index;
                          setState(() {
                            _currentModuleIndex = index;
                          });
                          Navigator.pop(context);
                        },
                        child: _drawerPages[index].drawerItem),
                    itemCount: _drawerPages.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                  ),
                ),
                const SizedBox(height: 30),
                const DrawerMiniProfileCard(),
                const Divider(height: 30),
                //const DrawerHelpStarted(),
                const DrawerThemeSwitcher(),
              ],
            ),
          ),
        ),
        body: _drawerPages[_currentModuleIndex].page,
        //body: const DetaView(),
      ),
    );
  }
}

final loaderProvider = StateProvider((_) => false);

class DetaView extends ConsumerWidget {
  const DetaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(detaStoreRepProvider);
    final deta = ref.watch(detaStorageRepProvider);
    final isLoading = ref.watch(loaderProvider);

    return Column(
      children: [
        Expanded(
          child: deta.when(
            data: (data) {
              log(data.toString());

              var fnames = data['names'] as List;

              return RefreshIndicator(
                onRefresh: () async {
                  ref.refresh(detaStorageRepProvider);
                },
                child: ListView.builder(
                  itemCount: fnames.length,
                  itemBuilder: (_, x) {
                    return ListTile(
                      leading: SizedBox(
                        height: 80,
                        width: 50,
                        child: ref
                            .read(detaFileDownloaderProvider(fnames[x]))
                            .when(
                              data: (data) {
                                return CircleAvatar(
                                    backgroundImage: MemoryImage(data));
                              },
                              error: (error, st) {
                                return Text(error.toString());
                              },
                              loading: () => const Center(
                                  child: CircularProgressIndicator()),
                            ),
                      ),
                      title: Text(fnames[x]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await repo.delete([fnames[x]]);
                          Fluttertoast.showToast(
                              msg: 'file ${fnames[x]} deleted successfully');
                        },
                      ),
                    );
                  },
                ),
              );
            },
            error: (error, st) {
              return Text(error.toString());
            },
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () async {
                    var fp = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );

                    var bytes = await File(fp!.files.first.path!).readAsBytes();

                    ref.read(loaderProvider.notifier).state = true;

                    await repo.upload(
                      fp.files.first.path!,
                      bytes,
                      filename: fp.files.first.name,
                    );

                    Fluttertoast.showToast(msg: 'file uploaded');
                    ref.read(loaderProvider.notifier).state = false;

                    // var img = await ImagePicker()
                    //     .pickImage(source: ImageSource.gallery);

                    // if (img != null) {
                    //   ref.read(loaderProvider.notifier).state = true;

                    //   //final btyes = file.readAsBytesSync();
                    //   final fileBytes = await img.readAsBytes();

                    //   await repo.upload(
                    //     img.path,
                    //     fileBytes,
                    //     // filename: 'test-upload.jpg',
                    //   );

                    //   Fluttertoast.showToast(msg: 'file uploaded');
                    //   ref.read(loaderProvider.notifier).state = false;
                    // }
                  },
                  child: const Text('Upload Image'),
                ),
        ),
      ],
    );
  }
}
