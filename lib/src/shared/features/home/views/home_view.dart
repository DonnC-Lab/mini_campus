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

  @override
  void initState() {
    super.initState();

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
          actions: const [
            IconButton(
              tooltip: 'about MiniCampus app',
              onPressed: null,
              icon: Icon(Entypo.info_with_circle),
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
            ? const DetailedProfileView()
            : drawerModulePages[_currentModuleIndex].page,
      ),
    );
  }
}




/*
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

// ===============================================================
Drawer(
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
                          setState(() {
                            _currentModuleIndex = index;
                          });
                          Navigator.pop(context);
                        },
                        child: drawerModulePages[index].drawerItem),
                    itemCount: drawerModulePages.length,
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
*/