import 'package:flutter/material.dart';
import 'package:mini_campus/src/shared/index.dart';

class ProfileCardItem extends StatelessWidget {
  const ProfileCardItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.data,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      ?.copyWith(fontSize: 12, color: greyTextShade),
                ),
                Icon(icon, color: bluishColor),
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
