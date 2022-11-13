import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gift_manager/data/repository/token_repository.dart';

class AuthorizationInterceptor extends Interceptor {
  AuthorizationInterceptor(this.tokenRepository);

  final TokenRepository tokenRepository;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await tokenRepository.getItem();
    if (token == null) {
      // TODO
    }
    options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    return handler.next(options);
  }
}
