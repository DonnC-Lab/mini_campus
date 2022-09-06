import 'rest_api_response.dart';

///{@template rest_api_error}
/// Class for error in the request.
/// {@endtemplate}
class RestApiError implements Exception {
  /// {@macro rest_api_error}
  RestApiError({this.response});

  /// Response info, it may be `null` if the request can't reach to
  /// the http server, for example, occurring a dns error,
  /// network is not available.
  RestApiResponse? response;

  @override
  String toString() {
    return 'RestApiError(response: RestApiError(body: ${response?.body}, '
        'statusCode: ${response?.statusCode}))';
  }
}
