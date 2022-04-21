import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mini_campus/src/shared/extensions/index.dart';
import 'package:mini_campus/src/shared/index.dart';

import 'profile_card_item.dart';

class ProfileStatsCard extends ConsumerWidget {
  const ProfileStatsCard({Key? key, this.extStudent}) : super(key: key);

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
              Text('Education Info',
                  style: Theme.of(context).textTheme.subtitle2),
              const SizedBox(height: 8),
              Row(
                children: [
                  ProfileCardItem(
                    icon: MaterialIcons.calendar_today,
                    title: 'Year',
                    data: student!.email.studentNumber.stringYear,
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
