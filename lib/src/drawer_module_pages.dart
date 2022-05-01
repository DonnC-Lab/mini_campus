import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'modules/campus_market/features/home/views/campus_market.dart';
import 'modules/feedback/pages/feedback_view.dart';
import 'modules/learning/views/learning_view.dart';
import 'modules/lost_and_found/views/lf_view.dart';
import 'shared/index.dart';

/// all app modules connected here

final List<DrawerPage> drawerModulePages = [
  DrawerPage(
    drawerItem: const DrawerItem(
      icon: AntDesign.isv,
      name: 'Campus Market',
    ),
    page: const CampusMarket(),
  ),
  DrawerPage(
    drawerItem: const DrawerItem(
      icon: Icons.cast_for_education,
      name: 'Learning',
    ),
    page: const LearningHomeView(),
  ),
  DrawerPage(
    drawerItem: const DrawerItem(
      icon: Entypo.flag,
      name: 'Lost & Found',
    ),
    page: const LostFoundView(),
  ),
  // DrawerPage(
  //   drawerItem: const DrawerItem(
  //     icon: Entypo.hand,
  //     name: 'Report',
  //   ),
  //   page: const Center(child: Text('Report')),
  // ),
  DrawerPage(
    drawerItem: const DrawerItem(
      icon: MaterialCommunityIcons.cellphone_message,
      name: 'Feedback',
    ),
    page: const FeedbackView(),
  ),
];
