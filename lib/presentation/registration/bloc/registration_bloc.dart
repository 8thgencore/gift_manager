import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:gift_manager/data/http/unauthorized_api_service.dart';
import 'package:gift_manager/data/modal/request_error.dart';
import 'package:gift_manager/data/storage/shared_preference_data.dart';
import 'package:gift_manager/presentation/registration/models/errors.dart';

part 'registration_event.dart';

part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc()
      : super(RegistrationFieldsInfo(avatarLink: _avatarBuilder(_defaultAvatarKey))) {
    on<RegistrationChangeAvatar>(_onChangeAvatar);
    on<RegistrationEmailChanged>(_onEmailChanged);
    on<RegistrationEmailFocusLost>(_onEmailFocusLost);
    on<RegistrationPasswordChanged>(_onPasswordChanged);
    on<RegistrationPasswordFocusLost>(_onPasswordFocusLost);
    on<RegistrationPasswordConfirmationChanged>(_onPasswordConfirmationChanged);
    on<RegistrationPasswordConfirmationFocusLost>(_onPasswordConfirmationFocusLost);
    on<RegistrationNameChanged>(_onNameChanged);
    on<RegistrationNameFocusLost>(_onNameFocusLost);
    on<RegistrationCreateAccount>(_onCreateAccount);
  }

  static const _defaultAvatarKey = 'test';

  static String _avatarBuilder(String key) => 'https://avatars.dicebear.com/api/croodles/$key.svg';

  static final _passwordRegexp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

  String _avatarKey = _defaultAvatarKey;

  String _email = '';
  bool _highlightEmailError = false;
  RegistrationEmailError? _emailError = RegistrationEmailError.empty;

  String _password = '';
  bool _highlightPasswordError = false;
  RegistrationPasswordError? _passwordError = RegistrationPasswordError.empty;

  String _passwordConfirmation = '';
  bool _highlightPasswordConfirmationError = false;
  RegistrationPasswordConfirmError? _passwordConfirmationError =
      RegistrationPasswordConfirmError.empty;

  String _name = '';
  bool _highlightNameError = false;
  RegistrationNameError? _nameError = RegistrationNameError.empty;

  FutureOr<void> _onChangeAvatar(
    final RegistrationChangeAvatar event,
    final Emitter<RegistrationState> emit,
  ) {
    _avatarKey = Random().nextInt(1000000).toString();
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onEmailChanged(
    final RegistrationEmailChanged event,
    final Emitter<RegistrationState> emit,
  ) {
    _email = event.email;
    _emailError = _validateEmail();
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onEmailFocusLost(
    final RegistrationEmailFocusLost event,
    final Emitter<RegistrationState> emit,
  ) {
    _highlightEmailError = true;
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onPasswordChanged(
    final RegistrationPasswordChanged event,
    final Emitter<RegistrationState> emit,
  ) {
    _password = event.password;
    _passwordError = _validatePassword();
    _passwordConfirmationError = _validatePasswordConfirmation();
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onPasswordFocusLost(
    final RegistrationPasswordFocusLost event,
    final Emitter<RegistrationState> emit,
  ) {
    _highlightPasswordError = true;
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onPasswordConfirmationChanged(
    final RegistrationPasswordConfirmationChanged event,
    final Emitter<RegistrationState> emit,
  ) {
    _passwordConfirmation = event.passwordConfirmation;
    _passwordConfirmationError = _validatePasswordConfirmation();
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onPasswordConfirmationFocusLost(
    final RegistrationPasswordConfirmationFocusLost event,
    final Emitter<RegistrationState> emit,
  ) {
    _highlightPasswordConfirmationError = true;
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onNameChanged(
    final RegistrationNameChanged event,
    final Emitter<RegistrationState> emit,
  ) {
    _name = event.name;
    _nameError = _validateName();
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onNameFocusLost(
    final RegistrationNameFocusLost event,
    final Emitter<RegistrationState> emit,
  ) {
    _highlightNameError = true;
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onCreateAccount(
    final RegistrationCreateAccount event,
    final Emitter<RegistrationState> emit,
  ) async {
    _highlightEmailError = true;
    _highlightPasswordError = true;
    _highlightPasswordConfirmationError = true;
    _highlightNameError = true;
    emit(_calculateFieldsInfo());
    final haveError = _emailError != null ||
        _passwordError != null ||
        _passwordConfirmationError != null ||
        _nameError != null;
    if (haveError) {
      return;
    }
    emit(const RegistrationInProgress());
    final token = await _register();
    SharedPreferenceData.getInstance().setToken(token);
    emit(const RegistrationCompleted());
  }

  Future<String> _register() async {
    try {
      final response = await UnauthorizedApiService.getInstance().register(
        email: _email,
        password: _password,
        name: _name,
        avatarUrl: _avatarBuilder(_avatarKey),
      );
      //TODO
      return response?.token ?? 'asd';
    } catch (e) {
      //TODO
    }
    return 'token';
  }

  RegistrationFieldsInfo _calculateFieldsInfo() {
    return RegistrationFieldsInfo(
      avatarLink: _avatarBuilder(_avatarKey),
      emailError: _highlightEmailError ? _emailError : null,
      passwordError: _highlightPasswordError ? _passwordError : null,
      passwordConfirmError: _highlightPasswordConfirmationError ? _passwordConfirmationError : null,
      nameError: _highlightNameError ? _nameError : null,
    );
  }

  RegistrationEmailError? _validateEmail() {
    if (_email.isEmpty) {
      return RegistrationEmailError.empty;
    }

    if (!EmailValidator.validate(_email)) {
      return RegistrationEmailError.invalid;
    }
    return null;
  }

  RegistrationPasswordError? _validatePassword() {
    if (_password.isEmpty) {
      return RegistrationPasswordError.empty;
    }
    if (_password.length < 6) {
      return RegistrationPasswordError.tooShort;
    }
    if (_passwordRegexp.hasMatch(_password)) {
      return RegistrationPasswordError.wrongSymbols;
    }
    return null;
  }

  RegistrationPasswordConfirmError? _validatePasswordConfirmation() {
    if (_passwordConfirmation.isEmpty) {
      return RegistrationPasswordConfirmError.empty;
    }
    if (_password != _passwordConfirmation) {
      return RegistrationPasswordConfirmError.different;
    }
    return null;
  }

  RegistrationNameError? _validateName() {
    if (_name.isEmpty) {
      return RegistrationNameError.empty;
    }
    return null;
  }
}
