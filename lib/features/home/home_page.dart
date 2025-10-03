import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../strings.dart';
import '../../providers.dart';
import 'recent_searches_list.dart';
import 'ride_search_form.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/history'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/role'),
          ),
        ],
      ),
      floatingActionButton: FutureBuilder(
        future: ref.read(settingsRepositoryProvider).getRole(),
        builder: (context, snapshot) {
          final isAdmin = snapshot.data == 'admin';
          if (!isAdmin) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () => context.push('/admin'),
            icon: const Icon(Icons.shield_outlined),
            label: const Text('Admin'),
          );
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          RideSearchForm(),
          SizedBox(height: 24),
          _SectionTitle(title: Strings.recentSearchesTitle),
          RecentSearchesList(),
          SizedBox(height: 24),
          _SectionTitle(title: Strings.hotelsComingSoon),
          _ComingSoonCard(),
          SizedBox(height: 16),
          _SectionTitle(title: Strings.retailComingSoon),
          _ComingSoonCard(),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ComingSoonCard extends StatelessWidget {
  const _ComingSoonCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(Strings.comingSoon),
            SizedBox(height: 4),
            Text('We\'re gearing up to launch this vertical soon.'),
          ],
        ),
      ),
    );
  }
}
