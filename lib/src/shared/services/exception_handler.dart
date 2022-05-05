import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';

final exceptionHandlerProvider = Provider.family<CustomException, ExcHandler>(
    (ref, excHandler) => exceptionHandler(excHandler));

String checkErrorMsg(Map data) {
  // check for any detail error messages in the response body
  //debugLogger(data, name: 'checkErrorMsg');

  return data.toString();
}

CustomException exceptionHandler(ExcHandler excHandler) {
  final Object? e = excHandler.exception;
  final String name = excHandler.logName;
  final String topic = excHandler.topic ?? 'request';

  CustomException _exception = CustomException();

  if (e is DioError) {
    final DioError err = e;

    switch (err.type) {
      case DioErrorType.response:
        debugLogger(err.response?.data, name: name, error: e);

        try {
          final errorData = err.response?.data as Map;
          _exception.message = checkErrorMsg(errorData);
        } catch (e) {
          try {
            final errorData = err.response?.data as List;
            _exception.message = errorData.first;
          } catch (e) {
            _exception.message = err.message;
          }
        }
        break;

      case DioErrorType.connectTimeout:
        _exception.message = 'Connection Timeout. Try again';
        break;

      case DioErrorType.receiveTimeout:
        _exception.message =
            'Connection Timeout while loading, please try again to reload';
        break;

      case DioErrorType.sendTimeout:
        _exception.message = 'Connection Timeout. Try again';
        break;

      default:
        _exception.message = 'Failed to $topic. Please try again';
    }
  }

  // else
  else {
    // debugLogger(e);
    _exception.message =
        'There was a problem processing $topic. Please try again';
  }

  //debugLogger(_exception);
  _exception.message = _exception.message!.isEmpty
      ? 'Failed to process $topic. Please try again later'
      : _exception.message;

  return _exception;
}
