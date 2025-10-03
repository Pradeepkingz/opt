import '../../models/ride_models.dart';
import 'ride_adapter.dart';

class UberRideAdapter implements RideAdapter {
  const UberRideAdapter();

  @override
  String get name => 'Uber';

  @override
  Future<List<RideQuote>> search(RideSearchInput input, {bool happyHour = false}) async {
    final ctx = RidePricingContext(input, happyHour);
    var base = 130 + deterministicJitter('${ctx.seed}-base', -10, 15);
    var fees = 28 + deterministicJitter('${ctx.seed}-fees', 0, 15);
    final hour = input.when.hour;
    var badge;
    if (hour >= 11 && hour <= 16) {
      badge = 'Coupon applied';
      base -= 20;
    }
    final total = _applyHappyHour(ctx, base + fees);
    final eta = 9 + deterministicJitter('${ctx.seed}-eta', -1, 2);
    return [
      RideQuote(
        provider: ProviderType.uber,
        etaMin: eta,
        base: base,
        fees: fees,
        total: total,
        rating: 4.3 + deterministicJitter('${ctx.seed}-rating', 0, 5) / 20,
        badge: badge,
      ),
    ];
  }

  int _applyHappyHour(RidePricingContext ctx, int total) {
    if (!ctx.happyHour) return total;
    return (total * 0.95).round();
  }
}
