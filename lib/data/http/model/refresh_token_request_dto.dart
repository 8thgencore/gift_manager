import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_request_dto.g.dart';

@JsonSerializable()
class RefreshTokenRequestDto extends Equatable {
  const RefreshTokenRequestDto({required this.refreshToken});

  factory RefreshTokenRequestDto.fromJson(final Map<String, dynamic> json) =>
      _$RefreshTokenRequestDtoFromJson(json);

  final String refreshToken;

  Map<String, dynamic> toJson() => _$RefreshTokenRequestDtoToJson(this);

  @override
  List<Object?> get props => [refreshToken];
}
