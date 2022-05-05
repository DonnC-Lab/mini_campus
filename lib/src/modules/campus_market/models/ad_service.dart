// ignore_for_file: invalid_annotation_target

import 'package:firebase_database/firebase_database.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_campus/src/shared/utils/index.dart';

import '../constants/market_enums.dart';
import '../utils/enum_to_string.dart';

part 'ad_service.freezed.dart';
part 'ad_service.g.dart';

/// Ad | Service model
@freezed
class AdService with _$AdService {
  const AdService._();

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
    @Default(AdType.Ad)
        AdType type,
    @JsonKey(
      name: 'category',
      fromJson: categoryStringToEnum,
      toJson: enumToStringItem,
    )
    @Default(MarketCategory.None)
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

  factory AdService.fromFbRtdb(DataSnapshot doc) {
    final adMap = doc.value as Map;

    final Map<String, dynamic> _map = Map.from(adMap);

    final _ad = AdService.fromJson(_map);

    return _ad.copyWith(id: doc.key);
  }

  factory AdService.fromJson(Map<String, dynamic> json) =>
      _$AdServiceFromJson(json);
}
