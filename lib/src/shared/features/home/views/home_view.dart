import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mini_campus/src/shared/index.dart';

//final currentModuleIndexProvider = StateProvider((_) => 0);

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  int _currentModuleIndex = 0;

  final List<Widget> _appModules = [
    const Center(child: Text('Mini Campus 1')),
    const Center(child: Text('Mini Campus 2')),
    const Center(child: Text('Mini Campus 3')),
    const Center(child: Text('Mini Campus 4')),
  ];

  /// side bar modules list, should match the above [_appModules] index
  ///
  /// each module matches its sideBar Item on drawer
  final _sideBarModules = [
    const DrawerItem(
      icon: AntDesign.isv,
      name: 'Campus Market',
    ),
    const DrawerItem(
      icon: Icons.cast_for_education,
      name: 'Learning',
    ),
    const DrawerItem(
      icon: Entypo.flag,
      name: 'Lost & Found',
    ),
    const DrawerItem(
      icon: Entypo.hand,
      name: 'Report',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider).value;

    // final _currentModule = ref.watch(currentModuleIndexProvider);

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
                        child: _sideBarModules[index]),
                    itemCount: _sideBarModules.length,
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
        // body: _appModules[_currentModuleIndex],
        body: const DetaView(),
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
