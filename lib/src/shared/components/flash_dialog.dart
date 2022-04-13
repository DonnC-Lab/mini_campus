import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../index.dart';

final dialogProvider = Provider((_) => FlashDialog(_.read));

class FlashDialog {
  final Reader read;

  ThemeMode mode = ThemeMode.system;

  FlashDialog(this.read) : mode = read(themeNotifierProvider).value;

  void customSnackBar(BuildContext context, String mesg, {Color? bgColor}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mesg),
      backgroundColor: bgColor,
    ));
  }

  void showToast(String mesg) {
    Fluttertoast.showToast(msg: mesg);
  }

  void showTopFlash(
    BuildContext context, {
    required String title,
    required String mesg,
    FlashBehavior style = FlashBehavior.floating,
  }) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 5),
      builder: (_, controller) {
        return Flash(
          controller: controller,
          brightness: Theme.of(context).brightness,
          boxShadows: const [BoxShadow(blurRadius: 4)],
          barrierBlur: 3.0,
          barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: style,
          position: FlashPosition.top,
          child: FlashBar(
            title: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            content: Text(
              mesg,
              style:
                  Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 12),
            ),
            //showProgressIndicator: true,
            primaryAction: TextButton(
              onPressed: () => controller.dismiss(),
              child: const Text('DISMISS'),
            ),
          ),
        );
      },
    );
  }

  Future<bool?> showDialogFlash(
    BuildContext context, {
    required String title,
    required String mesg,
    String okButtonText = 'OK',
    String cancelButtonText = 'CANCEL',
    bool persistent = true,
  }) async {
    return await context.showFlashDialog<bool?>(
        constraints: const BoxConstraints(maxWidth: 300),
        persistent: persistent,
        brightness: Theme.of(context).brightness,
        //backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        content: Text(
          mesg,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(fontSize: 13),
        ),
        negativeActionBuilder: (context, controller, _) {
          return TextButton(
            onPressed: () {
              controller.dismiss(false);
            },
            child: Text(cancelButtonText),
          );
        },
        positiveActionBuilder: (context, controller, _) {
          return TextButton(
            onPressed: () {
              controller.dismiss(true);
            },
            child: Text(okButtonText),
          );
        });
  }

  void showBasicsFlash(
    BuildContext context, {
    required String mesg,
    Duration duration = const Duration(seconds: 5),
    flashStyle = FlashBehavior.floating,
  }) {
    showFlash(
      context: context,
      duration: duration,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          behavior: flashStyle,
          position: FlashPosition.bottom,
          brightness: Theme.of(context).brightness,
          backgroundColor: Theme.of(context).backgroundColor,
          boxShadows: kElevationToShadow[4],
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          child: FlashBar(
            content: Text(
              mesg,
              style:
                  Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 12),
            ),
          ),
        );
      },
    );
  }
}
