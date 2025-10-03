import '../../data/models/ride_models.dart';

String? resolveBadge(RideQuote quote) {
  if (quote.badge != null) return quote.badge;
  switch (quote.provider) {
    case ProviderType.ola:
      return quote.fees > quote.base * 0.3 ? 'Peak pricing' : null;
    case ProviderType.uber:
      return quote.badge;
    case ProviderType.rapido:
      return quote.etaMin <= 5 ? 'Quick pickup' : null;
    case ProviderType.ondc:
      return 'Standardised fares';
  }
}
