import '../models/ride_models.dart';
import 'drift_database.dart';

class SearchDao {
  SearchDao(this.db);
  final OptzDatabase db;

  Future<void> saveSearch({
    required String id,
    required String origin,
    required String destination,
    required DateTime when,
  }) {
    return db.insertSearch(
      id: id,
      origin: origin,
      destination: destination,
      when: when.millisecondsSinceEpoch,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<List<Map<String, Object?>>> recent({int limit = 10}) =>
      db.recentSearches(limit: limit);
}

class QuoteDao {
  QuoteDao(this.db);
  final OptzDatabase db;

  Future<void> saveQuotes(String queryId, List<RideQuote> quotes) =>
      db.insertQuotes(queryId, quotes);

  Future<List<RideQuote>> findByQuery(String queryId) async {
    final rows = await db.fetchQuotes(queryId);
    return rows
        .map((row) => RideQuote(
              provider: ProviderType.values
                  .firstWhere((e) => e.name == row['provider'] as String),
              etaMin: row['eta_min'] as int,
              base: row['base'] as int,
              fees: row['fees'] as int,
              total: row['total'] as int,
              rating: (row['rating'] as num).toDouble(),
              isStale: (row['is_stale'] as int) == 1,
            ))
        .toList();
  }
}

class SettingsDao {
  SettingsDao(this.db);
  final OptzDatabase db;

  Future<void> setHappyHour(bool enabled) =>
      db.setSetting('happyHour', enabled.toString());
  Future<bool> happyHour() async =>
      (await db.getSetting('happyHour')) == 'true';
  Future<String> city() async => await db.getSetting('city') ?? 'Coimbatore';
  Future<void> setCity(String city) => db.setSetting('city', city);
}

class AdapterLogDao {
  AdapterLogDao(this.db);
  final OptzDatabase db;

  Future<void> write({
    required String id,
    required String provider,
    required String payload,
    required String result,
    required DateTime timestamp,
  }) {
    return db.insertLog(
      id: id,
      provider: provider,
      payload: payload,
      result: result,
      ts: timestamp.millisecondsSinceEpoch,
    );
  }

  Future<List<Map<String, Object?>>> latest({int limit = 50}) =>
      db.latestLogs(limit: limit);
}
