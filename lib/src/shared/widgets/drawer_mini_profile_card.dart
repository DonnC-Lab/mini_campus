import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../index.dart';

class DrawerMiniProfileCard extends ConsumerWidget {
  const DrawerMiniProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider).value;

    final studentProfile = ref.watch(studentProvider);

    // debugLogger(studentProfile, name: 'DrawerMiniProfileCard');

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: themeMode == ThemeMode.light
            ? greyTextShade.withOpacity(0.1)
            : colorBtnBg(true, themeMode),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdvancedAvatar(
              size: 40,
              name: studentProfile!.name,
              image: NetworkImage(studentProfile.profilePicture ?? ''),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  studentProfile.name ?? 'Student',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  studentProfile.email.studentNumber.studentNumber
                      .toUpperCase(),
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: greyTextShade,
                        // fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
