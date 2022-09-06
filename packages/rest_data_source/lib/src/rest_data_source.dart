/// {@template rest_data_source}
/// REST API generic data source
/// {@endtemplate}
abstract class RestDataSource {
  /// query rest api data | filter
  Future<dynamic> query({Map<String, dynamic>? query});

  /// save | post data to server
  Future<dynamic> add(Map<String, dynamic> payload, {String key = ''});

  /// delete operation to server
  Future<dynamic> delete(Map<String, dynamic> payload, {String? key});

  /// upload a file resource to server
  Future<dynamic> uploadFile(
    String filepath, {
    String? directory,
    String? filename,
  });

  /// download a single file from server
  Future<dynamic> downloadFile(String id);

  /// list all media files on server
  Future<dynamic> listFiles({
    int limit = 1000,
    String prefix = '',
    String? last,
    String? sort,
  });

  /// delete given file from resource id
  Future<dynamic> deleteFiles(String id);
}
