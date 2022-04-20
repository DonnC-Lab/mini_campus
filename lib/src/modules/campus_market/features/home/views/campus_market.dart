import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mini_campus/src/shared/constants/colors.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../add-ad-service/views/add_view.dart';
import '../../favorites/views/fav_view.dart';
import '../../profile/views/profile_view.dart';
import 'market_home_view.dart';

class CampusMarket extends StatefulWidget {
  const CampusMarket({Key? key}) : super(key: key);

  @override
  State<CampusMarket> createState() => _CampusMarketState();
}

class _CampusMarketState extends State<CampusMarket> {
  final pages = [
    const MarketHomeView(),
    const MarketHomeView(),
    const AddView(),
    const FavView(),
    const MarketProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: pages,
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(Ionicons.home),
          title: 'Home',
          activeColorPrimary: bluishColorShade,
          activeColorSecondary: bluishColor,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Ionicons.search),
          title: 'Search',
          activeColorPrimary: bluishColorShade,
          activeColorSecondary: bluishColor,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Ionicons.add),
          title: 'Add',
          activeColorPrimary: bluishColor,
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: Colors.grey,
          onPressed: (context_) {
            pushNewScreen(
              context,
              screen: const AddView(),
              withNavBar: false,
            );
          },
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Ionicons.heart),
          title: 'Favorite',
          activeColorPrimary: bluishColorShade,
          activeColorSecondary: bluishColor,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Ionicons.person),
          title: 'Account',
          activeColorPrimary: bluishColorShade,
          activeColorSecondary: bluishColor,
          inactiveColorPrimary: Colors.grey,
        ),
      ],
      decoration: const NavBarDecoration(borderRadius: BorderRadius.zero),
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation:
          const ScreenTransitionAnimation(animateTabTransition: true),
      navBarStyle: NavBarStyle.style15,
    );
  }
}
