import 'package:flutter/material.dart';

Widget themeSwitchButton({
  VoidCallback? callback,
  required BuildContext context,
  required String title,
  required IconData icon,
  required Color bgColor,
}) {
  return GestureDetector(
    onTap: callback,
    child: Container(
      height: 50,
      
      margin: const EdgeInsets.all(3.7),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(23),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    ),
  );
}
