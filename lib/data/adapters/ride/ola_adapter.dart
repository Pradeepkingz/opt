import 'dart:math';

import '../../models/ride_models.dart';
import 'ride_adapter.dart';

class OlaRideAdapter implements RideAdapter {
  const OlaRideAdapter();

  @override
  String get name => 'Ola';

  bool _isRushHour(DateTime time) {
    final hour = time.hour;
    return (hour >= 8 && hour < 10) || (hour >= 18 && hour < 20);
  }

  @override
  Future<List<RideQuote>> search(RideSearchInput input, {bool happyHour = false}) async {
    final ctx = RidePricingContext(input, happyHour);
    final base = 110 + deterministicJitter(ctx.seed, 0, 20);
    var fees = 30 + deterministicJitter('${ctx.seed}-fees', 0, 10);
    if (_isRushHour(input.when)) {
      fees = (fees * 1.2).round();
    }
    final total = _applyHappyHour(ctx, base + fees);
    final eta = max(4, 8 + deterministicJitter('${ctx.seed}-eta', -2, 3));
    return [
      RideQuote(
        provider: ProviderType.ola,
        etaMin: eta,
        base: base,
        fees: fees,
        total: total,
        rating: 4.2 + deterministicJitter('${ctx.seed}-rating', 0, 7) / 20,
        badge: _isRushHour(input.when) ? 'Peak window' : null,
      ),
    ];
  }

  int _applyHappyHour(RidePricingContext ctx, int total) {
    if (!ctx.happyHour) return total;
    return (total * 0.95).round();
  }
}
