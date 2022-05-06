/// deta exception base class
class DetaRepositoryException implements Exception {
  String? message;

  DetaRepositoryException({this.message = 'Deta: Something went wrong!'});

  @override
  String toString() => 'DetaRepositoryException(message: $message)';

  DetaRepositoryException copyWith({
    String? message,
  }) {
    return DetaRepositoryException(
      message: message ?? this.message,
    );
  }
}