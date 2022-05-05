import 'package:flutter/material.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../../../constants/general_consts.dart';
import 'tab_content_view.dart';

class MarketHomeView extends StatelessWidget {
  const MarketHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: marketCategories.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 16),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                indicatorColor: bluishColor,
                indicatorWeight: 3,
                labelColor: bluishColor,
                unselectedLabelColor: Colors.grey,
                tabs: marketCategories.map((e) => Tab(text: e.name)).toList(),
              ),
            ),
          ),
        ),
        body: TabBarView(
            children: marketCategories
                .map((e) => TabContentView(marketCategory: e))
                .toList()),
      ),
    );
  }
}