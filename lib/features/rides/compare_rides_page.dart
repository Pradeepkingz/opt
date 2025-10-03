import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/widgets/empty_state.dart';
import '../../common/widgets/ride_quote_card.dart';
import '../../common/widgets/skeletons.dart';
import '../../common/widgets/sort_chips.dart';
import '../../strings.dart';
import '../handoff/handoff_sheet.dart';
import 'controllers/ride_quotes_controller.dart';

class CompareRidesPage extends ConsumerWidget {
  const CompareRidesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rideQuotesControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.rideResultsTitle),
      ),
      body: state.when(
        data: (data) {
          if (data == null || data.quotes.isEmpty) {
            return const EmptyState(
              title: Strings.noQuotes,
              message: 'Try searching with a different route.',
            );
          }
          return Column(
            children: [
              if (data.message != null)
                Container(
                  width: double.infinity,
                  color: Colors.orange[100],
                  padding: const EdgeInsets.all(12),
                  child: Text(data.message!, style: const TextStyle(color: Colors.orange)),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SortChips(
                  labels: const [Strings.totalCost, Strings.eta, Strings.rating],
                  active: data.sort.index,
                  onSelected: (index) => ref
                      .read(rideQuotesControllerProvider.notifier)
                      .changeSort(RideSortOption.values[index]),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: data.quotes.length,
                  itemBuilder: (context, index) {
                    final quote = data.quotes[index];
                    return RideQuoteCard(
                      quote: quote,
                      onBook: () => _openHandoff(context, quote.provider.label),
                    );
                  },
                ),
              ),
            ],
          );
        },
        error: (error, stack) => EmptyState(
          title: 'We hit a snag',
          message: error.toString(),
          icon: Icons.error_outline,
        ),
        loading: () => const QuoteSkeletonList(),
      ),
    );
  }

  void _openHandoff(BuildContext context, String provider) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => HandoffSheet(provider: provider),
    );
  }
}
