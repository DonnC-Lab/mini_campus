import 'package:flutter/material.dart';
import 'package:mini_campus/src/shared/index.dart';

class StatusContainer extends StatelessWidget {
  const StatusContainer({
    Key? key,
    this.state = false,
    this.activeText = 'Active',
    this.deactiveText = 'Deactive',
  }) : super(key: key);

  final bool state;
  final String activeText;
  final String deactiveText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: state
              ? greenishColor.withOpacity(0.4)
              : reddishColor.withOpacity(0.4)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            state ? activeText : deactiveText,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: state ? greenishColor : reddishColor,
                ),
          ),
        ),
      ),
    );
  }
}
