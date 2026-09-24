import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/raffle.dart';
import '../models/raffle_model.dart';

/// Stores the raffle history on the device as JSON in [SharedPreferences].
abstract interface class RaffleLocalDataSource {
  Future<List<Raffle>> readAll();

  Future<void> writeAll(List<Raffle> raffles);
}

class RaffleLocalDataSourceImpl implements RaffleLocalDataSource {
  const RaffleLocalDataSourceImpl(this._prefs);

  static const String storageKey = 'raffle_history';

  /// Oldest raffles beyond this are dropped so storage stays small.
  static const int maxEntries = 100;

  final SharedPreferences _prefs;

  @override
  Future<List<Raffle>> readAll() async {
    final String? raw = _prefs.getString(storageKey);
    if (raw == null) return <Raffle>[];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(RaffleModel.fromJson)
          .toList();
    } catch (_) {
      // Unreadable history must not break the app; it is replaced on the
      // next save.
      return <Raffle>[];
    }
  }

  @override
  Future<void> writeAll(List<Raffle> raffles) {
    final List<Map<String, dynamic>> json = raffles
        .take(maxEntries)
        .map((Raffle r) => RaffleModel.fromEntity(r).toJson())
        .toList();
    return _prefs.setString(storageKey, jsonEncode(json));
  }
}
