import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/database.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../constants/market_enums.dart';
import '../models/ad_service.dart';

class MarketStatsCardItem extends StatelessWidget {
  const MarketStatsCardItem({
    Key? key,
    required this.query,
    required this.title,
    required this.icon,
    this.onTap,
    this.adType = AdType.None,
  }) : super(key: key);

  final Query query;
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final AdType adType;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(fontSize: 13, color: greyTextShade),
                  ),
                  Icon(
                    icon,
                    color: bluishColor,
                  ),
                  FirebaseDatabaseQueryBuilder(
                    query: query,
                    pageSize: 100,
                    builder: (context, snapshot, _) {
                      String _items = '0';

                      if (snapshot.isFetching) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        _items = '0*';
                      }

                      if (snapshot.hasMore) {
                        _items = '100+';
                      }

                      _items = snapshot.docs.isEmpty
                          ? _items
                          : snapshot.docs.length.toString();

                      if (adType != AdType.None) {
                        _items = snapshot.docs
                            .where((element) =>
                                AdService.fromFbRtdb(element).type == adType)
                            .length
                            .toString();
                      }

                      return Text(
                        _items,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            ?.copyWith(fontSize: 15),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
