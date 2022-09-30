import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';

/// a helper class for all app dialogs
class AppDialog {
  static const _kGeneralColor = Colors.black87;

  /// show snackbar
  static void customSnackBar(
    BuildContext context,
    String mesg, {
    Color? bgColor,
  }) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mesg), backgroundColor: bgColor));
  }

  /// show app toast
  static void showToast(String mesg) {
    Fluttertoast.showToast(msg: mesg);
  }

  /// show top bar flash dialog
  static void showTopFlash(
    BuildContext context, {
    required String title,
    required String mesg,
    bool showIndicator = false,
    FlashBehavior style = FlashBehavior.floating,
  }) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 5),
      builder: (_, controller) => Flash<void>(
        controller: controller,
        brightness: Theme.of(context).brightness,
        boxShadows: const [BoxShadow(blurRadius: 4)],
        barrierBlur: 3,
        barrierColor: Colors.black38,
        behavior: style,
        position: FlashPosition.top,
        child: FlashBar(
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _kGeneralColor,
                ),
          ),
          content: Text(
            mesg,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(fontSize: 12, color: _kGeneralColor),
          ),
          showProgressIndicator: showIndicator,
          primaryAction: TextButton(
            onPressed: () => controller.dismiss(),
            child: const Text('DISMISS'),
          ),
        ),
      ),
    );
  }

  /// show confirmation prompt dialog
  Future<bool?> showDialogFlash(
    BuildContext context, {
    required String title,
    required String mesg,
    String okButtonText = 'OK',
    String cancelButtonText = 'CANCEL',
    bool persistent = true,
  }) async {
    await context.showFlashDialog<bool?>(
      constraints: const BoxConstraints(maxWidth: 300),
      persistent: persistent,
      brightness: Theme.of(context).brightness,
      backgroundColor: AppColors.kWhiteColor,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _kGeneralColor,
            ),
      ),
      content: Text(
        mesg,
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(fontSize: 13, color: _kGeneralColor),
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
      },
    );
    return null;
  }

  /// basic flash dialog
  void showBasicFlash(
    BuildContext context, {
    required String mesg,
    Duration duration = const Duration(seconds: 5),
    FlashBehavior flashStyle = FlashBehavior.floating,
  }) {
    showFlash(
      context: context,
      duration: duration,
      builder: (context, controller) {
        return Flash<void>(
          controller: controller,
          behavior: flashStyle,
          position: FlashPosition.bottom,
          brightness: Theme.of(context).brightness,
          // backgroundColor: Theme.of(context).backgroundColor,
          boxShadows: kElevationToShadow[4],
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          child: FlashBar(
            content: Text(
              mesg,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontSize: 12, color: _kGeneralColor),
            ),
          ),
        );
      },
    );
  }
}
