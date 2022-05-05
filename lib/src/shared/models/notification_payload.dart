import 'package:mini_campus/src/shared/index.dart';

class NotificationPayload {
  final NotificationType notificationType;

  /// recipient
  final Student? toStudent;

  /// student who initiated the notification
  final Student? fromStudent;
  final String? image;

  /// general name to pass e.g Ad name, report name etc
  final String? name;
  final String? title;

  /// internal key to differentiate different notifications when tapped
  final String key;

  /// notification button label to show on user device e.g VIEW PROFILE
  final String label;

  /// define click action, empty to disable
  final String clickAction;

  /// payload to sent with notification
  ///
  /// e.g
  /// ```json
  /// {
  ///   "userId": studentId,
  ///   "name": studentName,
  ///   "url": url, // crucial for updates or linked notifications
  /// }
  /// ```
  final Map payload;

  NotificationPayload({
    this.clickAction = 'FLUTTER_NOTIFICATION_CLICK',
    this.notificationType = NotificationType.NONE,
    this.toStudent,
    this.fromStudent,
    this.image,
    this.name,
    this.title,
    this.key = 'VIEW',
    this.label = 'VIEW PROFILE',
    this.payload = const {},
  });

  String get body {
    var _msg =
        '${fromStudent?.alias} has notified you on $name. Click to view profile';

    switch (notificationType) {
      case NotificationType.MARKET:
        _msg =
            '${fromStudent?.alias} has shown interest on your $name Market Ad. Click to view their profile';
        break;

      case NotificationType.LOSTFOUND:
        _msg =
            '${fromStudent?.alias} picked interest from your `$name` Lost & Found Item. Click to view their profile';
        break;

      default:
    }

    return _msg;
  }
}