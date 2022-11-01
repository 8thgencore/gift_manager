import 'dart:convert';

import 'package:gift_manager/data/http/model/user_dto.dart';
import 'package:gift_manager/data/repository/base/reactive_repository.dart';
import 'package:gift_manager/data/storage/shared_preference_data.dart';

class UserRepository extends ReactiveRepository<UserDto> {
  factory UserRepository.getInstance() => _instance ??= UserRepository._internal(
        SharedPreferenceData.getInstance(),
      );

  UserRepository._internal(this._spData);

  static UserRepository? _instance;

  final SharedPreferenceData _spData;

  @override
  UserDto convertFromString(String rawItem) => UserDto.fromJson(
        json.decode(rawItem) as Map<String, dynamic>,
      );

  @override
  String convertToString(UserDto item) => json.encode(item.toJson());

  @override
  Future<String?> getRawData() => _spData.getUser();

  @override
  Future<bool> saveRawData(String? item) => _spData.setUser(item);
}
