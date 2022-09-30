import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart'
    show KeyboardActionsConfig, KeyboardActionsItem;
import 'package:mini_campus_constants/mini_campus_constants.dart'
    show AppColors;

/// custom keyboard action
///
/// add a DONE button on the keyboard to help dismiss
/// multiline keyboards
KeyboardActionsConfig buildDoneKeyboardActionConfig({
  required BuildContext context,
  required FocusNode node,
}) {
  return KeyboardActionsConfig(
    keyboardBarColor: Colors.grey[200],
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
                  color: AppColors.kPrimaryColor,
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    'DONE',
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
