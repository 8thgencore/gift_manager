import 'package:equatable/equatable.dart';
import 'package:gift_manager/data/http/api_error_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_error.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ApiError extends Equatable {
  const ApiError({required this.code, this.message, this.error});

  factory ApiError.fromJson(final Map<String, dynamic> json) => _$ApiErrorFromJson(json);

  final dynamic code;
  final String? message;
  final String? error;

  ApiErrorType get errorType => ApiErrorType.getByCode(code);

  Map<String, dynamic> toJson() => _$ApiErrorToJson(this);

  @override
  List<Object?> get props => [code, message, error];
}
