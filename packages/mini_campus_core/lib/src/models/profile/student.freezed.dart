// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'student.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Student _$StudentFromJson(Map<String, dynamic> json) {
  return _Student.fromJson(json);
}

/// @nodoc
mixin _$Student {
  String? get id => throw _privateConstructorUsedError;

  /// student institution email
  String get email => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get alias => throw _privateConstructorUsedError;
  String? get profilePicture => throw _privateConstructorUsedError;
  String get whatsappNumber => throw _privateConstructorUsedError;
  String get about => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;

  /// student resident during campus
  String get campusLocation => throw _privateConstructorUsedError;

  /// full department name, Electronic Engineering
  String get department => throw _privateConstructorUsedError;
  String get faculty => throw _privateConstructorUsedError;

  /// tee, tcw ...
  String get departmentCode => throw _privateConstructorUsedError;

  /// fetched from student org email
  String? get studentNumber => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'createdOn',
      fromJson: firestoreDateOnFromJson,
      toJson: firestoreDateOnToJson)
  DateTime get createdOn => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StudentCopyWith<Student> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentCopyWith<$Res> {
  factory $StudentCopyWith(Student value, $Res Function(Student) then) =
      _$StudentCopyWithImpl<$Res>;
  $Res call(
      {String? id,
      String email,
      String? name,
      String? alias,
      String? profilePicture,
      String whatsappNumber,
      String about,
      String? gender,
      String campusLocation,
      String department,
      String faculty,
      String departmentCode,
      String? studentNumber,
      @JsonKey(name: 'createdOn', fromJson: firestoreDateOnFromJson, toJson: firestoreDateOnToJson)
          DateTime createdOn});
}

/// @nodoc
class _$StudentCopyWithImpl<$Res> implements $StudentCopyWith<$Res> {
  _$StudentCopyWithImpl(this._value, this._then);

  final Student _value;
  // ignore: unused_field
  final $Res Function(Student) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? name = freezed,
    Object? alias = freezed,
    Object? profilePicture = freezed,
    Object? whatsappNumber = freezed,
    Object? about = freezed,
    Object? gender = freezed,
    Object? campusLocation = freezed,
    Object? department = freezed,
    Object? faculty = freezed,
    Object? departmentCode = freezed,
    Object? studentNumber = freezed,
    Object? createdOn = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      alias: alias == freezed
          ? _value.alias
          : alias // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePicture: profilePicture == freezed
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
      whatsappNumber: whatsappNumber == freezed
          ? _value.whatsappNumber
          : whatsappNumber // ignore: cast_nullable_to_non_nullable
              as String,
      about: about == freezed
          ? _value.about
          : about // ignore: cast_nullable_to_non_nullable
              as String,
      gender: gender == freezed
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      campusLocation: campusLocation == freezed
          ? _value.campusLocation
          : campusLocation // ignore: cast_nullable_to_non_nullable
              as String,
      department: department == freezed
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      faculty: faculty == freezed
          ? _value.faculty
          : faculty // ignore: cast_nullable_to_non_nullable
              as String,
      departmentCode: departmentCode == freezed
          ? _value.departmentCode
          : departmentCode // ignore: cast_nullable_to_non_nullable
              as String,
      studentNumber: studentNumber == freezed
          ? _value.studentNumber
          : studentNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      createdOn: createdOn == freezed
          ? _value.createdOn
          : createdOn // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
abstract class _$$_StudentCopyWith<$Res> implements $StudentCopyWith<$Res> {
  factory _$$_StudentCopyWith(
          _$_Student value, $Res Function(_$_Student) then) =
      __$$_StudentCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? id,
      String email,
      String? name,
      String? alias,
      String? profilePicture,
      String whatsappNumber,
      String about,
      String? gender,
      String campusLocation,
      String department,
      String faculty,
      String departmentCode,
      String? studentNumber,
      @JsonKey(name: 'createdOn', fromJson: firestoreDateOnFromJson, toJson: firestoreDateOnToJson)
          DateTime createdOn});
}

/// @nodoc
class __$$_StudentCopyWithImpl<$Res> extends _$StudentCopyWithImpl<$Res>
    implements _$$_StudentCopyWith<$Res> {
  __$$_StudentCopyWithImpl(_$_Student _value, $Res Function(_$_Student) _then)
      : super(_value, (v) => _then(v as _$_Student));

  @override
  _$_Student get _value => super._value as _$_Student;

  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? name = freezed,
    Object? alias = freezed,
    Object? profilePicture = freezed,
    Object? whatsappNumber = freezed,
    Object? about = freezed,
    Object? gender = freezed,
    Object? campusLocation = freezed,
    Object? department = freezed,
    Object? faculty = freezed,
    Object? departmentCode = freezed,
    Object? studentNumber = freezed,
    Object? createdOn = freezed,
  }) {
    return _then(_$_Student(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      alias: alias == freezed
          ? _value.alias
          : alias // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePicture: profilePicture == freezed
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
      whatsappNumber: whatsappNumber == freezed
          ? _value.whatsappNumber
          : whatsappNumber // ignore: cast_nullable_to_non_nullable
              as String,
      about: about == freezed
          ? _value.about
          : about // ignore: cast_nullable_to_non_nullable
              as String,
      gender: gender == freezed
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      campusLocation: campusLocation == freezed
          ? _value.campusLocation
          : campusLocation // ignore: cast_nullable_to_non_nullable
              as String,
      department: department == freezed
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      faculty: faculty == freezed
          ? _value.faculty
          : faculty // ignore: cast_nullable_to_non_nullable
              as String,
      departmentCode: departmentCode == freezed
          ? _value.departmentCode
          : departmentCode // ignore: cast_nullable_to_non_nullable
              as String,
      studentNumber: studentNumber == freezed
          ? _value.studentNumber
          : studentNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      createdOn: createdOn == freezed
          ? _value.createdOn
          : createdOn // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Student extends _Student {
  _$_Student(
      {this.id,
      required this.email,
      this.name,
      this.alias,
      this.profilePicture,
      this.whatsappNumber = '',
      this.about = '',
      this.gender,
      this.campusLocation = '',
      required this.department,
      required this.faculty,
      required this.departmentCode,
      this.studentNumber,
      @JsonKey(name: 'createdOn', fromJson: firestoreDateOnFromJson, toJson: firestoreDateOnToJson)
          required this.createdOn})
      : super._();

  factory _$_Student.fromJson(Map<String, dynamic> json) =>
      _$$_StudentFromJson(json);

  @override
  final String? id;

  /// student institution email
  @override
  final String email;
  @override
  final String? name;
  @override
  final String? alias;
  @override
  final String? profilePicture;
  @override
  @JsonKey()
  final String whatsappNumber;
  @override
  @JsonKey()
  final String about;
  @override
  final String? gender;

  /// student resident during campus
  @override
  @JsonKey()
  final String campusLocation;

  /// full department name, Electronic Engineering
  @override
  final String department;
  @override
  final String faculty;

  /// tee, tcw ...
  @override
  final String departmentCode;

  /// fetched from student org email
  @override
  final String? studentNumber;
  @override
  @JsonKey(
      name: 'createdOn',
      fromJson: firestoreDateOnFromJson,
      toJson: firestoreDateOnToJson)
  final DateTime createdOn;

  @override
  String toString() {
    return 'Student(id: $id, email: $email, name: $name, alias: $alias, profilePicture: $profilePicture, whatsappNumber: $whatsappNumber, about: $about, gender: $gender, campusLocation: $campusLocation, department: $department, faculty: $faculty, departmentCode: $departmentCode, studentNumber: $studentNumber, createdOn: $createdOn)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Student &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.email, email) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.alias, alias) &&
            const DeepCollectionEquality()
                .equals(other.profilePicture, profilePicture) &&
            const DeepCollectionEquality()
                .equals(other.whatsappNumber, whatsappNumber) &&
            const DeepCollectionEquality().equals(other.about, about) &&
            const DeepCollectionEquality().equals(other.gender, gender) &&
            const DeepCollectionEquality()
                .equals(other.campusLocation, campusLocation) &&
            const DeepCollectionEquality()
                .equals(other.department, department) &&
            const DeepCollectionEquality().equals(other.faculty, faculty) &&
            const DeepCollectionEquality()
                .equals(other.departmentCode, departmentCode) &&
            const DeepCollectionEquality()
                .equals(other.studentNumber, studentNumber) &&
            const DeepCollectionEquality().equals(other.createdOn, createdOn));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(email),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(alias),
      const DeepCollectionEquality().hash(profilePicture),
      const DeepCollectionEquality().hash(whatsappNumber),
      const DeepCollectionEquality().hash(about),
      const DeepCollectionEquality().hash(gender),
      const DeepCollectionEquality().hash(campusLocation),
      const DeepCollectionEquality().hash(department),
      const DeepCollectionEquality().hash(faculty),
      const DeepCollectionEquality().hash(departmentCode),
      const DeepCollectionEquality().hash(studentNumber),
      const DeepCollectionEquality().hash(createdOn));

  @JsonKey(ignore: true)
  @override
  _$$_StudentCopyWith<_$_Student> get copyWith =>
      __$$_StudentCopyWithImpl<_$_Student>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_StudentToJson(
      this,
    );
  }
}

abstract class _Student extends Student {
  factory _Student(
      {final String? id,
      required final String email,
      final String? name,
      final String? alias,
      final String? profilePicture,
      final String whatsappNumber,
      final String about,
      final String? gender,
      final String campusLocation,
      required final String department,
      required final String faculty,
      required final String departmentCode,
      final String? studentNumber,
      @JsonKey(name: 'createdOn', fromJson: firestoreDateOnFromJson, toJson: firestoreDateOnToJson)
          required final DateTime createdOn}) = _$_Student;
  _Student._() : super._();

  factory _Student.fromJson(Map<String, dynamic> json) = _$_Student.fromJson;

  @override
  String? get id;
  @override

  /// student institution email
  String get email;
  @override
  String? get name;
  @override
  String? get alias;
  @override
  String? get profilePicture;
  @override
  String get whatsappNumber;
  @override
  String get about;
  @override
  String? get gender;
  @override

  /// student resident during campus
  String get campusLocation;
  @override

  /// full department name, Electronic Engineering
  String get department;
  @override
  String get faculty;
  @override

  /// tee, tcw ...
  String get departmentCode;
  @override

  /// fetched from student org email
  String? get studentNumber;
  @override
  @JsonKey(
      name: 'createdOn',
      fromJson: firestoreDateOnFromJson,
      toJson: firestoreDateOnToJson)
  DateTime get createdOn;
  @override
  @JsonKey(ignore: true)
  _$$_StudentCopyWith<_$_Student> get copyWith =>
      throw _privateConstructorUsedError;
}
