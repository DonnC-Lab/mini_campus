import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:mini_campus_core/mini_campus_core.dart';
import 'package:mini_campus_core/src/features/profile/widgets/profile_card_item.dart';

/// show statistics of student profile
class ProfileStatsCard extends ConsumerWidget {
  /// show statistics of student profile
  const ProfileStatsCard({super.key, this.externalStudent});

  /// external student to show statistics about
  final Student? externalStudent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStudent = ref.watch(studentProvider);

    final student = externalStudent ?? currentStudent;

    final studentUni = ref.watch(studentUniProvider);

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
                'Education Info',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ProfileCardItem(
                    icon: MaterialIcons.calendar_today,
                    title: 'Year',
                    data: getStudentNumberFromEmail(
                      student!.email,
                      UniEmailDomain.uniDomains
                          .firstWhere((uni) => uni.university == studentUni),
                    )!
                        .stringYear,
                  ),
                  ProfileCardItem(
                    icon: FontAwesome5Solid.user_graduate,
                    title: 'Department',
                    data: student.departmentCode,
                  ),
                  ProfileCardItem(
                    data: student.faculty,
                    icon: Entypo.graduation_cap,
                    title: 'Faculty',
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
