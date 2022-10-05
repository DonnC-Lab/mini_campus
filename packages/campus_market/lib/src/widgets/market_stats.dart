import 'package:campus_market/src/constants/fb_paths.dart';
import 'package:campus_market/src/constants/market_enums.dart';
import 'package:campus_market/src/features/favorites/views/fav_view.dart';
import 'package:campus_market/src/widgets/market_stats_card_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mini_campus_core/mini_campus_core.dart';

class MarketStatsCard extends ConsumerWidget {
  const MarketStatsCard({super.key, this.extStudent});

  final Student? extStudent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStudent = ref.watch(studentProvider);

    final student = extStudent ?? currentStudent;

    return Card(
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Market Stats',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  MarketStatsCardItem(
                    query: FirebaseDatabase.instance
                        .ref()
                        .child(FirebasePaths.kAds)
                        .orderByChild('student')
                        .equalTo(student!.id),
                    icon: MaterialIcons.emoji_objects,
                    title: 'Products',
                    adType: AdType.ad,
                  ),
                  MarketStatsCardItem(
                    query: FirebaseDatabase.instance
                        .ref()
                        .child(FirebasePaths.kAds)
                        .orderByChild('student')
                        .equalTo(student.id),
                    icon: Ionicons.cog_outline,
                    title: 'Services',
                    adType: AdType.service,
                  ),
                  MarketStatsCardItem(
                    onTap: () {
                      routeTo(context, FavView(extStudent: extStudent));
                    },
                    query: FirebaseDatabase.instance
                        .ref()
                        .child(FirebasePaths.studentLikedAdsRoot(student.id!)),
                    icon: MaterialCommunityIcons.heart,
                    title: 'Favorites',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
