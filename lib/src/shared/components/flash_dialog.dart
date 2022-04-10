import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

final dialogProvider = Provider((_) => FlashDialog());

class FlashDialog {
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
      duration: const Duration(seconds: 2),
      persistent: false,
      builder: (_, controller) {
        return Flash(
          controller: controller,
          // backgroundColor: Colors.white,
          // brightness: Brightness.light,
          boxShadows: const [BoxShadow(blurRadius: 4)],
          barrierBlur: 3.0,
          barrierColor: Colors.black38,
          barrierDismissible: true,
          behavior: style,
          position: FlashPosition.top,
          child: FlashBar(
            title: Text(title),
            content: Text(mesg),
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

  void showDialogFlash(
    BuildContext context, {
    required String title,
    required String mesg,
    String okButtonText = 'OK',
    String cancelButtonText = 'CANCEL',
    bool persistent = true,
  }) {
    context.showFlashDialog(
        constraints: const BoxConstraints(maxWidth: 300),
        persistent: persistent,
        title: Text(title),
        content: Text(mesg),
        negativeActionBuilder: (context, controller, _) {
          return TextButton(
            onPressed: () {
              controller.dismiss();
            },
            child: Text(cancelButtonText),
          );
        },
        positiveActionBuilder: (context, controller, _) {
          return TextButton(
            onPressed: () {
              controller.dismiss();
            },
            child: Text(okButtonText),
          );
        });
  }

  void showBasicsFlash(
    BuildContext context, {
    required String mesg,
    Duration? duration,
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
          boxShadows: kElevationToShadow[4],
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          child: FlashBar(
            content: Text(mesg),
          ),
        );
      },
    );
  }
}
