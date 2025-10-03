import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ride_models.freezed.dart';
part 'ride_models.g.dart';

enum ProviderType { ola, uber, rapido, ondc }

@immutable
class RideSearchInput {
  const RideSearchInput({
    required this.origin,
    required this.destination,
    required this.when,
    required this.city,
  });

  final String origin;
  final String destination;
  final DateTime when;
  final String city;

  RideSearchInput copyWith({
    String? origin,
    String? destination,
    DateTime? when,
    String? city,
  }) {
    return RideSearchInput(
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      when: when ?? this.when,
      city: city ?? this.city,
    );
  }

  Map<String, dynamic> toJson() => _$RideSearchInputToJson(this);

  factory RideSearchInput.fromJson(Map<String, dynamic> json) =>
      _$RideSearchInputFromJson(json);
}

@immutable
class RideQuote {
  const RideQuote({
    required this.provider,
    required this.etaMin,
    required this.base,
    required this.fees,
    required this.total,
    required this.rating,
    this.badge,
    this.isStale = false,
  });

  final ProviderType provider;
  final int etaMin;
  final int base;
  final int fees;
  final int total;
  final double rating;
  final String? badge;
  final bool isStale;

  RideQuote copyWith({
    ProviderType? provider,
    int? etaMin,
    int? base,
    int? fees,
    int? total,
    double? rating,
    String? badge,
    bool? isStale,
  }) {
    return RideQuote(
      provider: provider ?? this.provider,
      etaMin: etaMin ?? this.etaMin,
      base: base ?? this.base,
      fees: fees ?? this.fees,
      total: total ?? this.total,
      rating: rating ?? this.rating,
      badge: badge ?? this.badge,
      isStale: isStale ?? this.isStale,
    );
  }

  Map<String, dynamic> toJson() => _$RideQuoteToJson(this);

  factory RideQuote.fromJson(Map<String, dynamic> json) =>
      _$RideQuoteFromJson(json);
}

extension ProviderTypeX on ProviderType {
  String get label {
    switch (this) {
      case ProviderType.ola:
        return 'Ola';
      case ProviderType.uber:
        return 'Uber';
      case ProviderType.rapido:
        return 'Rapido';
      case ProviderType.ondc:
        return 'ONDC';
    }
  }
}
