/// app custom exception
class CustomException implements Exception {
  /// create [CustomException] instance
  CustomException({this.message = 'Something went wrong!'});

  /// exception message
  String? message;

  @override
  String toString() => 'CustomException(message: $message)';

  /// copyWith function to mutate exception message
  CustomException copyWith({String? message}) =>
      CustomException(message: message ?? this.message);
}
