import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_router.dart';
import 'data/db/drift_database.dart';
import 'data/db/seed.dart';
import 'data/db/daos.dart';
import 'data/repos/settings_repo.dart';
import 'providers.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await OptzDatabase.open();
  final settingsDao = SettingsDao(database);
  final settingsRepo = SettingsRepository(dao: settingsDao);
  await settingsRepo.seedPrefs();
  final seeder = DatabaseSeeder(database);
  final recent = await database.recentSearches(limit: 1);
  if (recent.isEmpty) {
    await seeder.reseed();
  }

  runApp(ProviderScope(
    overrides: [
      databaseProvider.overrideWithValue(database),
    ],
    child: const OptzApp(),
  ));
}

class OptzApp extends ConsumerWidget {
  const OptzApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'Optz',
      theme: AppTheme.light(),
      routerConfig: router,
    );
  }
}
