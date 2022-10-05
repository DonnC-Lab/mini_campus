import 'package:flutter/material.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';

/// show profile card info
class ProfileCardItem extends StatelessWidget {
  ///
  const ProfileCardItem({
    super.key,
    required this.title,
    required this.icon,
    required this.data,
  });

  /// item title
  final String title;

  /// card item icon
  final IconData icon;

  /// card item information
  final String data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.subtitle2?.copyWith(
                        fontSize: 12,
                        color: AppColors.kGreyShadeColor,
                      ),
                ),
                Icon(icon, color: AppColors.kPrimaryColor),
                Text(
                  data,
                  maxLines: 2,
                  softWrap: true,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.copyWith(fontSize: 13),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
