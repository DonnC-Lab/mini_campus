import 'package:flutter/material.dart';

/// dismiss by calling
///
/// Navigator.of(context, rootNavigator: true).pop();
modalLoader(BuildContext context) {
  // ? add a loader message
  showDialog(
    context: context,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
}
