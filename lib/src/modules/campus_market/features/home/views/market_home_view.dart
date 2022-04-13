import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../../../constants/general_consts.dart';

class MarketHomeView extends ConsumerStatefulWidget {
  const MarketHomeView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MarketHomeViewState();
}

class _MarketHomeViewState extends ConsumerState<MarketHomeView> {
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
              .map(
                (e) => Center(
                  child: Text(e.name),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
