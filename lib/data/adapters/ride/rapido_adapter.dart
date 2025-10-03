import 'dart:math';

import '../../models/ride_models.dart';
import 'ride_adapter.dart';

class RapidoRideAdapter implements RideAdapter {
  const RapidoRideAdapter();

  @override
  String get name => 'Rapido';

  @override
  Future<List<RideQuote>> search(RideSearchInput input, {bool happyHour = false}) async {
    final ctx = RidePricingContext(input, happyHour);
    final base = 70 + deterministicJitter('${ctx.seed}-base', -5, 10);
    final fees = 10 + deterministicJitter('${ctx.seed}-fees', 0, 5);
    final total = _applyHappyHour(ctx, base + fees);
    final eta = max(3, 5 + deterministicJitter('${ctx.seed}-eta', -2, 1));
    return [
      RideQuote(
        provider: ProviderType.rapido,
        etaMin: eta,
        base: base,
        fees: fees,
        total: total,
        rating: 4.1 + deterministicJitter('${ctx.seed}-rating', 0, 6) / 20,
        badge: 'Best for short hops',
      ),
    ];
  }

  int _applyHappyHour(RidePricingContext ctx, int total) {
    if (!ctx.happyHour) return total;
    return (total * 0.95).round();
  }
}
