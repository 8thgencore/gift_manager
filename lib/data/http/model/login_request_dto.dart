import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_request_dto.g.dart';

@JsonSerializable()
class LoginRequestDto extends Equatable {
  const LoginRequestDto({required this.email, required this.password});

  factory LoginRequestDto.fromJson(final Map<String, dynamic> json) =>
      _$LoginRequestDtoFromJson(json);

  final String email;
  final String password;

  Map<String, dynamic> toJson() => _$LoginRequestDtoToJson(this);

  @override
  List<Object?> get props => [email, password];
}
