// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Accounts _$AccountsFromJson(Map<String, dynamic> json) {
  return _Accounts.fromJson(json);
}

/// @nodoc
mixin _$Accounts {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'bank')
  String get bankName => throw _privateConstructorUsedError;
  @JsonKey(name: 'account')
  String get account => throw _privateConstructorUsedError;
  @JsonKey(name: 'default')
  bool get isDefault => throw _privateConstructorUsedError;

  /// Serializes this Accounts to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Accounts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountsCopyWith<Accounts> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountsCopyWith<$Res> {
  factory $AccountsCopyWith(Accounts value, $Res Function(Accounts) then) =
      _$AccountsCopyWithImpl<$Res, Accounts>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'bank') String bankName,
      @JsonKey(name: 'account') String account,
      @JsonKey(name: 'default') bool isDefault});
}

/// @nodoc
class _$AccountsCopyWithImpl<$Res, $Val extends Accounts>
    implements $AccountsCopyWith<$Res> {
  _$AccountsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Accounts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? bankName = null,
    Object? account = null,
    Object? isDefault = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: null == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      account: null == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as String,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountsImplCopyWith<$Res>
    implements $AccountsCopyWith<$Res> {
  factory _$$AccountsImplCopyWith(
          _$AccountsImpl value, $Res Function(_$AccountsImpl) then) =
      __$$AccountsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'bank') String bankName,
      @JsonKey(name: 'account') String account,
      @JsonKey(name: 'default') bool isDefault});
}

/// @nodoc
class __$$AccountsImplCopyWithImpl<$Res>
    extends _$AccountsCopyWithImpl<$Res, _$AccountsImpl>
    implements _$$AccountsImplCopyWith<$Res> {
  __$$AccountsImplCopyWithImpl(
      _$AccountsImpl _value, $Res Function(_$AccountsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Accounts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? bankName = null,
    Object? account = null,
    Object? isDefault = null,
  }) {
    return _then(_$AccountsImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: null == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      account: null == account
          ? _value.account
          : account // ignore: cast_nullable_to_non_nullable
              as String,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountsImpl implements _Accounts {
  const _$AccountsImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'bank') required this.bankName,
      @JsonKey(name: 'account') required this.account,
      @JsonKey(name: 'default') required this.isDefault});

  factory _$AccountsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountsImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'bank')
  final String bankName;
  @override
  @JsonKey(name: 'account')
  final String account;
  @override
  @JsonKey(name: 'default')
  final bool isDefault;

  @override
  String toString() {
    return 'Accounts(userId: $userId, bankName: $bankName, account: $account, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.account, account) || other.account == account) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, bankName, account, isDefault);

  /// Create a copy of Accounts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountsImplCopyWith<_$AccountsImpl> get copyWith =>
      __$$AccountsImplCopyWithImpl<_$AccountsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountsImplToJson(
      this,
    );
  }
}

abstract class _Accounts implements Accounts {
  const factory _Accounts(
          {@JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'bank') required final String bankName,
          @JsonKey(name: 'account') required final String account,
          @JsonKey(name: 'default') required final bool isDefault}) =
      _$AccountsImpl;

  factory _Accounts.fromJson(Map<String, dynamic> json) =
      _$AccountsImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'bank')
  String get bankName;
  @override
  @JsonKey(name: 'account')
  String get account;
  @override
  @JsonKey(name: 'default')
  bool get isDefault;

  /// Create a copy of Accounts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountsImplCopyWith<_$AccountsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
