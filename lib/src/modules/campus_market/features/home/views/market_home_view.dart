import 'package:flutter/material.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../../../constants/general_consts.dart';
import 'tab_content_view.dart';

var fimf =
    'https://images.unsplash.com/photo-1635514569148-7a8b9b63d63f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80';

class MarketHomeView extends StatelessWidget {
  const MarketHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugLogger(marketCategories);

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


    // return FirebaseDatabaseListView(
    //   query: categoryAdsQuery,
    //   pageSize: 20,
    //   itemBuilder: (context, snapshot) {
    //     print(snapshot.toString());
    //     final ad = AdService.fromFbRtdb(snapshot);

    //     debugLogger(ad, name: 'tabContentView');

    //     return Text('Ad name is ${ad.name}');
    //   },
    // );