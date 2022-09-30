// ignore_for_file: constant_identifier_names

import 'package:mini_campus_core/src/models/index.dart';

/// app notification types / events
enum NotificationType {
  /// no or view only notification
  NONE,

  /// view only
  VIEW,

  /// general notification
  GENERAL,

  /// Campus Market notification event
  MARKET,

  /// Lost n Found event
  LOSTFOUND,

  /// report
  REPORT,

  /// campus learning
  LEARNING,

  /// application update event
  APPUPDATE,
}

/// notification payload to process notification event received
class NotificationPayload {
  /// notification payload to process notification event received
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

  /// notification event received
  final NotificationType notificationType;

  /// recipient
  final Student? toStudent;

  /// student who initiated the notification
  final Student? fromStudent;

  /// image to sent via notification if present
  final String? image;

  /// general name to pass e.g Ad name, report name etc
  final String? name;

  /// event title
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
  final Map<String, dynamic> payload;

  /// notification payload to send to recipient
  String get body {
    var _msg = '${fromStudent?.alias} has notified you on $name.'
        ' Click to view profile';

    switch (notificationType) {
      case NotificationType.MARKET:
        _msg =
            '${fromStudent?.alias} has shown interest on your $name Market Ad.'
            ' Click to view their profile';
        break;

      case NotificationType.LOSTFOUND:
        _msg = '${fromStudent?.alias} picked interest from your `$name` '
            'Lost & Found Item. Click to view their profile';
        break;

      default:
    }

    return _msg;
  }
}
