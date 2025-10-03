import 'dart:async';
import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../adapters/ride/ola_adapter.dart';
import '../adapters/ride/ondc_adapter.dart';
import '../adapters/ride/rapido_adapter.dart';
import '../adapters/ride/ride_adapter.dart';
import '../adapters/ride/uber_adapter.dart';
import '../db/daos.dart';
import '../models/ride_models.dart';

class RideResultSet {
  RideResultSet({required this.queryId, required this.quotes, required this.isOffline});

  final String queryId;
  final List<RideQuote> quotes;
  final bool isOffline;
}

class RideRepository {
  RideRepository({
    required this.searchDao,
    required this.quoteDao,
    required this.settingsDao,
    required this.logDao,
    List<RideAdapter>? adapters,
    Uuid? uuid,
  }) : _adapters = adapters ??
            const [
              OlaRideAdapter(),
              UberRideAdapter(),
              RapidoRideAdapter(),
              OndcRideAdapter(),
            ],
        _uuid = uuid ?? const Uuid();

  final SearchDao searchDao;
  final QuoteDao quoteDao;
  final SettingsDao settingsDao;
  final AdapterLogDao logDao;
  final List<RideAdapter> _adapters;
  final Uuid _uuid;

  Future<RideResultSet> search(RideSearchInput input) async {
    final happyHour = await settingsDao.happyHour();
    final queryId = _uuid.v4();
    try {
      final futures = _adapters
          .map((adapter) async {
            final quotes = await adapter.search(input, happyHour: happyHour);
            await logDao.write(
              id: _uuid.v4(),
              provider: adapter.name,
              payload: jsonEncode(input.toJson()),
              result: jsonEncode(quotes.map((q) => q.toJson()).toList()),
              timestamp: DateTime.now(),
            );
            return quotes;
          })
          .toList();
      final allQuotes = (await Future.wait(futures)).expand((e) => e).toList();
      final sorted = _normalizeTotals(allQuotes);
      await searchDao.saveSearch(
        id: queryId,
        origin: input.origin,
        destination: input.destination,
        when: input.when,
      );
      await quoteDao.saveQuotes(queryId, sorted);
      return RideResultSet(queryId: queryId, quotes: sorted, isOffline: false);
    } catch (_) {
      // When offline or an adapter throws, surface cached quotes instead
      final fallback = await _loadLastQuotes(input);
      if (fallback != null) {
        return RideResultSet(queryId: fallback.\$1, quotes: fallback.\$2, isOffline: true);
      }
      rethrow;
    }
  }

  Future<(String, List<RideQuote>)?> _loadLastQuotes(RideSearchInput input) async {
    final recent = await searchDao.recent(limit: 1);
    if (recent.isEmpty) return null;
    final row = recent.first;
    final queryId = row['id'] as String;
    final quotes = await quoteDao.findByQuery(queryId);
    final stale = quotes.map((q) => q.copyWith(isStale: true)).toList();
    return (queryId, stale);
  }

  List<RideQuote> _normalizeTotals(List<RideQuote> quotes) {
    final totals = <String, int>{};
    for (final quote in quotes) {
      final key = quote.provider.name;
      if (!totals.containsKey(key) || quote.total < totals[key]!) {
        totals[key] = quote.total;
      }
    }
    return quotes
        .map((quote) => quote.copyWith(total: quote.total))
        .toList()
      ..sort((a, b) => a.total.compareTo(b.total));
  }

  Future<RideResultSet> fromHistory(String queryId) async {
    final quotes = await quoteDao.findByQuery(queryId);
    return RideResultSet(queryId: queryId, quotes: quotes, isOffline: quotes.any((q) => q.isStale));
  }
}
