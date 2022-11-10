import 'package:get_it/get_it.dart';
import 'package:gift_manager/data/repository/refresh_token_provider.dart';
import 'package:gift_manager/data/repository/refresh_token_repository.dart';
import 'package:gift_manager/data/repository/token_provider.dart';
import 'package:gift_manager/data/repository/token_repository.dart';
import 'package:gift_manager/data/repository/user_provider.dart';
import 'package:gift_manager/data/repository/user_repository.dart';
import 'package:gift_manager/data/storage/shared_preference_data.dart';

final sl = GetIt.instance;

void initServiceLocator() {
  _setupRepositories();
  _setupInteractors();
  _setupComplexInteractors();
  _setApiRelatedClasses();
  _setupBlocs();
}

// ONLY SINGLETONS
void _setupDataProviders() {
  sl.registerLazySingleton(() => SharedPreferenceData());
  sl.registerLazySingleton<UserProvider>(() => sl.get<SharedPreferenceData>());
  sl.registerLazySingleton<TokenProvider>(() => sl.get<SharedPreferenceData>());
  sl.registerLazySingleton<RefreshTokenProvider>(() => sl.get<SharedPreferenceData>());
}

// ONLY SINGLETONS
void _setupRepositories() {
  sl.registerLazySingleton(() => UserRepository(sl.get<UserProvider>()));
  sl.registerLazySingleton(() => TokenRepository(sl.get<TokenProvider>()));
  sl.registerLazySingleton(() => RefreshTokenRepository(sl.get<RefreshTokenProvider>()));
}

// ONLY SINGLETONS
void _setupInteractors() {}

// ONLY SINGLETONS
void _setupComplexInteractors() {}

// ONLY SINGLETONS
void _setApiRelatedClasses() {}

// ONLY FACTORIES
void _setupBlocs() {}
