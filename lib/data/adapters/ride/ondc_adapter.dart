import '../../models/ride_models.dart';
import 'ride_adapter.dart';

class OndcRideAdapter implements RideAdapter {
  const OndcRideAdapter();

  @override
  String get name => 'ONDC';

  @override
  Future<List<RideQuote>> search(RideSearchInput input, {bool happyHour = false}) async {
    final ctx = RidePricingContext(input, happyHour);
    final base = 140 + deterministicJitter('${ctx.seed}-base', -10, 10);
    final fees = 20 + deterministicJitter('${ctx.seed}-fees', 0, 8);
    final total = _applyHappyHour(ctx, base + fees);
    final eta = 10 + deterministicJitter('${ctx.seed}-eta', -2, 3);
    return [
      RideQuote(
        provider: ProviderType.ondc,
        etaMin: eta,
        base: base,
        fees: fees,
        total: total,
        rating: 4.0 + deterministicJitter('${ctx.seed}-rating', 0, 9) / 20,
        badge: 'Open mobility',
      ),
    ];
  }

  int _applyHappyHour(RidePricingContext ctx, int total) {
    if (!ctx.happyHour) return total;
    return (total * 0.95).round();
  }
}
