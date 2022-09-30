import 'package:flutter/material.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';

/// custom status container
class StatusContainer extends StatelessWidget {
  /// custom status container instance
  const StatusContainer({
    super.key,
    this.state = false,
    this.activeText = 'Active',
    this.deactiveText = 'Deactive',
    this.width = 60.0,
  });

  /// hold the current state
  final bool state;

  /// text to show when [state] is true
  final String activeText;

  /// text to show when state is false
  final String deactiveText;

  /// container width
  final double width;

  @override
  Widget build(BuildContext context) => Container(
        height: width / 2,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: state
              ? AppColors.kGreenIndicatorColor.withOpacity(0.4)
              : AppColors.kRedIndicatorColor.withOpacity(0.4),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Text(
              state ? activeText : deactiveText,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: state
                        ? AppColors.kGreenIndicatorColor
                        : AppColors.kRedIndicatorColor,
                  ),
            ),
          ),
        ),
      );
}
