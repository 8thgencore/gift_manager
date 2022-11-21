import 'package:gift_manager/data/repository/base/reactive_repository.dart';
import 'package:gift_manager/data/repository/token_provider.dart';

class TokenRepository extends ReactiveRepository<String> {
  TokenRepository(this._tokenProvider);

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
