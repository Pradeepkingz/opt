import 'package:riverpod/riverpod.dart';

import 'data/db/daos.dart';
import 'data/db/drift_database.dart';
import 'data/db/seed.dart';
import 'data/repos/history_repo.dart';
import 'data/repos/ride_repo.dart';
import 'data/repos/settings_repo.dart';

final databaseProvider = Provider<OptzDatabase>((ref) {
  throw UnimplementedError('databaseProvider must be overridden');
});

final searchDaoProvider = Provider<SearchDao>((ref) {
  final db = ref.watch(databaseProvider);
  return SearchDao(db);
});

final quoteDaoProvider = Provider<QuoteDao>((ref) {
  final db = ref.watch(databaseProvider);
  return QuoteDao(db);
});

final settingsDaoProvider = Provider<SettingsDao>((ref) {
  final db = ref.watch(databaseProvider);
  return SettingsDao(db);
});

final logDaoProvider = Provider<AdapterLogDao>((ref) {
  final db = ref.watch(databaseProvider);
  return AdapterLogDao(db);
});

final rideRepositoryProvider = Provider<RideRepository>((ref) {
  return RideRepository(
    searchDao: ref.watch(searchDaoProvider),
    quoteDao: ref.watch(quoteDaoProvider),
    settingsDao: ref.watch(settingsDaoProvider),
    logDao: ref.watch(logDaoProvider),
  );
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository(
    searchDao: ref.watch(searchDaoProvider),
    quoteDao: ref.watch(quoteDaoProvider),
  );
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(dao: ref.watch(settingsDaoProvider));
});

final databaseSeederProvider = Provider<DatabaseSeeder>((ref) {
  return DatabaseSeeder(ref.watch(databaseProvider));
});
