import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_campus/src/shared/utils/date_converter.dart';

import 'payout.dart';
import 'resource.dart';

part 'file_resource.freezed.dart';
part 'file_resource.g.dart';

@freezed
 class FileResource with _$FileResource {
    factory  FileResource({
      /// tee, tcw..
       required String dpt,
        /// admin | student id
        required String uploadedBy,

        @JsonKey(name: 'createdOn', fromJson: detaDateOnFromJson, toJson: detaDateOnToJson)
        required DateTime createdOn,

        /// tee5122
        required String courseCode,

        /// part5, part2
        required String? part,

        /// resource year e.g 2017 for 2017 exam paper
        required int year,

        /// exam, assignment, inclass, other
        required String category,
        @Default('pending') String approvalStatus,
        @Default(false) bool isPromoActive,
        required Resource resource,
        Payout? payout,
    }) = _FileResource;

    factory FileResource.fromJson(Map<String, dynamic> json) => _$FileResourceFromJson(json);
}



