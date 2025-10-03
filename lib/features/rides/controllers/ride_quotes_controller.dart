import 'package:riverpod/riverpod.dart';

import '../../../data/models/ride_models.dart';
import '../../../data/repos/ride_repo.dart';
import '../../../strings.dart';
import 'ride_search_controller.dart';

enum RideSortOption { total, eta, rating }

class RideQuotesState {
  RideQuotesState({
    required this.queryId,
    required this.quotes,
    required this.sort,
    required this.offline,
    this.message,
  });

  final String queryId;
  final List<RideQuote> quotes;
  final RideSortOption sort;
  final bool offline;
  final String? message;

  RideQuotesState copyWith({
    String? queryId,
    List<RideQuote>? quotes,
    RideSortOption? sort,
    bool? offline,
    String? message,
  }) {
    return RideQuotesState(
      queryId: queryId ?? this.queryId,
      quotes: quotes ?? this.quotes,
      sort: sort ?? this.sort,
      offline: offline ?? this.offline,
      message: message,
    );
  }
}

class RideQuotesController extends AutoDisposeAsyncNotifier<RideQuotesState?> {
  @override
  Future<RideQuotesState?> build() async => null;

  RideRepository get _repo => ref.read(rideRepositoryProvider);

  Future<void> fetch(RideSearchInput input) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await _repo.search(input);
      final sorted = _sortQuotes(result.quotes, RideSortOption.total);
      return RideQuotesState(
        queryId: result.queryId,
        quotes: sorted,
        sort: RideSortOption.total,
        offline: result.isOffline,
        message: result.isOffline ? Strings.offlineBanner : null,
      );
    });
  }

  Future<void> loadFromHistory(String queryId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await _repo.fromHistory(queryId);
      final sorted = _sortQuotes(result.quotes, RideSortOption.total);
      return RideQuotesState(
        queryId: result.queryId,
        quotes: sorted,
        sort: RideSortOption.total,
        offline: result.isOffline,
        message: result.isOffline ? Strings.offlineBanner : null,
      );
    });
  }

  void changeSort(RideSortOption option) {
    final current = state.value;
    if (current == null) return;
    final sorted = _sortQuotes(current.quotes, option);
    state = AsyncData(current.copyWith(quotes: sorted, sort: option));
  }

  List<RideQuote> _sortQuotes(List<RideQuote> quotes, RideSortOption option) {
    final list = [...quotes];
    switch (option) {
      case RideSortOption.total:
        list.sort((a, b) => a.total.compareTo(b.total));
        break;
      case RideSortOption.eta:
        list.sort((a, b) => a.etaMin.compareTo(b.etaMin));
        break;
      case RideSortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return list;
  }
}

final rideQuotesControllerProvider = AutoDisposeAsyncNotifierProvider<
    RideQuotesController, RideQuotesState?>(RideQuotesController.new);
