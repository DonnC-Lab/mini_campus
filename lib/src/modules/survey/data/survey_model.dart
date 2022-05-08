import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_campus/src/shared/utils/date_converter.dart';

part 'survey_model.freezed.dart';
part 'survey_model.g.dart';

@freezed
class SurveyModel with _$SurveyModel {
  factory SurveyModel({
    required String name,
    @JsonKey(
      name: 'createdOn',
      fromJson: generalDateOnFromJson,
      toJson: generalDateOnToJson,
    )
        required DateTime createdOn,
    @JsonKey(
      name: 'expireOn',
      fromJson: generalDateOnFromJson,
      toJson: generalDateOnToJson,
    )
        required DateTime expireOn,
    required String description,

    /// google form url
    required String link,

    /// student id ref
    required String owner,
  }) = _SurveyModel;

  factory SurveyModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyModelFromJson(json);
}
