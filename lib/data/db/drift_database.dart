import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../data/models/ride_models.dart';
import 'tables.dart';

class OptzDatabase {
  OptzDatabase._(this._executor);

  final QueryExecutor _executor;

  static Future<OptzDatabase> open() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'optz.sqlite'));
    final executor = NativeDatabase(file);
    final db = OptzDatabase._(executor);
    await db._ensureSchema();
    return db;
  }

  Future<void> close() async {
    if (_executor is NativeDatabase) {
      await (_executor as NativeDatabase).close();
    }
  }

  Future<void> _ensureSchema() async {
    await _executor.runCustom('''
      CREATE TABLE IF NOT EXISTS search_query (
        id TEXT PRIMARY KEY,
        origin TEXT,
        destination TEXT,
        when INTEGER,
        created_at INTEGER
      );
    ''');

    await _executor.runCustom('''
      CREATE TABLE IF NOT EXISTS provider_quote (
        id TEXT PRIMARY KEY,
        query_id TEXT,
        provider TEXT,
        eta_min INTEGER,
        base INTEGER,
        fees INTEGER,
        total INTEGER,
        rating REAL,
        created_at INTEGER,
        is_stale INTEGER DEFAULT 0,
        FOREIGN KEY(query_id) REFERENCES search_query(id)
      );
    ''');

    await _executor.runCustom(
        'CREATE INDEX IF NOT EXISTS provider_quote_query_id_index ON provider_quote(query_id);');

    await _executor.runCustom('''
      CREATE TABLE IF NOT EXISTS settings (
        key TEXT PRIMARY KEY,
        value TEXT
      );
    ''');

    await _executor.runCustom('''
      CREATE TABLE IF NOT EXISTS adapter_log (
        id TEXT PRIMARY KEY,
        provider TEXT,
        payload TEXT,
        result TEXT,
        ts INTEGER
      );
    ''');

    await _executor.runCustom(
        'CREATE INDEX IF NOT EXISTS adapter_log_ts_index ON adapter_log(ts DESC);');

    final existingCity = await getSetting('city');
    if (existingCity == null) {
      await setSetting('city', 'Coimbatore');
    }
    final happyHour = await getSetting('happyHour');
    if (happyHour == null) {
      await setSetting('happyHour', 'false');
    }
  }

  Future<void> setSetting(String key, String value) {
    return _executor.runInsert(
      'INSERT OR REPLACE INTO settings(key, value) VALUES (?, ?)',
      [key, value],
    );
  }

  Future<String?> getSetting(String key) async {
    final rows = await _executor.runSelect(
      'SELECT value FROM settings WHERE key = ?',
      [key],
    );
    if (rows.isEmpty) return null;
    return rows.first['value'] as String;
  }

  Future<void> insertSearch({
    required String id,
    required String origin,
    required String destination,
    required int when,
    required int createdAt,
  }) async {
    await _executor.runInsert(
      'INSERT OR REPLACE INTO search_query(id, origin, destination, when, created_at) VALUES (?, ?, ?, ?, ?)',
      [id, origin, destination, when, createdAt],
    );
  }

  Future<void> insertQuotes(String queryId, List<RideQuote> quotes) async {
    await markQuotesStale(queryId);
    for (final quote in quotes) {
      await _executor.runInsert(
        'INSERT OR REPLACE INTO provider_quote(id, query_id, provider, eta_min, base, fees, total, rating, created_at, is_stale) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          '${queryId}_${quote.provider.name}',
          queryId,
          quote.provider.name,
          quote.etaMin,
          quote.base,
          quote.fees,
          quote.total,
          quote.rating,
          DateTime.now().millisecondsSinceEpoch,
          quote.isStale ? 1 : 0,
        ],
      );
    }
  }

  Future<void> markQuotesStale(String queryId) async {
    await _executor.runUpdate(
      'UPDATE provider_quote SET is_stale = 1 WHERE query_id = ?',
      [queryId],
    );
  }

  Future<List<Map<String, Object?>>> fetchQuotes(String queryId) {
    return _executor.runSelect(
      'SELECT * FROM provider_quote WHERE query_id = ? ORDER BY total ASC',
      [queryId],
    );
  }

  Future<List<Map<String, Object?>>> recentSearches({int limit = 10}) {
    return _executor.runSelect(
      'SELECT * FROM search_query ORDER BY created_at DESC LIMIT ?',
      [limit],
    );
  }

  Future<void> insertLog({
    required String id,
    required String provider,
    required String payload,
    required String result,
    required int ts,
  }) async {
    await _executor.runInsert(
      'INSERT INTO adapter_log(id, provider, payload, result, ts) VALUES (?, ?, ?, ?, ?)',
      [id, provider, payload, result, ts],
    );
  }

  Future<List<Map<String, Object?>>> latestLogs({int limit = 50}) {
    return _executor.runSelect(
      'SELECT * FROM adapter_log ORDER BY ts DESC LIMIT ?',
      [limit],
    );
  }

  Future<void> clearAll() async {
    await _executor.runDelete('DELETE FROM provider_quote', const []);
    await _executor.runDelete('DELETE FROM search_query', const []);
    await _executor.runDelete('DELETE FROM adapter_log', const []);
  }
}
