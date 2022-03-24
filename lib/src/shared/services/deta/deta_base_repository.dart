import 'package:deta/deta.dart' show Deta;
import 'package:dio/dio.dart';
import 'package:dio_client_deta_api/dio_client_deta_api.dart';

/// deta base repository
class BaseRepository {
  static final _deta =
      Deta(projectKey: 'projectKey', client: DioClientDetaApi(dio: Dio()));

  
}
