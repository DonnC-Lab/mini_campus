// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'faculty_department.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FacultyDepartment _$FacultyDepartmentFromJson(Map<String, dynamic> json) {
  return _FacultyDepartment.fromJson(json);
}

/// @nodoc
mixin _$FacultyDepartment {
  String get dptCode => throw _privateConstructorUsedError;
  String get dptName => throw _privateConstructorUsedError;

  /// as picked from [Faculty]
  String get faculty => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FacultyDepartmentCopyWith<FacultyDepartment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FacultyDepartmentCopyWith<$Res> {
  factory $FacultyDepartmentCopyWith(
          FacultyDepartment value, $Res Function(FacultyDepartment) then) =
      _$FacultyDepartmentCopyWithImpl<$Res>;
  $Res call({String dptCode, String dptName, String faculty});
}

/// @nodoc
class _$FacultyDepartmentCopyWithImpl<$Res>
    implements $FacultyDepartmentCopyWith<$Res> {
  _$FacultyDepartmentCopyWithImpl(this._value, this._then);

  final FacultyDepartment _value;
  // ignore: unused_field
  final $Res Function(FacultyDepartment) _then;

  @override
  $Res call({
    Object? dptCode = freezed,
    Object? dptName = freezed,
    Object? faculty = freezed,
  }) {
    return _then(_value.copyWith(
      dptCode: dptCode == freezed
          ? _value.dptCode
          : dptCode // ignore: cast_nullable_to_non_nullable
              as String,
      dptName: dptName == freezed
          ? _value.dptName
          : dptName // ignore: cast_nullable_to_non_nullable
              as String,
      faculty: faculty == freezed
          ? _value.faculty
          : faculty // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_FacultyDepartmentCopyWith<$Res>
    implements $FacultyDepartmentCopyWith<$Res> {
  factory _$$_FacultyDepartmentCopyWith(_$_FacultyDepartment value,
          $Res Function(_$_FacultyDepartment) then) =
      __$$_FacultyDepartmentCopyWithImpl<$Res>;
  @override
  $Res call({String dptCode, String dptName, String faculty});
}

/// @nodoc
class __$$_FacultyDepartmentCopyWithImpl<$Res>
    extends _$FacultyDepartmentCopyWithImpl<$Res>
    implements _$$_FacultyDepartmentCopyWith<$Res> {
  __$$_FacultyDepartmentCopyWithImpl(
      _$_FacultyDepartment _value, $Res Function(_$_FacultyDepartment) _then)
      : super(_value, (v) => _then(v as _$_FacultyDepartment));

  @override
  _$_FacultyDepartment get _value => super._value as _$_FacultyDepartment;

  @override
  $Res call({
    Object? dptCode = freezed,
    Object? dptName = freezed,
    Object? faculty = freezed,
  }) {
    return _then(_$_FacultyDepartment(
      dptCode: dptCode == freezed
          ? _value.dptCode
          : dptCode // ignore: cast_nullable_to_non_nullable
              as String,
      dptName: dptName == freezed
          ? _value.dptName
          : dptName // ignore: cast_nullable_to_non_nullable
              as String,
      faculty: faculty == freezed
          ? _value.faculty
          : faculty // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FacultyDepartment implements _FacultyDepartment {
  _$_FacultyDepartment(
      {required this.dptCode, required this.dptName, required this.faculty});

  factory _$_FacultyDepartment.fromJson(Map<String, dynamic> json) =>
      _$$_FacultyDepartmentFromJson(json);

  @override
  final String dptCode;
  @override
  final String dptName;

  /// as picked from [Faculty]
  @override
  final String faculty;

  @override
  String toString() {
    return 'FacultyDepartment(dptCode: $dptCode, dptName: $dptName, faculty: $faculty)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FacultyDepartment &&
            const DeepCollectionEquality().equals(other.dptCode, dptCode) &&
            const DeepCollectionEquality().equals(other.dptName, dptName) &&
            const DeepCollectionEquality().equals(other.faculty, faculty));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(dptCode),
      const DeepCollectionEquality().hash(dptName),
      const DeepCollectionEquality().hash(faculty));

  @JsonKey(ignore: true)
  @override
  _$$_FacultyDepartmentCopyWith<_$_FacultyDepartment> get copyWith =>
      __$$_FacultyDepartmentCopyWithImpl<_$_FacultyDepartment>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FacultyDepartmentToJson(
      this,
    );
  }
}

abstract class _FacultyDepartment implements FacultyDepartment {
  factory _FacultyDepartment(
      {required final String dptCode,
      required final String dptName,
      required final String faculty}) = _$_FacultyDepartment;

  factory _FacultyDepartment.fromJson(Map<String, dynamic> json) =
      _$_FacultyDepartment.fromJson;

  @override
  String get dptCode;
  @override
  String get dptName;
  @override

  /// as picked from [Faculty]
  String get faculty;
  @override
  @JsonKey(ignore: true)
  _$$_FacultyDepartmentCopyWith<_$_FacultyDepartment> get copyWith =>
      throw _privateConstructorUsedError;
}
