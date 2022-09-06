import 'package:deta_data_source/src/deta_exception.dart';
import 'package:dio/dio.dart';

/// general deta exception handler
///
/// extract the proper err message from raised exception
DetaException detaExceptionHandler(Object e) {
  final err = e as Exception;

  final exc = DetaException(message: err.toString());

  if (err is DioError) {
    if (err.type == DioErrorType.response) {
      try {
        final errors = err.response?.data['error'] as List;
        exc.copyWith(message: errors.join(', '));
      } catch (e) {
        try {
          exc.copyWith(message: err.response?.data['detail'] as String);
        } catch (e) {
          exc.copyWith(message: err.message);
        }
      }
    }

    // general err
    else {
      exc.copyWith(message: err.message);
    }
  }

  return exc;
}
