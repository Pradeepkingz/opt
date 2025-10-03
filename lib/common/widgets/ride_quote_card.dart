import 'package:flutter/material.dart';
import '../../common/utils/currency.dart';
import '../../common/utils/result_badges.dart';
import '../../common/utils/time_fmt.dart';
import '../../data/models/ride_models.dart';

class RideQuoteCard extends StatelessWidget {
  const RideQuoteCard({
    super.key,
    required this.quote,
    required this.onBook,
  });

  final RideQuote quote;
  final VoidCallback onBook;

  Color _providerColor(BuildContext context) {
    switch (quote.provider) {
      case ProviderType.ola:
        return const Color(0xFF22C55E);
      case ProviderType.uber:
        return const Color(0xFF111827);
      case ProviderType.rapido:
        return const Color(0xFFF97316);
      case ProviderType.ondc:
        return const Color(0xFF2563EB);
    }
  }

  @override
  Widget build(BuildContext context) {
    final badge = resolveBadge(quote);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _providerColor(context),
                  child: Text(
                    quote.provider.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quote.provider.label,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(formatEta(quote.etaMin)),
                          const SizedBox(width: 12),
                          Icon(Icons.star_rounded,
                              size: 16, color: Colors.amber[600]),
                          const SizedBox(width: 4),
                          Text(quote.rating.toStringAsFixed(1)),
                        ],
                      ),
                    ],
                  ),
                ),
                if (quote.isStale)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.orange[100],
                    ),
                    child: const Text(
                      'Stale',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              formatCurrency(quote.total),
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text('Base ₹${quote.base} + Fees ₹${quote.fees}'),
                ),
                if (badge != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onBook,
                child: Text(
                  'Book on provider',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
