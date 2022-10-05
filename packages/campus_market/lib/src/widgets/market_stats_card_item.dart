import 'package:campus_market/src/constants/market_enums.dart';
import 'package:campus_market/src/models/ad_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/database.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';

class MarketStatsCardItem extends StatelessWidget {
  const MarketStatsCardItem({
    super.key,
    required this.query,
    required this.title,
    required this.icon,
    this.onTap,
    this.adType = AdType.none,
  });

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
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle2?.copyWith(
                          fontSize: 13,
                          color: AppColors.kGreyShadeColor,
                        ),
                  ),
                  Icon(
                    icon,
                    color: AppColors.kPrimaryColor,
                  ),
                  FirebaseDatabaseQueryBuilder(
                    query: query,
                    pageSize: 100,
                    builder: (context, snapshot, _) {
                      var _items = '0';

                      if (snapshot.isFetching) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
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

                      if (adType != AdType.none) {
                        _items = snapshot.docs
                            .where(
                              (element) =>
                                  AdService.fromFbRtdb(element).type == adType,
                            )
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
