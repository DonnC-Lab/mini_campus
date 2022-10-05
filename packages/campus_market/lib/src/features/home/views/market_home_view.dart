import 'package:campus_market/src/constants/general_constants.dart';
import 'package:campus_market/src/features/home/views/tab_content_view.dart';
import 'package:flutter/material.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';

class MarketHomeView extends StatelessWidget {
  const MarketHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: marketCategories.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 16),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                indicatorColor: AppColors.kPrimaryColor,
                indicatorWeight: 3,
                labelColor: AppColors.kPrimaryColor,
                unselectedLabelColor: Colors.grey,
                tabs: marketCategories.map((e) => Tab(text: e.name)).toList(),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: marketCategories
              .map((e) => TabContentView(marketCategory: e))
              .toList(),
        ),
      ),
    );
  }
}
