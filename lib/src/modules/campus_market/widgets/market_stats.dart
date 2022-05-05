import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mini_campus/src/modules/campus_market/constants/market_enums.dart';
import 'package:mini_campus/src/modules/campus_market/features/favorites/views/fav_view.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../constants/fb_paths.dart';
import 'market_stats_card_item.dart';

class MarketStatsCard extends ConsumerWidget {
  const MarketStatsCard({Key? key, this.extStudent}) : super(key: key);

  final Student? extStudent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStudent = ref.watch(studentProvider);

    var student = extStudent ?? currentStudent;

    return Card(
      child: SizedBox(
        width: double.infinity,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                        .child(FirebasePaths.ads)
                        .orderByChild('student')
                        .equalTo(student!.id!),
                    icon: MaterialIcons.emoji_objects,
                    title: 'Products',
                    adType: AdType.Ad,
                  ),
                  MarketStatsCardItem(
                    query: FirebaseDatabase.instance
                        .ref()
                        .child(FirebasePaths.ads)
                        .orderByChild('student')
                        .equalTo(student.id!),
                    icon: Ionicons.cog_outline,
                    title: 'Services',
                    adType: AdType.Service,
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
