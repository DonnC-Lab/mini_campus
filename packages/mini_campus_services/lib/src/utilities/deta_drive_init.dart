/// helper class to hold deta drive required vars
class DetaDriveInit {
  /// deta base name
  final String base;

  /// drive name e.g learning
  final String drive;

  /// for downloading file
  final String? filename;

  DetaDriveInit({this.base = '', this.drive = '', this.filename});
}
