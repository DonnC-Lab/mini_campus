import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mini_campus/src/shared/index.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Color colorBtnBg(bool isDarkModeBtn) {
    // determine toggle button color  based on theme
    final themeMode = ref.read(themeNotifierProvider).value;

    if (isDarkModeBtn) {
      if (themeMode == ThemeMode.light) {
        return Colors.transparent;
      }

      return homePageTextFaint;
    } else {
      if (themeMode == ThemeMode.dark) {
        return Colors.transparent;
      }

      return mainWhite;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider).value;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Mini Campus'),
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
                const Divider(height: 50),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.home),
                      const SizedBox(width: 10),
                      Text(
                        'Home',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Container(),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.business_center),
                      const SizedBox(width: 10),
                      Text(
                        'Campus Market',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Container(),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  height: 80,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                    color: themeMode == ThemeMode.light
                        ? greyTextShade.withOpacity(0.1)
                        : colorBtnBg(true),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/profile.png'),
                          backgroundColor: orangishColor,
                          radius: 25,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            Text(
                              'Tran Mau Tri Tam',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Visual Designer',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    color: greyTextShade,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Center(
                            child: Icon(MaterialIcons.keyboard_arrow_down)),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 50),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 20),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.help_outline,
                        color: greyTextShade,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Help & getting started',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              color: greyTextShade,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Spacer(),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '8',
                            style:
                                Theme.of(context).textTheme.bodyText1?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: fieldDMFillText,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: themeMode == ThemeMode.light
                        ? bgColor
                        : fieldDMFillText,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: themeSwitchButton(
                          context: context,
                          callback: () =>
                              ref.read(themeNotifierProvider).value =
                                  themeMode == ThemeMode.light
                                      ? ThemeMode.dark
                                      : ThemeMode.light,
                          bgColor: colorBtnBg(false),
                          icon: Icons.light_mode,
                          title: 'Light',
                        ),
                      ),
                      Expanded(
                        child: themeSwitchButton(
                          context: context,
                          callback: () =>
                              ref.read(themeNotifierProvider).value =
                                  themeMode == ThemeMode.light
                                      ? ThemeMode.dark
                                      : ThemeMode.light,
                          bgColor: colorBtnBg(true),
                          icon: Icons.dark_mode,
                          title: 'Dark',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: const Center(child: Text('Mini Campus')),
      ),
    );
  }
}
