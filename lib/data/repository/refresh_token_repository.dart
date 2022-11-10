import 'package:gift_manager/data/repository/base/reactive_repository.dart';
import 'package:gift_manager/data/repository/refresh_token_provider.dart';
import 'package:gift_manager/di/service_locator.dart';

class RefreshTokenRepository extends ReactiveRepository<String> {
  factory RefreshTokenRepository.getInstance() =>
      _instance ??= RefreshTokenRepository._internal(sl.get<RefreshTokenProvider>());

  RefreshTokenRepository._internal(this._refreshTokenProvider);

  static RefreshTokenRepository? _instance;

  final RefreshTokenProvider _refreshTokenProvider;

  @override
  String convertFromString(String rawItem) => rawItem;

  @override
  String convertToString(String item) => item;

  @override
  Future<String?> getRawData() => _refreshTokenProvider.getRefreshToken();

  @override
  Future<bool> saveRawData(String? item) => _refreshTokenProvider.setRefreshToken(item);
}
