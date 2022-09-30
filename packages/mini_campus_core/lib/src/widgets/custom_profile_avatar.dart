import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:mini_campus_core/mini_campus_core.dart';
import 'package:mini_campus_core/src/services/firebase/student_service.dart';

/// a custom advanced profile avatar
class CustomProfileAvatar extends ConsumerWidget {
  /// a custom advanced profile avatar
  const CustomProfileAvatar({
    this.marketProfileView,
    this.studentId,
    this.title = 'Added By',
    this.fromMarket = false,
    super.key,
  });

  /// profile widget view for CampusMarket module
  final Widget? marketProfileView;

  /// current student profile id
  final String? studentId;

  /// optional title to show on avatar
  final String title;

  /// flag
  final bool fromMarket;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(studentProvider);

    return studentId == null
        ? _InnerChild(student: student!, title: title)
        : studentId == student!.id
            ? _InnerChild(student: student, title: title)
            : ref.watch(studentProfileProvider(studentId!)).when(
                  data: (data) {
                    return data != null
                        ? _InnerChild(
                            student: data,
                            title: title,
                            fromMarket: fromMarket,
                            marketView: marketProfileView,
                          )
                        : const SizedBox.shrink();
                  },
                  error: (e, st) => const SizedBox.shrink(),
                  loading: () => const CircularProgressIndicator.adaptive(),
                );
  }
}

class _InnerChild extends StatelessWidget {
  const _InnerChild({
    required this.student,
    required this.title,
    this.marketView,
    this.fromMarket = false,
  });

  final Student student;
  final String title;
  final Widget? marketView;
  final bool fromMarket;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        routeTo(
          context,
          fromMarket
              ? marketView ?? const DetailedProfileView()
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
                  color: AppColors.kPrimaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: (student.profilePicture ?? '').isEmpty
                    ? null
                    : CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            NetworkImage(student.profilePicture ?? ''),
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
}
