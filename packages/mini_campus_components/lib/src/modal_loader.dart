import 'package:flutter/material.dart';

/// custom loader,
///
/// dismiss by calling
///
/// Navigator.of(context, rootNavigator: true).pop();
void modalLoader(BuildContext context, {String? message}) {
  // todo: add loader message
  showDialog<void>(
    context: context,
    builder: (_) => const Center(child: CircularProgressIndicator.adaptive()),
  );
}
