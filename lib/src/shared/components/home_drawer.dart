import 'package:flutter/material.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../../drawer_module_pages.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    Key? key,
    required this.logo,
    required this.onProfileCardTap,
    this.onCloseIconTap,
    required this.onDrawerItemTap,
  }) : super(key: key);

  final Widget logo;
  final VoidCallback? onCloseIconTap;
  final Function onProfileCardTap;
  final Function(int) onDrawerItemTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: onCloseIconTap,
                      icon: const Icon(Icons.cancel_outlined)),
                  logo,
                ],
              ),
            ),
            const Divider(height: 30),
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, index) => InkWell(
                  onTap: () {
                    onDrawerItemTap(index);
                    Navigator.pop(context);
                  },
                  child: drawerModulePages[index].drawerItem,
                ),
                itemCount: drawerModulePages.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                onProfileCardTap();
                Navigator.pop(context);
              },
              child: const DrawerMiniProfileCard(),
            ),
            const Divider(height: 30),
            //const DrawerHelpStarted(),
            const DrawerThemeSwitcher(),
          ],
        ),
      ),
    );
  }
}
