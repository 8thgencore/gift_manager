import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_manager/data/http/api_error_type.dart';
import 'package:gift_manager/data/http/model/api_error.dart';
import 'package:gift_manager/data/http/model/user_with_tokens_dto.dart';
import 'package:gift_manager/data/http/unauthorized_api_service.dart';
import 'package:gift_manager/data/modal/request_error.dart';
import 'package:gift_manager/data/repository/refresh_token_repository.dart';
import 'package:gift_manager/data/repository/token_repository.dart';
import 'package:gift_manager/data/repository/user_repository.dart';
import 'package:gift_manager/presentation/login/model/models.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required this.userRepository,
    required this.tokenRepository,
    required this.refreshTokenRepository,
  }) : super(LoginState.initial()) {
    on<LoginLoginButtonClicked>(_loginButtonClicked);
    on<LoginEmailChanged>(_emailChanged);
    on<LoginPasswordChanged>(_passwordChanged);
    on<LoginRequestErrorShowed>(_requestErrorShowed);
  }

  final UserRepository userRepository;
  final TokenRepository tokenRepository;
  final RefreshTokenRepository refreshTokenRepository;


  static final _passwordRegexp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$');

  FutureOr<void> _loginButtonClicked(
    LoginLoginButtonClicked event,
    Emitter<LoginState> emit,
  ) async {
    if (state.allFieldsValid) {
      final response = await _login(
        email: state.email,
        password: state.password,
      );
      if (response.isRight) {
        final userWithTokens = response.right;
        await userRepository.setItem(userWithTokens.user);
        await tokenRepository.setItem(userWithTokens.token);
        await refreshTokenRepository.setItem(userWithTokens.refreshToken);
        emit(state.copyWith(authenticated: true));
      } else {
        final apiError = response.left;
        switch (apiError.errorType) {
          case ApiErrorType.incorrectPassword:
            emit(state.copyWith(passwordError: PasswordError.wrongPassword));
            break;
          case ApiErrorType.notFound:
            emit(state.copyWith(emailError: EmailError.notExist));
            break;
          default:
            emit(state.copyWith(requestError: RequestError.unknown));
            break;
        }
      }
    }
  }

  Future<Either<ApiError, UserWithTokensDto>> _login({
    required final String email,
    required final String password,
  }) async {
    final response = await UnauthorizedApiService.getInstance().login(
      email: email,
      password: password,
    );
    return response;
  }

  FutureOr<void> _emailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    final newEmail = event.email;
    emit(
      state.copyWith(
        email: newEmail,
        emailValid: _emailValid(newEmail),
        emailError: EmailError.noError,
        authenticated: false,
      ),
    );
  }

  bool _emailValid(final String email) {
    return EmailValidator.validate(email);
  }

  FutureOr<void> _passwordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final newPassword = event.password;
    emit(
      state.copyWith(
        password: newPassword,
        passwordValid: _passwordValid(newPassword),
        passwordError: PasswordError.noError,
        authenticated: false,
      ),
    );
  }

  bool _passwordValid(final String password) {
    return _passwordRegexp.hasMatch(password);
  }

  FutureOr<void> _requestErrorShowed(
    LoginRequestErrorShowed event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(requestError: RequestError.noError));
  }

  @override
  void onEvent(LoginEvent event) {
    debugPrint('Login Bloc. Event happened: $event');
    super.onEvent(event);
  }

  @override
  void onTransition(Transition<LoginEvent, LoginState> transition) {
    debugPrint('Login Bloc. Transition happened: $transition');
    super.onTransition(transition);
  }
}

enum LoginError { emailNotExist, wrongPassword, other }
