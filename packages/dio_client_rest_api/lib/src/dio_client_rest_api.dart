import 'dart:typed_data';

import 'package:client_rest_api/client_rest_api.dart';
import 'package:dio/dio.dart';

/// {@template rest_dio_client_api}
/// Deta custom API client using [Dio] package for http request.
/// {@endtemplate}
class DioClientRestApi extends ClientRestApi {
  /// {@macro rest_dio_client_api}
  const DioClientRestApi({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<RestApiResponse<T>> get<T>(
    Uri url, {
    Map<String, String> headers = const {},
    ProgressRequestCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.getUri<T>(
        url,
        options: Options(headers: headers),
        onReceiveProgress: onReceiveProgress,
      );

      return RestApiResponse(
        body: response.data,
        statusCode: response.statusCode,
      );
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<RestApiResponse<T>> put<T>(
    Uri url, {
    Map<String, String> headers = const {},
    Object? data,
    ProgressRequestCallback? onSendProgress,
    ProgressRequestCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.putUri<T>(
        url,
        data: data,
        options: Options(headers: headers),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return RestApiResponse(
        body: response.data,
        statusCode: response.statusCode,
      );
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<RestApiResponse<T>> post<T>(
    Uri url, {
    Map<String, String> headers = const {},
    Object? data,
    ProgressRequestCallback? onSendProgress,
    ProgressRequestCallback? onReceiveProgress,
  }) async {
    Response<T> response;
    try {
      if (data is Uint8List) {
        response = await _dio.postUri<T>(
          url,
          data: Stream.fromIterable(data.toList().map((e) => [e])),
          options: Options(headers: headers),
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );
      } else {
        response = await _dio.postUri<T>(
          url,
          data: data,
          options: Options(headers: headers),
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );
      }

      return RestApiResponse(
        body: response.data,
        statusCode: response.statusCode,
      );
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<RestApiResponse<T>> patch<T>(
    Uri url, {
    Map<String, String> headers = const {},
    Object? data,
    ProgressRequestCallback? onSendProgress,
    ProgressRequestCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.patchUri<T>(
        url,
        data: data,
        options: Options(headers: headers),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return RestApiResponse(
        body: response.data,
        statusCode: response.statusCode,
      );
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<RestApiResponse<T>> delete<T>(
    Uri url, {
    Object? data,
    Map<String, String> headers = const {},
  }) async {
    try {
      final response = await _dio.deleteUri<T>(
        url,
        data: data,
        options: Options(headers: headers),
      );

      return RestApiResponse(
        body: response.data,
        statusCode: response.statusCode,
      );
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioError e) => RestApiError(
        response: RestApiResponse<dynamic>(
          body: e.response?.data,
          statusCode: e.response?.statusCode,
        ),
      );
}
