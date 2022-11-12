import 'package:equatable/equatable.dart';
import 'package:gift_manager/data/http/model/gift_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gifts_response_dto.g.dart';

@JsonSerializable()
class GiftsResponseDto extends Equatable {
  const GiftsResponseDto({required this.gifts});

  factory GiftsResponseDto.fromJson(final Map<String, dynamic> json) =>
      _$GiftsResponseDtoFromJson(json);

  final List<GiftDto> gifts;

  Map<String, dynamic> toJson() => _$GiftsResponseDtoToJson(this);

  @override
  List<Object?> get props => [gifts];
}
