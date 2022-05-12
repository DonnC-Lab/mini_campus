import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/features/profile/views/detailed_profile_update.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../../../widgets/market_stats.dart';

class MarketProfileView extends ConsumerWidget {
  const MarketProfileView({Key? key, this.extStudent}) : super(key: key);

  final Student? extStudent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStudent = ref.watch(studentProvider);

    var student = extStudent ?? currentStudent;

    final String profPic = student?.profilePicture ?? '';

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: AdvancedAvatar(
                size: 120,
                decoration: BoxDecoration(
                  color: bluishColor,
                  borderRadius: BorderRadius.circular(60),
                ),
                name: student?.name,
                child: profPic.isEmpty
                    ? null
                    : CircleAvatar(
                        radius: 120,
                        backgroundImage: NetworkImage(profPic),
                      ),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: Text(
                student?.alias ?? student?.name ?? 'Student',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                student!.faculty,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    ?.copyWith(color: greyTextShade),
              ),
            ),
            const SizedBox(height: 30),
            Card(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        student.about.isEmpty
                            ? 'Hey 👋 I\'m using MiniCampus'
                            : student.about,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            ?.copyWith(fontSize: 13, color: greyTextShade),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            MarketStatsCard(extStudent: extStudent),
            const SizedBox(height: 30),
            CustomRoundedButton(
              text: 'View Full Profile',
              onTap: () {
                routeTo(
                  context,
                  DetailedProfileView(
                      extStudent: extStudent, showAppbar: false),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
