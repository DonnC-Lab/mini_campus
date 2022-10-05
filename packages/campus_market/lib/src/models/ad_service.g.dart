// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AdService _$$_AdServiceFromJson(Map<String, dynamic> json) => _$_AdService(
      id: json['id'] as String?,
      student: json['student'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      type: json['type'] == null
          ? AdType.ad
          : adTypeStringToEnum(json['type'] as String),
      category: json['category'] == null
          ? MarketCategory.none
          : categoryStringToEnum(json['category'] as String),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      isNegotiable: json['isNegotiable'] as bool? ?? false,
      isRequest: json['isRequest'] as bool? ?? false,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdOn: generalDateOnFromJson(json['createdOn'] as String),
    );

Map<String, dynamic> _$$_AdServiceToJson(_$_AdService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student': instance.student,
      'name': instance.name,
      'description': instance.description,
      'type': adTypeToStringItem(instance.type),
      'category': enumToStringItem(instance.category),
      'price': instance.price,
      'isNegotiable': instance.isNegotiable,
      'isRequest': instance.isRequest,
      'images': instance.images,
      'createdOn': generalDateOnToJson(instance.createdOn),
    };
