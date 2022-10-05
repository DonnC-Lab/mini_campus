import 'package:campus_market/src/constants/fb_paths.dart';
import 'package:campus_market/src/constants/market_enums.dart';
import 'package:campus_market/src/models/ad_service.dart';
import 'package:campus_market/src/widgets/custom_home_card.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/database.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class TabContentView extends StatelessWidget {
  TabContentView({super.key, this.marketCategory = MarketCategory.all});

  final MarketCategory marketCategory;

  final _ref = FirebaseDatabase.instance.ref().child(FirebasePaths.kAds);

  @override
  Widget build(BuildContext context) {
    final categoryAdsQuery = marketCategory == MarketCategory.all
        ? _ref
        : _ref.orderByChild('category').equalTo(marketCategory.name);

    return FirebaseDatabaseQueryBuilder(
      query: categoryAdsQuery,
      pageSize: 20,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (snapshot.isFetchingMore) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong!\n\n${snapshot.error}'),
          );
        }

        final _ads = snapshot.docs.map(AdService.fromFbRtdb).toList();

        // sort by date, newest first
        if (_ads.isNotEmpty) {
          _ads.sort((a, b) => b.createdOn.compareTo(a.createdOn));
        }

        return _ads.isEmpty
            ? Center(
                child: Text(
                  'no Ads found matching `${marketCategory.name}`\n\n'
                  'Add your Ads to share with friends',
                ),
              )
            : StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                mainAxisSpacing: 35,
                crossAxisSpacing: 20,
                padding: const EdgeInsets.all(16),
                itemCount: _ads.length,
                itemBuilder: (context, index) {
                  if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                    snapshot.fetchMore();
                  }

                  return CustomHomeCard(ad: _ads[index], isEven: index.isEven);
                },
                staggeredTileBuilder: (int index) =>
                    StaggeredTile.count(1, index.isEven ? 1.4 : 1.5),
              );
      },
    );
  }
}
