import 'package:campus_market/src/features/add-ad-service/views/add_view.dart';
import 'package:campus_market/src/features/favorites/views/fav_view.dart';
import 'package:campus_market/src/features/home/views/market_home_view.dart';
import 'package:campus_market/src/features/profile/views/profile_view.dart';
import 'package:campus_market/src/features/search/views/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

/// main module entry
class CampusMarket extends StatelessWidget {
  /// main module entry
  const CampusMarket({super.key});

  /// module bottom nav pages
  static const pages = [
    MarketHomeView(),
    SearchView(),
    AddView(),
    FavView(),
    MarketProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final _activePrimaryColor = AppColors.kLightShadeColor;
    const _activeSecondaryColor = AppColors.kPrimaryColor;
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
          activeColorPrimary: AppColors.kPrimaryColor,
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: _inactiveColorPrimary,
          onPressed: (context_) {
            pushNewScreen<void>(
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
