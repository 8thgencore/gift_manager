part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeWithUser extends HomeState {
  const HomeWithUser(this.user);

  final UserDto user;

  @override
  List<Object?> get props => [user];
}

class HomeGoToLogin extends HomeState {
  const HomeGoToLogin();

  @override
  List<Object?> get props => [];
}
