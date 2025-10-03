import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers.dart';
import '../../strings.dart';
import 'admin_tiles.dart';
import 'logs_viewer.dart';

class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({super.key});

  @override
  ConsumerState<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage> {
  bool _loading = false;
  bool _happyHour = false;
  int _searches = 0;
  double _avgQuotes = 0;
  String _role = 'user';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(settingsRepositoryProvider);
    final settings = await repo.happyHour();
    final role = await repo.getRole();
    final searches = await ref.read(searchDaoProvider).recent(limit: 30);
    final quotes = <int>[];
    for (final row in searches) {
      final list = await ref.read(quoteDaoProvider).findByQuery(row['id'] as String);
      quotes.add(list.length);
    }
    setState(() {
      _happyHour = settings;
      _searches = searches.length;
      _avgQuotes = quotes.isEmpty ? 0 : quotes.reduce((a, b) => a + b) / quotes.length;
      _role = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_role != 'admin') {
      return const Scaffold(
        body: Center(
          child: Text('Switch to admin role to access controls.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text(Strings.adminTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: const Text(Strings.happyHour),
                    subtitle: Text(_happyHour ? Strings.happyHourOn : Strings.happyHourOff),
                    value: _happyHour,
                    onChanged: (value) async {
                      setState(() => _loading = true);
                      await ref.read(settingsRepositoryProvider).toggleHappyHour(value);
                      setState(() {
                        _happyHour = value;
                        _loading = false;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      setState(() => _loading = true);
                      await ref.read(databaseSeederProvider).reseed();
                      await _load();
                      setState(() => _loading = false);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text(Strings.reseed),
                  ),
                  const SizedBox(height: 24),
                  const Text(Strings.analytics, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  AdminMetricTile(
                    label: Strings.analyticsInstalls,
                    value: '1,204',
                    icon: Icons.phone_android,
                  ),
                  AdminMetricTile(
                    label: Strings.analyticsSearchesToday,
                    value: _searches.toString(),
                    icon: Icons.search,
                  ),
                  AdminMetricTile(
                    label: Strings.analyticsAvgQuotes,
                    value: _avgQuotes.toStringAsFixed(1),
                    icon: Icons.directions_car,
                  ),
                  AdminMetricTile(
                    label: Strings.analyticsHappyHour,
                    value: _happyHour ? 'ON' : 'OFF',
                    icon: Icons.local_bar,
                  ),
                  const SizedBox(height: 16),
                  const Expanded(child: LogsViewer()),
                ],
              ),
            ),
    );
  }
}
