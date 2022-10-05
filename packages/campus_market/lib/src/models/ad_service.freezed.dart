// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'ad_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AdService _$AdServiceFromJson(Map<String, dynamic> json) {
  return _AdService.fromJson(json);
}

/// @nodoc
mixin _$AdService {
  String? get id => throw _privateConstructorUsedError;

  /// id of student, ad owner
  String? get student => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'type', fromJson: adTypeStringToEnum, toJson: adTypeToStringItem)
  AdType get type => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'category',
      fromJson: categoryStringToEnum,
      toJson: enumToStringItem)
  MarketCategory get category => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  bool get isNegotiable => throw _privateConstructorUsedError;
  bool get isRequest => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'createdOn',
      fromJson: generalDateOnFromJson,
      toJson: generalDateOnToJson)
  DateTime get createdOn => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdServiceCopyWith<AdService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdServiceCopyWith<$Res> {
  factory $AdServiceCopyWith(AdService value, $Res Function(AdService) then) =
      _$AdServiceCopyWithImpl<$Res>;
  $Res call(
      {String? id,
      String? student,
      String name,
      String description,
      @JsonKey(name: 'type', fromJson: adTypeStringToEnum, toJson: adTypeToStringItem)
          AdType type,
      @JsonKey(name: 'category', fromJson: categoryStringToEnum, toJson: enumToStringItem)
          MarketCategory category,
      double price,
      bool isNegotiable,
      bool isRequest,
      List<String> images,
      @JsonKey(name: 'createdOn', fromJson: generalDateOnFromJson, toJson: generalDateOnToJson)
          DateTime createdOn});
}

/// @nodoc
class _$AdServiceCopyWithImpl<$Res> implements $AdServiceCopyWith<$Res> {
  _$AdServiceCopyWithImpl(this._value, this._then);

  final AdService _value;
  // ignore: unused_field
  final $Res Function(AdService) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? student = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? type = freezed,
    Object? category = freezed,
    Object? price = freezed,
    Object? isNegotiable = freezed,
    Object? isRequest = freezed,
    Object? images = freezed,
    Object? createdOn = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      student: student == freezed
          ? _value.student
          : student // ignore: cast_nullable_to_non_nullable
              as String?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AdType,
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as MarketCategory,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      isNegotiable: isNegotiable == freezed
          ? _value.isNegotiable
          : isNegotiable // ignore: cast_nullable_to_non_nullable
              as bool,
      isRequest: isRequest == freezed
          ? _value.isRequest
          : isRequest // ignore: cast_nullable_to_non_nullable
              as bool,
      images: images == freezed
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdOn: createdOn == freezed
          ? _value.createdOn
          : createdOn // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
abstract class _$$_AdServiceCopyWith<$Res> implements $AdServiceCopyWith<$Res> {
  factory _$$_AdServiceCopyWith(
          _$_AdService value, $Res Function(_$_AdService) then) =
      __$$_AdServiceCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? id,
      String? student,
      String name,
      String description,
      @JsonKey(name: 'type', fromJson: adTypeStringToEnum, toJson: adTypeToStringItem)
          AdType type,
      @JsonKey(name: 'category', fromJson: categoryStringToEnum, toJson: enumToStringItem)
          MarketCategory category,
      double price,
      bool isNegotiable,
      bool isRequest,
      List<String> images,
      @JsonKey(name: 'createdOn', fromJson: generalDateOnFromJson, toJson: generalDateOnToJson)
          DateTime createdOn});
}

/// @nodoc
class __$$_AdServiceCopyWithImpl<$Res> extends _$AdServiceCopyWithImpl<$Res>
    implements _$$_AdServiceCopyWith<$Res> {
  __$$_AdServiceCopyWithImpl(
      _$_AdService _value, $Res Function(_$_AdService) _then)
      : super(_value, (v) => _then(v as _$_AdService));

  @override
  _$_AdService get _value => super._value as _$_AdService;

  @override
  $Res call({
    Object? id = freezed,
    Object? student = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? type = freezed,
    Object? category = freezed,
    Object? price = freezed,
    Object? isNegotiable = freezed,
    Object? isRequest = freezed,
    Object? images = freezed,
    Object? createdOn = freezed,
  }) {
    return _then(_$_AdService(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      student: student == freezed
          ? _value.student
          : student // ignore: cast_nullable_to_non_nullable
              as String?,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AdType,
      category: category == freezed
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as MarketCategory,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      isNegotiable: isNegotiable == freezed
          ? _value.isNegotiable
          : isNegotiable // ignore: cast_nullable_to_non_nullable
              as bool,
      isRequest: isRequest == freezed
          ? _value.isRequest
          : isRequest // ignore: cast_nullable_to_non_nullable
              as bool,
      images: images == freezed
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdOn: createdOn == freezed
          ? _value.createdOn
          : createdOn // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AdService extends _AdService {
  const _$_AdService(
      {this.id,
      this.student,
      required this.name,
      required this.description,
      @JsonKey(name: 'type', fromJson: adTypeStringToEnum, toJson: adTypeToStringItem)
          this.type = AdType.ad,
      @JsonKey(name: 'category', fromJson: categoryStringToEnum, toJson: enumToStringItem)
          this.category = MarketCategory.none,
      this.price = 0.0,
      this.isNegotiable = false,
      this.isRequest = false,
      final List<String> images = const [],
      @JsonKey(name: 'createdOn', fromJson: generalDateOnFromJson, toJson: generalDateOnToJson)
          required this.createdOn})
      : _images = images,
        super._();

  factory _$_AdService.fromJson(Map<String, dynamic> json) =>
      _$$_AdServiceFromJson(json);

  @override
  final String? id;

  /// id of student, ad owner
  @override
  final String? student;
  @override
  final String name;
  @override
  final String description;
  @override
  @JsonKey(
      name: 'type', fromJson: adTypeStringToEnum, toJson: adTypeToStringItem)
  final AdType type;
  @override
  @JsonKey(
      name: 'category',
      fromJson: categoryStringToEnum,
      toJson: enumToStringItem)
  final MarketCategory category;
  @override
  @JsonKey()
  final double price;
  @override
  @JsonKey()
  final bool isNegotiable;
  @override
  @JsonKey()
  final bool isRequest;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey(
      name: 'createdOn',
      fromJson: generalDateOnFromJson,
      toJson: generalDateOnToJson)
  final DateTime createdOn;

  @override
  String toString() {
    return 'AdService(id: $id, student: $student, name: $name, description: $description, type: $type, category: $category, price: $price, isNegotiable: $isNegotiable, isRequest: $isRequest, images: $images, createdOn: $createdOn)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AdService &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.student, student) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.category, category) &&
            const DeepCollectionEquality().equals(other.price, price) &&
            const DeepCollectionEquality()
                .equals(other.isNegotiable, isNegotiable) &&
            const DeepCollectionEquality().equals(other.isRequest, isRequest) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(other.createdOn, createdOn));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(student),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(category),
      const DeepCollectionEquality().hash(price),
      const DeepCollectionEquality().hash(isNegotiable),
      const DeepCollectionEquality().hash(isRequest),
      const DeepCollectionEquality().hash(_images),
      const DeepCollectionEquality().hash(createdOn));

  @JsonKey(ignore: true)
  @override
  _$$_AdServiceCopyWith<_$_AdService> get copyWith =>
      __$$_AdServiceCopyWithImpl<_$_AdService>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AdServiceToJson(
      this,
    );
  }
}

abstract class _AdService extends AdService {
  const factory _AdService(
      {final String? id,
      final String? student,
      required final String name,
      required final String description,
      @JsonKey(name: 'type', fromJson: adTypeStringToEnum, toJson: adTypeToStringItem)
          final AdType type,
      @JsonKey(name: 'category', fromJson: categoryStringToEnum, toJson: enumToStringItem)
          final MarketCategory category,
      final double price,
      final bool isNegotiable,
      final bool isRequest,
      final List<String> images,
      @JsonKey(name: 'createdOn', fromJson: generalDateOnFromJson, toJson: generalDateOnToJson)
          required final DateTime createdOn}) = _$_AdService;
  const _AdService._() : super._();

  factory _AdService.fromJson(Map<String, dynamic> json) =
      _$_AdService.fromJson;

  @override
  String? get id;
  @override

  /// id of student, ad owner
  String? get student;
  @override
  String get name;
  @override
  String get description;
  @override
  @JsonKey(
      name: 'type', fromJson: adTypeStringToEnum, toJson: adTypeToStringItem)
  AdType get type;
  @override
  @JsonKey(
      name: 'category',
      fromJson: categoryStringToEnum,
      toJson: enumToStringItem)
  MarketCategory get category;
  @override
  double get price;
  @override
  bool get isNegotiable;
  @override
  bool get isRequest;
  @override
  List<String> get images;
  @override
  @JsonKey(
      name: 'createdOn',
      fromJson: generalDateOnFromJson,
      toJson: generalDateOnToJson)
  DateTime get createdOn;
  @override
  @JsonKey(ignore: true)
  _$$_AdServiceCopyWith<_$_AdService> get copyWith =>
      throw _privateConstructorUsedError;
}
