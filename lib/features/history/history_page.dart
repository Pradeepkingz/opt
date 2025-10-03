import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/utils/currency.dart';
import '../../common/utils/time_fmt.dart';
import '../../providers.dart';
import '../../strings.dart';
import '../rides/controllers/ride_quotes_controller.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.historyTitle)),
      body: FutureBuilder(
        future: ref.read(historyRepositoryProvider).recent(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final entries = snapshot.data!;
          if (entries.isEmpty) {
            return const Center(child: Text(Strings.emptyRecentSearches));
          }
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              final quote = entry.bestQuote;
              return ListTile(
                title: Text('${entry.origin} → ${entry.destination}'),
                subtitle: Text('When: ${formatDateTime(entry.when)}'),
                trailing: quote == null
                    ? null
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(quote.provider.label,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(formatCurrency(quote.total)),
                        ],
                      ),
                onTap: () async {
                  await ref
                      .read(rideQuotesControllerProvider.notifier)
                      .loadFromHistory(entry.id);
                  if (context.mounted) {
                    context.go('/compare');
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
