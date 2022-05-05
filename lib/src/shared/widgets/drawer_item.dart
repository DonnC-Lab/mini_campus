import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key? key,
    required this.icon,
    required this.name,
  }) : super(key: key);

  final IconData icon;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 20),
          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Container(),
        ],
      ),
    );
  }
}
