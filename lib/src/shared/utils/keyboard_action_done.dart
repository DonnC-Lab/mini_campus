// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:mini_campus/src/shared/index.dart';

KeyboardActionsConfig BuildDoneKeyboardActionConfig({
  required BuildContext context,
  required FocusNode node,
}) {
  return KeyboardActionsConfig(
    keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
    keyboardBarColor: Colors.grey[200],
    nextFocus: true,
    actions: [
      KeyboardActionsItem(
        focusNode: node,
        toolbarButtons: [
          (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  color: bluishColor,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    "DONE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          }
        ],
      ),
    ],
  );
}
