import 'package:url_launcher/url_launcher.dart';

void customUrlLauncher(String? url) async {
  if (url != null) {
    final bool c = await canLaunch(url);

    if (c) {
      launch(url);
    }
  }
}
