import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../../modules/campus_market/features/profile/views/profile_view.dart';
import '../features/profile/views/detailed_profile_update.dart';

class CustomProfileAvatar extends ConsumerWidget {
  const CustomProfileAvatar({
    this.studentId,
    this.title = 'Added By',
    this.fromMarket = false,
    Key? key,
  }) : super(key: key);

  final String? studentId;
  final String title;
  final bool fromMarket;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(studentProvider);

    return studentId == null
        ? _innerChild(student!, context, title)
        : studentId == student!.id
            ? _innerChild(student, context, title)
            : ref.watch(studentProfileProvider(studentId!)).when(
                  data: (data) {
                    return data != null
                        ? _innerChild(data, context, title,
                            fromMarket: fromMarket)
                        : const SizedBox.shrink();
                  },
                  error: (e, st) => const SizedBox.shrink(),
                  loading: () => const CircularProgressIndicator(),
                );
  }
}

Widget _innerChild(
  Student student,
  BuildContext context,
  String title, {
  bool fromMarket = false,
}) {
  final String profPic = student.profilePicture ?? '';

  return GestureDetector(
    onTap: () {
      routeTo(
        context,
        fromMarket
            ? MarketProfileView(extStudent: student)
            : const DetailedProfileView(),
      );
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline1?.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            AdvancedAvatar(
              size: 40,
              name: student.name,
              decoration: BoxDecoration(
                color: bluishColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: profPic.isEmpty
                  ? null
                  : CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(profPic),
                    ),
            ),
            const SizedBox(width: 20),
            Text(
              student.alias ?? student.name!,
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    fontSize: 12,
                  ),
            ),
          ],
        ),
      ],
    ),
  );
}
