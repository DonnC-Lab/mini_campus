import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mc_campus_market/mc_campus_market.dart';
import 'package:mc_feedback/mc_feedback.dart';
import 'package:mc_learning/mc_learning.dart';
import 'package:mc_lost_found/mc_lost_found.dart';
import 'package:mc_survey/mc_survey.dart';
import 'package:mini_campus_core/mini_campus_core.dart';

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
