import 'package:collection/collection.dart';

import '../db/daos.dart';
import '../models/ride_models.dart';

class HistoryEntry {
  HistoryEntry({
    required this.id,
    required this.origin,
    required this.destination,
    required this.when,
    required this.bestQuote,
  });

  final String id;
  final String origin;
  final String destination;
  final DateTime when;
  final RideQuote? bestQuote;
}

class HistoryRepository {
  HistoryRepository({required this.searchDao, required this.quoteDao});

  final SearchDao searchDao;
  final QuoteDao quoteDao;

  Future<List<HistoryEntry>> recent() async {
    final rows = await searchDao.recent(limit: 15);
    final entries = <HistoryEntry>[];
    for (final row in rows) {
      final id = row['id'] as String;
      final quotes = await quoteDao.findByQuery(id);
      final best = quotes.sortedBy<num>((q) => q.total).firstOrNull;
      entries.add(HistoryEntry(
        id: id,
        origin: row['origin'] as String,
        destination: row['destination'] as String,
        when: DateTime.fromMillisecondsSinceEpoch(row['when'] as int),
        bestQuote: best,
      ));
    }
    return entries;
  }
}
