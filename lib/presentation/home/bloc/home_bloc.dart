import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_manager/data/http/model/user_dto.dart';
import 'package:gift_manager/data/repository/user_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.userRepository}) : super(HomeInitial()) {
    on<HomePageLoaded>(_onHomePageLoaded);
    on<HomeLogoutPushed>(_onLogoutPushed);
  }

  final UserRepository userRepository;

  FutureOr<void> _onHomePageLoaded(
    final HomePageLoaded event,
    final Emitter<HomeState> emit,
  ) async {
    final user = await userRepository.getItem();
    if (user == null) {
      _logout();
      return;
    }
    emit(HomeWithUser(user));
  }

  FutureOr<void> _onLogoutPushed(
    final HomeLogoutPushed event,
    final Emitter<HomeState> emit,
  ) async {}

  void _logout() {}
}
