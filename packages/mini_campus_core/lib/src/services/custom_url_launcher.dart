import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:url_launcher/url_launcher.dart';

/// launch in app browser helper method
Future<void> launchInAppWebBrowser({
  required String url,
  ThemeMode themeMode = ThemeMode.system,
}) async {
  if (url.isNotEmpty) {
    var _scheme = CustomTabsColorScheme.system;

    switch (themeMode) {
      case ThemeMode.light:
        _scheme = CustomTabsColorScheme.light;
        break;

      case ThemeMode.dark:
        _scheme = CustomTabsColorScheme.dark;
        break;

      default:
    }

    await FlutterWebBrowser.openWebPage(
      url: url,
      customTabsOptions: CustomTabsOptions(
        colorScheme: _scheme,
        shareState: CustomTabsShareState.on,
        instantAppsEnabled: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: const SafariViewControllerOptions(
        barCollapsingEnabled: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
        modalPresentationStyle: UIModalPresentationStyle.popover,
      ),
    );
  }
}

/// url launcher wrapper
Future<void> customUrlLauncher(String? url) async {
  if (url != null) {
    final c = await canLaunchUrl(Uri.parse(url));

    if (c) {
      await launchUrl(Uri.parse(url));
    }
  }
}
