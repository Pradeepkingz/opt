import '../../models/ride_models.dart';

abstract class RideAdapter {
  String get name;
  Future<List<RideQuote>> search(RideSearchInput input, {bool happyHour = false});
}

int _hashSeed(String value) {
  var hash = 0;
  for (final codeUnit in value.codeUnits) {
    hash = (hash * 31 + codeUnit) & 0x7fffffff;
  }
  return hash;
}

int deterministicJitter(String seed, int min, int max) {
  final hash = _hashSeed(seed);
  final range = max - min;
  return min + (hash % (range == 0 ? 1 : range));
}

class RidePricingContext {
  RidePricingContext(this.input, this.happyHour);

  final RideSearchInput input;
  final bool happyHour;

  String get seed => '${input.origin}-${input.destination}-${input.when.toIso8601String()}-${happyHour ? 'hh' : 'std'}';
}
