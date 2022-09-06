/// {@template rest_api_response}
/// Contains the information from the http response.
/// {@endtemplate}
class RestApiResponse<T> {
  /// {@macro rest_api_response}
  RestApiResponse({this.body, this.statusCode});

  /// Response body.
  final T? body;

  /// Http status code.
  final int? statusCode;
}
