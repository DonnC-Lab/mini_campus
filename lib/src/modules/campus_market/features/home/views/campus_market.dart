import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mini_campus/src/shared/constants/colors.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../add-ad-service/views/add_view.dart';
import '../../favorites/views/fav_view.dart';
import '../../profile/views/profile_view.dart';
import '../../search/views/search_view.dart';
import 'market_home_view.dart';

class CampusMarket extends StatelessWidget {
  const CampusMarket({Key? key}) : super(key: key);

  static const pages = [
    MarketHomeView(),
    SearchView(),
    AddView(),
    FavView(),
    MarketProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final _activePrimaryColor = bluishColorShade;
    const _activeSecondaryColor = bluishColor;
    const _inactiveColorPrimary = Colors.grey;

    return PersistentTabView(
      context,
      screens: pages,
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(Ionicons.home),
          title: 'Home',
          activeColorPrimary: _activePrimaryColor,
          activeColorSecondary: _activeSecondaryColor,
          inactiveColorPrimary: _inactiveColorPrimary,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Ionicons.search),
          title: 'Search',
          activeColorPrimary: _activePrimaryColor,
          activeColorSecondary: _activeSecondaryColor,
          inactiveColorPrimary: _inactiveColorPrimary,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Ionicons.add),
          title: 'Add',
          activeColorPrimary: bluishColor,
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: _inactiveColorPrimary,
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
          activeColorPrimary: _activePrimaryColor,
          activeColorSecondary: _activeSecondaryColor,
          inactiveColorPrimary: _inactiveColorPrimary,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Ionicons.person),
          title: 'Account',
          activeColorPrimary: _activePrimaryColor,
          activeColorSecondary: _activeSecondaryColor,
          inactiveColorPrimary: _inactiveColorPrimary,
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
