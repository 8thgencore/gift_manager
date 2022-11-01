import 'package:gift_manager/data/repository/base/reactive_repository.dart';
import 'package:gift_manager/data/storage/shared_preference_data.dart';

class RefreshTokenRepository extends ReactiveRepository<String> {
  factory RefreshTokenRepository.getInstance() => _instance ??= RefreshTokenRepository._internal(
    SharedPreferenceData.getInstance(),
  );

  RefreshTokenRepository._internal(this._spData);

  static RefreshTokenRepository? _instance;

  final SharedPreferenceData _spData;

  @override
  String convertFromString(String rawItem) => rawItem;

  @override
  String convertToString(String item) => item;

  @override
  Future<String?> getRawData() => _spData.getRefreshToken();

  @override
  Future<bool> saveRawData(String? item) => _spData.setRefreshToken(item);
}
