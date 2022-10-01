import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gift_manager/data/modal/request_error.dart';
import 'package:gift_manager/presentation/registration/models/errors.dart';

part 'registration_event.dart';

part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc()
      : super(RegistrationFieldsInfo(
          avatarLink: _avatarBuilder(_defaultAvatarKey),
        )) {
    on<RegistrationChangeAvatar>(_onChangeAvatar);
  }

  static const _defaultAvatarKey = 'test';
  String _avatarKey = _defaultAvatarKey;

  static String _avatarBuilder(String key) => 'https://avatars.dicebear.com/api/croodles/$key.svg';

  FutureOr<void> _onChangeAvatar(
    final RegistrationChangeAvatar event,
    final Emitter<RegistrationState> emit,
  ) {
    _avatarKey = Random().nextInt(1000000).toString();
    emit(RegistrationFieldsInfo(avatarLink: _avatarBuilder(_avatarKey)));
  }
}
