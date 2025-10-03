// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'ride_models.dart';

@immutable
abstract class RideSearchInput with DiagnosticableTreeMixin {
  const factory RideSearchInput({
    required String origin,
    required String destination,
    required DateTime when,
    required String city,
  }) = _RideSearchInput;

  const RideSearchInput._();

  String get origin;
  String get destination;
  DateTime get when;
  String get city;

  RideSearchInput copyWith({
    String? origin,
    String? destination,
    DateTime? when,
    String? city,
  });

  Map<String, dynamic> toJson();
}

class _RideSearchInput extends RideSearchInput {
  const _RideSearchInput({
    required this.origin,
    required this.destination,
    required this.when,
    required this.city,
  }) : super._();

  @override
  final String origin;
  @override
  final String destination;
  @override
  final DateTime when;
  @override
  final String city;

  @override
  Map<String, dynamic> toJson() => _$RideSearchInputToJson(this);

  @override
  RideSearchInput copyWith({
    Object? origin = _sentinel,
    Object? destination = _sentinel,
    Object? when = _sentinel,
    Object? city = _sentinel,
  }) {
    return _RideSearchInput(
      origin: origin == _sentinel ? this.origin : origin as String,
      destination:
          destination == _sentinel ? this.destination : destination as String,
      when: when == _sentinel ? this.when : when as DateTime,
      city: city == _sentinel ? this.city : city as String,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RideSearchInput &&
            other.origin == origin &&
            other.destination == destination &&
            other.when == when &&
            other.city == city);
  }

  @override
  int get hashCode => Object.hash(runtimeType, origin, destination, when, city);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('origin', origin))
      ..add(StringProperty('destination', destination))
      ..add(DiagnosticsProperty<DateTime>('when', when))
      ..add(StringProperty('city', city));
  }
}

@immutable
abstract class RideQuote with DiagnosticableTreeMixin {
  const factory RideQuote({
    required ProviderType provider,
    required int etaMin,
    required int base,
    required int fees,
    required int total,
    required double rating,
    String? badge,
    bool isStale,
  }) = _RideQuote;

  const RideQuote._();

  ProviderType get provider;
  int get etaMin;
  int get base;
  int get fees;
  int get total;
  double get rating;
  String? get badge;
  bool get isStale;

  RideQuote copyWith({
    ProviderType? provider,
    int? etaMin,
    int? base,
    int? fees,
    int? total,
    double? rating,
    String? badge,
    bool? isStale,
  });

  Map<String, dynamic> toJson();
}

class _RideQuote extends RideQuote {
  const _RideQuote({
    required this.provider,
    required this.etaMin,
    required this.base,
    required this.fees,
    required this.total,
    required this.rating,
    this.badge,
    this.isStale = false,
  }) : super._();

  @override
  final ProviderType provider;
  @override
  final int etaMin;
  @override
  final int base;
  @override
  final int fees;
  @override
  final int total;
  @override
  final double rating;
  @override
  final String? badge;
  @override
  final bool isStale;

  @override
  Map<String, dynamic> toJson() => _$RideQuoteToJson(this);

  @override
  RideQuote copyWith({
    Object? provider = _sentinel,
    Object? etaMin = _sentinel,
    Object? base = _sentinel,
    Object? fees = _sentinel,
    Object? total = _sentinel,
    Object? rating = _sentinel,
    Object? badge = _sentinel,
    Object? isStale = _sentinel,
  }) {
    return _RideQuote(
      provider: provider == _sentinel ? this.provider : provider as ProviderType,
      etaMin: etaMin == _sentinel ? this.etaMin : etaMin as int,
      base: base == _sentinel ? this.base : base as int,
      fees: fees == _sentinel ? this.fees : fees as int,
      total: total == _sentinel ? this.total : total as int,
      rating: rating == _sentinel ? this.rating : rating as double,
      badge: badge == _sentinel ? this.badge : badge as String?,
      isStale: isStale == _sentinel ? this.isStale : isStale as bool,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RideQuote &&
            other.provider == provider &&
            other.etaMin == etaMin &&
            other.base == base &&
            other.fees == fees &&
            other.total == total &&
            other.rating == rating &&
            other.badge == badge &&
            other.isStale == isStale);
  }

  @override
  int get hashCode => Object.hash(runtimeType, provider, etaMin, base, fees,
      total, rating, badge, isStale);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty('provider', provider))
      ..add(IntProperty('etaMin', etaMin))
      ..add(IntProperty('base', base))
      ..add(IntProperty('fees', fees))
      ..add(IntProperty('total', total))
      ..add(DoubleProperty('rating', rating))
      ..add(StringProperty('badge', badge))
      ..add(FlagProperty('isStale', value: isStale, ifTrue: 'stale'));
  }
}

const _sentinel = Object();
