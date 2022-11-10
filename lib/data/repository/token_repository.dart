import 'package:gift_manager/data/repository/base/reactive_repository.dart';
import 'package:gift_manager/data/repository/token_provider.dart';
import 'package:gift_manager/di/service_locator.dart';

class TokenRepository extends ReactiveRepository<String> {
  factory TokenRepository.getInstance() =>
      _instance ??= TokenRepository._internal(sl.get<TokenProvider>());

  TokenRepository._internal(this._tokenProvider);

  static TokenRepository? _instance;

  final TokenProvider _tokenProvider;

  @override
  String convertFromString(String rawItem) => rawItem;

  @override
  String convertToString(String item) => item;

  @override
  Future<String?> getRawData() => _tokenProvider.getToken();

  @override
  Future<bool> saveRawData(String? item) => _tokenProvider.setToken(item);
}
