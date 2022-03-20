import 'package:flutter/material.dart';

customSnackBar(BuildContext context, String mesg,
    {Color bgColor = Colors.green}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(mesg),
    backgroundColor: bgColor,
  ));
}
