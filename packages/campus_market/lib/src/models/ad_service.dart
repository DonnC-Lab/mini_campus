// ignore_for_file: invalid_annotation_target

import 'package:campus_market/src/constants/market_enums.dart';
import 'package:campus_market/src/utils/enum_to_string.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_campus_core/mini_campus_core.dart';

part 'ad_service.freezed.dart';
part 'ad_service.g.dart';

/// Ad | Service model
@freezed
class AdService with _$AdService {
  const factory AdService({
    String? id,

    /// id of student, ad owner
    String? student,
    required String name,
    required String description,
    @JsonKey(
      name: 'type',
      fromJson: adTypeStringToEnum,
      toJson: adTypeToStringItem,
    )
    @Default(AdType.ad)
        AdType type,
    @JsonKey(
      name: 'category',
      fromJson: categoryStringToEnum,
      toJson: enumToStringItem,
    )
    @Default(MarketCategory.none)
        MarketCategory category,
    @Default(0.0)
        double price,
    @Default(false)
        bool isNegotiable,
    @Default(false)
        bool isRequest,
    @Default([])
        List<String> images,
    @JsonKey(
      name: 'createdOn',
      fromJson: generalDateOnFromJson,
      toJson: generalDateOnToJson,
    )
        required DateTime createdOn,
  }) = _AdService;
  const AdService._();

  factory AdService.fromFbRtdb(DataSnapshot doc) {
    final adMap = doc.value as Map;

    final _map = Map<String, dynamic>.from(adMap);

    final _ad = AdService.fromJson(_map);

    return _ad.copyWith(id: doc.key);
  }

  factory AdService.fromJson(Map<String, dynamic> json) =>
      _$AdServiceFromJson(json);
}
