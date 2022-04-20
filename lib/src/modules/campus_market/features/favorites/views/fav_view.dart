import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/database.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../../../constants/fb_paths.dart';
import '../../../models/ad_service.dart';
import '../../../services/market_rtdb_service.dart';
import '../../../widgets/custom_home_card.dart';

final singleAdFutureProvider =
    FutureProviderFamily<AdService?, String>((ref, adId) {
  final rtdb = ref.read(marketDbProvider);

  return rtdb.getSingleAdService(adId);
});

class FavView extends ConsumerWidget {
  const FavView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(studentProvider);

    return Scaffold(
      body: FirebaseDatabaseQueryBuilder(
        query: FirebaseDatabase.instance
            .ref()
            .child(FirebasePaths.studentLikedAdsRoot(student!.id!)),
        pageSize: 20,
        builder: (context, snapshot, _) {
          if (snapshot.isFetching) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.isFetchingMore) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Something went wrong!\n\n${snapshot.error}'));
          }

          return snapshot.docs.isEmpty
              ? const Center(
                  child: Text('you don\'t have any favorite Ads yet'),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    snapshot.fetchMore();
                  },
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    mainAxisSpacing: 35,
                    crossAxisSpacing: 20,
                    padding: const EdgeInsets.all(16),
                    itemCount: snapshot.docs.length,
                    itemBuilder: (context, index) {
                      if (snapshot.hasMore &&
                          index + 1 == snapshot.docs.length) {
                        snapshot.fetchMore();
                      }

                      final doc = snapshot.docs[index];

                      if (doc.exists) {
                        final docValue = doc.value! as Map;

                        return ref
                            .watch(singleAdFutureProvider(docValue['ad']))
                            .when(
                              data: (adService) {
                                return adService == null
                                    ? const SizedBox.shrink()
                                    : CustomHomeCard(
                                        ad: adService, isEven: index.isEven);
                              },
                              error: (e, st) {
                                return const SizedBox.shrink();
                              },
                              loading: () => const Center(
                                  child:
                                      CircularProgressIndicator()), // todo use shimmer loader
                            );
                      }

                      return const SizedBox.shrink();
                    },
                    staggeredTileBuilder: (index) =>
                        StaggeredTile.count(1, index.isEven ? 1.4 : 1.5),
                  ),
                );
        },
      ),
    );
  }
}
