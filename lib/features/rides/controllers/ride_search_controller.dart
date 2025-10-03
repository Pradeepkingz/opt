import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import '../../../data/adapters/geo/geocode_stub.dart';
import '../../../data/models/ride_models.dart';

enum RideTimeOption { now, later }

class RideSearchState {
  RideSearchState({
    this.origin = '',
    this.destination = '',
    this.when = RideTimeOption.now,
    this.departure,
    this.error,
  });

  final String origin;
  final String destination;
  final RideTimeOption when;
  final DateTime? departure;
  final String? error;

  RideSearchState copyWith({
    String? origin,
    String? destination,
    RideTimeOption? when,
    DateTime? departure,
    String? error,
  }) {
    return RideSearchState(
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      when: when ?? this.when,
      departure: departure ?? this.departure,
      error: error,
    );
  }

  bool get isValid => origin.isNotEmpty && destination.isNotEmpty;

  DateTime get scheduledTime =>
      when == RideTimeOption.now ? DateTime.now() : (departure ?? DateTime.now().add(const Duration(minutes: 15)));
}

class RideSearchController extends StateNotifier<RideSearchState> {
  RideSearchController(this._geoStub) : super(RideSearchState());

  final GeocodeStub _geoStub;

  void setOrigin(String value) {
    state = state.copyWith(origin: value, error: null);
  }

  void setDestination(String value) {
    state = state.copyWith(destination: value, error: null);
  }

  void setWhen(RideTimeOption option) {
    state = state.copyWith(when: option, departure: option == RideTimeOption.now ? null : state.departure);
  }

  void setDeparture(DateTime value) {
    state = state.copyWith(departure: value);
  }

  void validate() {
    if (!state.isValid) {
      state = state.copyWith(error: 'Please fill origin and destination');
    }
  }

  List<String> suggestions(String query) => _geoStub.suggestions(query);

  RideSearchInput buildInput(String city) {
    return RideSearchInput(
      origin: state.origin,
      destination: state.destination,
      when: state.scheduledTime,
      city: city,
    );
  }
}

final rideSearchControllerProvider =
    StateNotifierProvider<RideSearchController, RideSearchState>((ref) {
  return RideSearchController(const GeocodeStub());
});
