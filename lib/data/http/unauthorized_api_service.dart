import 'dart:io';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:gift_manager/data/http/api_error_type.dart';
import 'package:gift_manager/data/http/dio_provider.dart';
import 'package:gift_manager/data/http/model/api_error.dart';
import 'package:gift_manager/data/http/model/create_account_request_dto.dart';
import 'package:gift_manager/data/http/model/gifts_response_dto.dart';
import 'package:gift_manager/data/http/model/login_request_dto.dart';
import 'package:gift_manager/data/http/model/user_with_tokens_dto.dart';

class UnauthorizedApiService {
  UnauthorizedApiService();

  final _dio = DioProvider().createDio();

  Future<Either<ApiError, UserWithTokensDto>> register({
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
      return Right(userWithTokens);
    } catch (e) {
      return Left(_getApiError(e));
    }
  }

  Future<Either<ApiError, UserWithTokensDto>> login({
    required final String email,
    required final String password,
  }) async {
    try {
      final requestBody = LoginRequestDto(
        email: email,
        password: password,
      );
      final response = await _dio.post(
        '/auth/login',
        data: requestBody.toJson(),
      );
      final userWithTokens = UserWithTokensDto.fromJson(response.data as Map<String, dynamic>);
      return Right(userWithTokens);
    } catch (e) {
      return Left(_getApiError(e));
    }
  }

  Future<Either<ApiError, GiftsResponseDto>> getAllGifts({
    required final String token,
    final int limit = 10,
    final int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        '/user/gifts',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
        options: Options(headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
        }),
      );
      final giftsTokens = GiftsResponseDto.fromJson(response.data as Map<String, dynamic>);
      return Right(giftsTokens);
    } catch (e) {
      return Left(_getApiError(e));
    }
  }

  ApiError _getApiError(final dynamic e) {
    if (e is DioError) {
      if (e.type == DioErrorType.response && e.response != null) {
        try {
          final apiError = ApiError.fromJson(e.response!.data as Map<String, dynamic>);
          return apiError;
        } catch (apiE) {
          return const ApiError(code: ApiErrorType.unknown);
        }
      }
    }
    return const ApiError(code: ApiErrorType.unknown);
  }
}
