import 'package:flutter/widgets.dart';

import '../widgets/drawer_item.dart';

class DrawerPage {
  final DrawerItem drawerItem;
  final Widget page;
  
  DrawerPage({
    required this.drawerItem,
    required this.page,
  });
}
