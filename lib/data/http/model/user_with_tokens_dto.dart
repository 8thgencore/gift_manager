import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_with_tokens_dto.g.dart';

@JsonSerializable()
class UserWithTokensDto extends Equatable {
  const UserWithTokensDto({
    required this.token,
    required this.refreshToken,
  });

  factory UserWithTokensDto.fromJson(final Map<String, dynamic> json) =>
      _$UserWithTokensDtoFromJson(json);

  final String token;
  final String refreshToken;

  Map<String, dynamic> toJson() => _$UserWithTokensDtoToJson(this);

  @override
  List<Object?> get props => [token, refreshToken];
}
