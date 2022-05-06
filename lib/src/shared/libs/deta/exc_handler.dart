import 'package:dio/dio.dart';

import '../../index.dart';
import 'exc.dart';

DetaRepositoryException detaRepositoryExceptionHandler(Object e) {
  final Exception err = e as Exception;

  DetaRepositoryException exc =
      DetaRepositoryException(message: err.toString());

  if (err is DioError) {
    if (err.type == DioErrorType.response) {
      try {
        var errors = err.response?.data['error'] as List;
        exc.copyWith(message: errors.join(", "));
      } catch (e) {
        try {
          exc.copyWith(message: err.response?.data['detail']);
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

  debugLogger(exc, name: 'deta-exception-handler');

  return exc;
}
