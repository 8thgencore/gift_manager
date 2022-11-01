import 'package:gift_manager/data/http/dio_provider.dart';
import 'package:gift_manager/data/http/model/create_account_request_dto.dart';
import 'package:gift_manager/data/http/model/user_with_tokens_dto.dart';

class UnauthorizedApiService {
  factory UnauthorizedApiService.getInstance() => _instance ??= UnauthorizedApiService._internal();

  UnauthorizedApiService._internal();

  static UnauthorizedApiService? _instance;

  final _dio = DioProvider().createDio();

  Future<UserWithTokensDto?> register({
    required final String email,
    required final String password,
    required final String name,
    required final String avatarUrl,
  }) async {
    try {
      final requestBody = CreateAccountRequestDto(
        email: email,
        password: password,
        name: name,
        avatarUrl: avatarUrl,
      );
      final response = await _dio.post(
        '/auth/create',
        data: requestBody.toJson(),
      );
      final userWithTokens = UserWithTokensDto.fromJson(response.data as Map<String, dynamic>);
      return userWithTokens;
    } catch (e) {
      return null;
    }
  }
}
