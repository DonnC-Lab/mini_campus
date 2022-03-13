import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dialogProvider = Provider((_) => DialogService());

class DialogService {
  void showInfoDialog(BuildContext context, String info, String title) async {
    showFlash(
      context: context,
      // persistent: false,
      builder: (context, controller) {
        return Flash.dialog(
          controller: controller,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          margin: const EdgeInsets.all(8),
          child: FlashBar(
            content: Text(
              info,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  controller.dismiss();
                },
                child: const Text('CLOSE'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool?> showDialogConfirmation(
      BuildContext context, String info, String title) async {
    bool? res = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(info),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text(
              'YES',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text(
              'NO',
            ),
          ),
        ],
      ),
    );

    return res;
  }

  void showFloatingFlushbar({
    BuildContext? context,
    String? title,
    String? message,
    bool showOnTop: true,
    bool warning: false, // to change color of popup
    bool autoDismiss: false,
  }) {
    showFlash(
      context: context!,
      duration: autoDismiss ? null : const Duration(milliseconds: 4000),
      //persistent: false,
      builder: (context, controller) {
        return Flash.bar(
          controller: controller,
          backgroundGradient: LinearGradient(
            colors: warning
                ? [Colors.red.shade800, Colors.redAccent.shade700]
                : [Colors.green.shade800, Colors.greenAccent.shade700],
            stops: const [0.6, 1],
          ),
          position: showOnTop ? FlashPosition.top : FlashPosition.bottom,
          horizontalDismissDirection: HorizontalDismissDirection.startToEnd,
          margin: const EdgeInsets.all(8),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          forwardAnimationCurve: Curves.easeOutBack,
          reverseAnimationCurve: Curves.slowMiddle,
          child: FlashBar(
            title: Text(
              title ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              message ?? '',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            shouldIconPulse: false,
          ),
        );
      },
    );
  }
}
