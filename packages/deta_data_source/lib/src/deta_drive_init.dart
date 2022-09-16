/// {@template deta_init}
/// holder class to hold deta drive required fields
///
/// [base] -> deta collection name
///
/// [drive] -> deta storage drive name
///
/// [filename] -> current file name to download
/// {@endtemplate}
class DetaDriveInit {
  /// {@macro deta_init}
  DetaDriveInit({this.base = '', this.drive = '', this.filename});

  /// deta base name
  final String base;

  /// drive name e.g learning
  final String drive;

  /// for downloading file
  final String? filename;
}
