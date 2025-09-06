// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_data.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CodeDataCWProxy {
  CodeData id(int? id);

  CodeData name(String name);

  CodeData data(String data);

  CodeData codeType(CodeType codeType);

  CodeData createdAt(DateTime? createdAt);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CodeData(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CodeData(...).copyWith(id: 12, name: "My name")
  /// ```
  CodeData call({
    int? id,
    String name,
    String data,
    CodeType codeType,
    DateTime? createdAt,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfCodeData.copyWith(...)` or call `instanceOfCodeData.copyWith.fieldName(value)` for a single field.
class _$CodeDataCWProxyImpl implements _$CodeDataCWProxy {
  const _$CodeDataCWProxyImpl(this._value);

  final CodeData _value;

  @override
  CodeData id(int? id) => call(id: id);

  @override
  CodeData name(String name) => call(name: name);

  @override
  CodeData data(String data) => call(data: data);

  @override
  CodeData codeType(CodeType codeType) => call(codeType: codeType);

  @override
  CodeData createdAt(DateTime? createdAt) => call(createdAt: createdAt);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `CodeData(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// CodeData(...).copyWith(id: 12, name: "My name")
  /// ```
  CodeData call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? data = const $CopyWithPlaceholder(),
    Object? codeType = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
  }) {
    return CodeData(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      title: name == const $CopyWithPlaceholder() || name == null
          ? _value.title
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      data: data == const $CopyWithPlaceholder() || data == null
          ? _value.data
          // ignore: cast_nullable_to_non_nullable
          : data as String,
      codeType: codeType == const $CopyWithPlaceholder() || codeType == null
          ? _value.codeType
          // ignore: cast_nullable_to_non_nullable
          : codeType as CodeType,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime?,
    );
  }
}

extension $CodeDataCopyWith on CodeData {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfCodeData.copyWith(...)` or `instanceOfCodeData.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CodeDataCWProxy get copyWith => _$CodeDataCWProxyImpl(this);
}
