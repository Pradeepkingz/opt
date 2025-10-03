// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'ride_models.dart';

Map<String, dynamic> _$RideSearchInputToJson(RideSearchInput instance) => <String, dynamic>{
      'origin': instance.origin,
      'destination': instance.destination,
      'when': instance.when.toIso8601String(),
      'city': instance.city,
    };

RideSearchInput _$RideSearchInputFromJson(Map<String, dynamic> json) => RideSearchInput(
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      when: DateTime.parse(json['when'] as String),
      city: json['city'] as String,
    );

Map<String, dynamic> _$RideQuoteToJson(RideQuote instance) => <String, dynamic>{
      'provider': instance.provider.name,
      'etaMin': instance.etaMin,
      'base': instance.base,
      'fees': instance.fees,
      'total': instance.total,
      'rating': instance.rating,
      'badge': instance.badge,
      'isStale': instance.isStale,
    };

RideQuote _$RideQuoteFromJson(Map<String, dynamic> json) => RideQuote(
      provider: ProviderType.values
          .firstWhere((e) => e.name == json['provider'] as String),
      etaMin: json['etaMin'] as int,
      base: json['base'] as int,
      fees: json['fees'] as int,
      total: json['total'] as int,
      rating: (json['rating'] as num).toDouble(),
      badge: json['badge'] as String?,
      isStale: json['isStale'] as bool? ?? false,
    );
