import 'package:campus_market/src/widgets/market_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:mini_campus_core/mini_campus_core.dart';

class MarketProfileView extends ConsumerWidget {
  const MarketProfileView({super.key, this.extStudent});

  final Student? extStudent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStudent = ref.watch(studentProvider);

    final student = extStudent ?? currentStudent;

    final profPic = student?.profilePicture ?? '';

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
                  color: AppColors.kPrimaryColor,
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
                    ?.copyWith(color: AppColors.kGreyShadeColor),
              ),
            ),
            const SizedBox(height: 30),
            Card(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8),
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
                            ? "Hey 👋 I'm using MiniCampus"
                            : student.about,
                        style: Theme.of(context).textTheme.subtitle2?.copyWith(
                              fontSize: 13,
                              color: AppColors.kGreyShadeColor,
                            ),
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
                    externalStudent: extStudent,
                    showAppbar: false,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
