import 'package:flutter/material.dart';
import 'package:mini_campus_core/src/models/index.dart';
import 'package:mini_campus_core/src/widgets/index.dart';

/// App drawer, returns a [Drawer] widget
///
/// used to connect all app modules and drawer items
class HomeDrawer extends StatelessWidget {
  /// drawer constructor
  const HomeDrawer({
    super.key,
    required this.drawerModulePages,
    required this.logo,
    required this.onProfileCardTap,
    this.onCloseIconTap,
    required this.onDrawerItemTap,
  });

  /// list of connected app modules
  final List<DrawerPage> drawerModulePages;

  /// logo to display on drawer header
  final Widget logo;

  /// custom callback when close icon is tapped
  final VoidCallback? onCloseIconTap;

  /// callback when profile card is tapped
  final Function onProfileCardTap;

  /// callback when drawer item (module) is tapped
  final void Function(int) onDrawerItemTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: onCloseIconTap,
                    icon: const Icon(Icons.cancel_outlined),
                  ),
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
                // ignore: avoid_dynamic_calls
                onProfileCardTap();
                Navigator.pop(context);
              },
              child: DrawerMiniProfileCard(
                drawerModulePages: drawerModulePages,
              ),
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
