import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:gift_manager/data/modal/request_error.dart';
import 'package:gift_manager/presentation/registration/models/errors.dart';

part 'registration_event.dart';

part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc()
      : super(RegistrationFieldsInfo(avatarLink: _avatarBuilder(_defaultAvatarKey))) {
    on<RegistrationChangeAvatar>(_onChangeAvatar);
    on<RegistrationEmailChanged>(_onEmailChanged);
    on<RegistrationEmailFocusLost>(_onEmailFocusLost);
    on<RegistrationCreateAccount>(_onCreateAccount);
  }

  static const _defaultAvatarKey = 'test';

  static String _avatarBuilder(String key) => 'https://avatars.dicebear.com/api/croodles/$key.svg';

  String _avatarKey = _defaultAvatarKey;

  String _email = '';
  bool _highlightEmailError = false;
  RegistrationEmailError? _emailError;

  String _password = '';
  bool _highlightPasswordError = false;
  RegistrationPasswordError? _passwordError;

  String _passwordConfirmation = '';
  bool _highlightPasswordConfirmationError = false;
  RegistrationPasswordConfirmError? _passwordConfirmationError;

  String _name = '';
  bool _highlightNameError = false;
  RegistrationNameError? _nameError;

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

  FutureOr<void> _onCreateAccount(
    final RegistrationCreateAccount event,
    final Emitter<RegistrationState> emit,
  ) {
    _highlightEmailError = true;
    emit(_calculateFieldsInfo());
  }

  RegistrationFieldsInfo _calculateFieldsInfo() {
    return RegistrationFieldsInfo(
      avatarLink: _avatarBuilder(_avatarKey),
      emailError: _emailError,
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
}
