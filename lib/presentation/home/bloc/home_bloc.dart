import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_manager/data/http/model/gift_dto.dart';
import 'package:gift_manager/data/http/model/user_dto.dart';
import 'package:gift_manager/data/http/unauthorized_api_service.dart';
import 'package:gift_manager/data/repository/token_repository.dart';
import 'package:gift_manager/data/repository/user_repository.dart';
import 'package:gift_manager/domain/logout_interactor.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required this.userRepository,
    required this.logoutInteractor,
    required this.tokenRepository,
    required this.unauthorizedApiService,
  }) : super(HomeInitial()) {
    on<HomePageLoaded>(_onHomePageLoaded);
    on<HomeLogoutPushed>(_onLogoutPushed);
    on<HomeExternalLogout>(_onHomeExternalLogout);
    _logoutSubscription = userRepository
        .observeItem()
        .where((user) => user == null)
        .take(1)
        .listen((event) => _logout());
  }

  final UserRepository userRepository;
  final LogoutInteractor logoutInteractor;
  final TokenRepository tokenRepository;
  final UnauthorizedApiService unauthorizedApiService;

  late final StreamSubscription _logoutSubscription;

  FutureOr<void> _onHomePageLoaded(
    final HomePageLoaded event,
    final Emitter<HomeState> emit,
  ) async {
    final user = await userRepository.getItem();
    final token = await tokenRepository.getItem();
    if (user == null || token == null) {
      _logout();
      return;
    }
    final giftsResponse = await unauthorizedApiService.getAllGifts(token: token);
    final gifts = giftsResponse.isRight ? giftsResponse.right.gifts : const <GiftDto>[];
    emit(HomeWithUser(user: user, gifts: gifts));
  }

  FutureOr<void> _onLogoutPushed(
    final HomeLogoutPushed event,
    final Emitter<HomeState> emit,
  ) async {
    await logoutInteractor.logout();
    _logout();
  }

  FutureOr<void> _onHomeExternalLogout(
    final HomeExternalLogout event,
    final Emitter<HomeState> emit,
  ) async {
    emit(const HomeGoToLogin());
  }

  void _logout() {
    add(const HomeExternalLogout());
  }

  @override
  Future<void> close() {
    _logoutSubscription.cancel();
    return super.close();
  }
}
