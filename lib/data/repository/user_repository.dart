import 'dart:convert';

import 'package:gift_manager/data/http/model/user_dto.dart';
import 'package:gift_manager/data/repository/base/reactive_repository.dart';
import 'package:gift_manager/data/repository/user_provider.dart';
import 'package:gift_manager/di/service_locator.dart';

class UserRepository extends ReactiveRepository<UserDto> {
  factory UserRepository.getInstance() =>
      _instance ??= UserRepository._internal(sl.get<UserProvider>());

  UserRepository._internal(this._userProvider);

  static UserRepository? _instance;

  final UserProvider _userProvider;

  @override
  UserDto convertFromString(String rawItem) => UserDto.fromJson(
        json.decode(rawItem) as Map<String, dynamic>,
      );

  @override
  String convertToString(UserDto item) => json.encode(item.toJson());

  @override
  Future<String?> getRawData() => _userProvider.getUser();

  @override
  Future<bool> saveRawData(String? item) => _userProvider.setUser(item);
}
