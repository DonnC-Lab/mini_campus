import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

/// all app modules connected here
final List<DrawerPage> _modules = [
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
  DrawerPage(
    drawerItem: const DrawerItem(
      icon: AntDesign.form,
      name: 'Surveys',
    ),
    page: const SurveyMainView(),
  ),
];

final List<DrawerPage> drawerModulePages = [
  ..._modules,
  DrawerPage(
    drawerItem: const DrawerItem(
      icon: MaterialCommunityIcons.cellphone_message,
      name: 'Feedback',
    ),
    page: FeedbackView(
      drawerModulePages: [
        ..._modules.map((e) => e.drawerItem.name).toList(),
        'Feedback',
        'General',
      ],
    ),
  ),
];
