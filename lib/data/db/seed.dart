import 'package:uuid/uuid.dart';

import '../models/ride_models.dart';
import 'drift_database.dart';

class DatabaseSeeder {
  DatabaseSeeder(this.db);

  final OptzDatabase db;
  final _uuid = const Uuid();

  Future<void> reseed() async {
    await db.clearAll();
    await db.setSetting('happyHour', 'false');
    await db.setSetting('city', 'Coimbatore');

    final samples = [
      ['RS Puram', 'CJB Airport'],
      ['Peelamedu', 'Gandhipuram'],
      ['Town Hall', 'Brookefields'],
    ];

    for (final sample in samples) {
      final queryId = _uuid.v4();
      await db.insertSearch(
        id: queryId,
        origin: sample[0],
        destination: sample[1],
        when: DateTime.now().millisecondsSinceEpoch,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      await db.insertQuotes(queryId, [
        RideQuote(
          provider: ProviderType.ola,
          etaMin: 8,
          base: 120,
          fees: 40,
          total: 160,
          rating: 4.3,
        ),
        RideQuote(
          provider: ProviderType.uber,
          etaMin: 9,
          base: 130,
          fees: 35,
          total: 165,
          rating: 4.5,
        ),
      ]);
    }
  }
}
