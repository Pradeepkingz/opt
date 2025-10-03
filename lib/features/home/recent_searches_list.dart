import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/utils/currency.dart';
import '../../common/utils/time_fmt.dart';
import '../../providers.dart';
import '../../strings.dart';
import '../rides/controllers/ride_quotes_controller.dart';

class RecentSearchesList extends ConsumerWidget {
  const RecentSearchesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(historyRepositoryProvider).recent(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final entries = snapshot.data!;
        if (entries.isEmpty) {
          return const Text(Strings.emptyRecentSearches);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: entries.map((entry) {
            return ListTile(
              title: Text('${entry.origin} → ${entry.destination}'),
              subtitle: Text('When: ${formatDateTime(entry.when)}'),
              trailing: entry.bestQuote == null
                  ? const SizedBox.shrink()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(entry.bestQuote!.provider.label,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(formatCurrency(entry.bestQuote!.total)),
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
          }).toList(),
        );
      },
    );
  }
}
