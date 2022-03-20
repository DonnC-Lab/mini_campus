// ignore_for_file: non_constant_identifier_names

import 'dart:developer' show log;
import 'dart:io' show File, HttpHeaders;
import 'dart:typed_data';

import 'package:dio/dio.dart'
    show
        BaseOptions,
        Dio,
        DioError,
        DioErrorType,
        Options,
        Response,
        ResponseType;
import 'package:path/path.dart' as path;

// !  TODO: make deta response model classes
// !  TODO: make deta error response model classes
// ! decouple service classes

/// base class to interface with deta cloud services
///
/// projectKey & projectId should not be checked in public version control, guide against your keys at all time
class Deta {
  static const _detaBaseUrlVersion = 'v1';

  static const _detaBaseUrl = 'https://drive.deta.sh/$_detaBaseUrlVersion/';

  late final String _projectKey;

  late final String _projectId;

  Deta({required String projectId, required String projectKey}) {
    _projectKey = projectKey;
    _projectId = projectId;
  }

  /// get deta base url
  String get baseUrl => _detaBaseUrl + '$_projectId/';

  /// get deta base url
  Map<String, dynamic> get headers => {'X-Api-Key': _projectKey};
}

// binary upload help from [https://stackoverflow.com/questions/56216660/flutter-upload-image-using-binary-body?msclkid=796d3582a82311ec808ce0957c188a30](here)
class DetaDrive {
  /// deta drive name
  ///
  /// you can create as many deta drives as you can
  final String drive;

  /// deta object with base keys
  final Deta deta;

  /// file limit in MB
  static const int _fileLimit = 10;

  late final Dio _dio;

  /// deta drive cloud storage
  ///
  /// All exceptions return a [DetaException]
  DetaDrive({required this.drive, required this.deta})
      : _dio = Dio(
          BaseOptions(baseUrl: deta.baseUrl + '$drive/', headers: deta.headers),
        );

  String getFileName(File file) {
    return path.basename(file.path);
  }

  double? getFileSizeInMb(String filePath) {
    const int b = 1024;

    try {
      final _file = File(filePath);

      if (!_file.existsSync()) {
        throw Exception('file does not exist: $filePath');
      }

      final bytes = _file.lengthSync();

      final inMb = bytes / (b * b);

      return inMb;
    } catch (e) {
      log(e.toString(), error: e, level: 2);
      return null;
    }
  }

  /// upload a single file to deta drive
  ///
  /// file must be < 10mb, for large sizes, use [chunkedUpload] instead
  ///
  /// filename is passed must be unique else, existing file will be overwritten
  ///
  /// `directory` - folder to put the file in deta drive e.g home/images/
  Future uploadFile(String filePath, Uint8List bytes,
      {String? directory, String? filename}) async {
    String _fileName = filename ??= getFileName(File(filePath));

    final double? _fSize = getFileSizeInMb(filePath);

    if (_fSize != null) {
      if (_fSize > _fileLimit) {
        return 'File size above max limit of $_fileLimit Mb, $_fSize Mb';
      }
    }

    if (directory != null) {
      // remove training / if any and append dir to filename
      final String _dir = directory.replaceAll(RegExp(r'/$'), '');

      _fileName = _dir + '/$_fileName';
    }

    try {
      var resp = await _dio.post(
        'files',
        queryParameters: {'name': _fileName},
        data: Stream.fromIterable(
            bytes.toList().map((e) => [e])), //create a Stream<List<int>>
        //data: bytes.toList(),
        options: Options(
          headers: {HttpHeaders.contentLengthHeader: bytes.toList().length},
        ),
      );

      if (resp.statusCode == 201) {
        return resp.data['name'];
      }

      if (resp.statusCode == 413) {
        throw Exception('File size too large');
      }
    }

    // err
    catch (e) {
      return _detaExceptionHandler(e);
    }
  }

  /// download deta cloud file
  ///
  /// filename is as received while performing [uploadFile]
  ///
  /// return bytes as List<int> if successful
  Future downloadFile(String fileName) async {
    try {
      final Response<List<int>> fileBytesResp = await _dio.get<List<int>>(
          'files/download',
          queryParameters: {'name': fileName},
          options: Options(responseType: ResponseType.bytes));

      if (fileBytesResp.statusCode == 200) {
        // List<int> file bytes
        return fileBytesResp.data;
      }
    }

    //ee
    catch (e) {
      return _detaExceptionHandler(e);
    }
  }

  /// list drive files
  ///
  /// prefix - The prefix that each file name must have.
  ///
  /// last - The last file name seen in a paginated response.
  ///
  /// result
  /// Content-Type: application/json
  /// ```json
  /// {
  ///     "paging": {
  ///         "size": 1000, // the number of filenames in the response
  ///         "last": "last file name in response"
  ///     },
  ///     "names": ["file1", "file2", ...]
  /// }
  /// ```
  Future listFiles({
    int limit = 1000,
    String prefix = '',
    String last = '',
  }) async {
    try {
      final resp = await _dio.get('files', queryParameters: {
        'limit': limit,
        'prefix': prefix,
        'last': last,
      });

      if (resp.statusCode == 200) {
        return resp.data;
      }
    }

    //ee
    catch (e) {
      return _detaExceptionHandler(e);
    }
  }

  /// delete drive files
  ///
  /// filenames[List] - The names of the files to delete, maximum 1000 file names
  ///
  /// result
  /// Content-Type: application/json
  /// ```json
  ///   {
  ///     "deleted": ["file_1", "file_2", ...] // deleted file names
  ///     "failed": {
  ///         "file_3": "reason why file could not be deleted",
  ///         "file_4": "reason why file could not be deleted",
  //     }
  // }
  /// ```
  Future deleteFiles(List<String> filenames) async {
    try {
      final resp = await _dio.delete(
        'files',
        data: {'names': filenames},
        options: Options(contentType: 'application/json'),
      );

      if (resp.statusCode == 200) {
        return resp.data;
      }
    }

    //ee
    catch (e) {
      return _detaExceptionHandler(e);
    }
  }

  DetaException _detaExceptionHandler(Object e) {
    final Exception err = e as Exception;

    DetaException exc = DetaException(message: err.toString());

    if (err is DioError) {
      if (err.type == DioErrorType.response) {
        var errors = err.response?.data['error'] as List;
        exc.copyWith(message: errors.join(", "));
      }

      // general err
      else {
        exc.copyWith(message: err.message);
      }
    }

    log(exc.toString());

    return exc;
  }
}

/// deta exception base class
class DetaException implements Exception {
  String? message;

  DetaException({this.message = 'Deta: Something went wrong!'});

  @override
  String toString() => 'DetaException(message: $message)';

  DetaException copyWith({
    String? message,
  }) {
    return DetaException(
      message: message ?? this.message,
    );
  }
}
