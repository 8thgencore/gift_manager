part of 'registration_bloc.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();
}

class RegistrationFieldsInfo extends RegistrationState {
  final String avatarLink;
  final RegistrationEmailError? emailError;
  final RegistrationPasswordError? passwordError;
  final RegistrationPasswordConfirmError? passwordConfirmError;
  final RegistrationNameError? nameError;

  const RegistrationFieldsInfo({
    required this.avatarLink,
    this.emailError,
    this.passwordError,
    this.passwordConfirmError,
    this.nameError,
  });

  @override
  List<Object?> get props => [
        avatarLink,
        emailError,
        passwordError,
        passwordConfirmError,
        nameError,
      ];
}

class RegistrationError extends RegistrationState {
  final RequestError requestError;

  const RegistrationError(this.requestError);

  @override
  List<Object?> get props => [requestError];
}

class RegistrationInProgress extends RegistrationState {
  const RegistrationInProgress();

  @override
  List<Object?> get props => [];
}

class RegistrationCompleted extends RegistrationState {
  const RegistrationCompleted();

  @override
  List<Object?> get props => [];
}
