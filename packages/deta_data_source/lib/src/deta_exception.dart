/// {@template deta_exception}
/// deta exception base class
///
/// general exception for deta respository service
/// {@endtemplate}
class DetaException implements Exception {
  /// {@macro deta_exception}
  DetaException({this.message = 'Deta: Something went wrong!'});

  /// descriptive error message
  String? message;

  @override
  String toString() => 'DetaException(message: $message)';

  /// update the message immutable property
  DetaException copyWith({
    String? message,
  }) {
    return DetaException(
      message: message ?? this.message,
    );
  }
}
