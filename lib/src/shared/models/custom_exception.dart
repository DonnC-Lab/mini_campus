class CustomException implements Exception {
  String? message;

  CustomException({
    this.message = 'Something went wrong!',
  });

  @override
  String toString() => 'CustomException(message: $message)';

  CustomException copyWith({
    String? message,
  }) {
    return CustomException(
      message: message ?? this.message,
    );
  }
}
