import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:mini_campus_core/mini_campus_core.dart';

/// profile card
///
/// used to display profile info
/// when drawer is opened
class DrawerMiniProfileCard extends ConsumerWidget {
  /// card constructor
  const DrawerMiniProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider).value;

    final studentProfile = ref.watch(studentProvider);

    final studentUni = ref.watch(studentUniProvider);

    final profPic = studentProfile?.profilePicture ?? '';

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: themeMode == ThemeMode.light
            ? AppColors.kGreyShadeColor.withOpacity(0.1)
            : colorBtnBg(themeMode: themeMode),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdvancedAvatar(
              size: 40,
              name: studentProfile!.name,
              child: profPic.isEmpty
                  ? null
                  : CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(profPic),
                    ),
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
                  getStudentNumberFromEmail(
                    studentProfile.email,
                    UniEmailDomain.uniDomains
                        .firstWhere((uni) => uni.university == studentUni),
                  )!
                      .studentNumber
                      .toUpperCase(),
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: AppColors.kGreyShadeColor,
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
