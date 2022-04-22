import '../libs/deta.dart';

/// helper class to hold deta drive required vars
class DetaDriveInit {
  /// general drive instance
  final Deta deta;

  /// drive name e.g learning
  final String drive;

  /// for downloading file
  final String? filename;

  DetaDriveInit(this.deta, this.drive, {this.filename});
}
