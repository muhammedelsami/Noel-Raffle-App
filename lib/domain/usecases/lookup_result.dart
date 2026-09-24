import '../entities/shared_result.dart';
import '../repositories/online_raffle_repository.dart';

/// Fetches a participant's own result with their personal code.
class LookupResult {
  const LookupResult(this._online);

  final OnlineRaffleRepository _online;

  bool get isAvailable => _online.isAvailable;

  /// [code] must already be normalized with `ShareCode.normalize`.
  Future<SharedResult> call(String code) => _online.lookup(code);
}
