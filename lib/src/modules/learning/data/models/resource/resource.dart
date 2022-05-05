import 'package:freezed_annotation/freezed_annotation.dart';

part 'resource.freezed.dart';
part 'resource.g.dart';

@freezed
 class Resource with _$Resource {
    factory  Resource({
       required String filename,
       required String filepath,
       required String prefix,
    }) = _Resource;

    factory Resource.fromJson(Map<String, dynamic> json) => _$ResourceFromJson(json);
}
