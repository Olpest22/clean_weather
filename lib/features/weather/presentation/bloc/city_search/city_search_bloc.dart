import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/result/result.dart';
import '../../../domain/entities/location.dart';
import '../../../domain/usecases/search_locations.dart';

part 'city_search_event.dart';
part 'city_search_state.dart';

/// BLoC поиска городов с задержкой (debounce) ввода.
class CitySearchBloc extends Bloc<CitySearchEvent, CitySearchState> {
  CitySearchBloc({
    required SearchLocations searchLocations,
    this.debounceDuration = const Duration(milliseconds: 400),
  })  : _searchLocations = searchLocations,
        super(const CitySearchState()) {
    // restartable отменяет обработку предыдущего ввода, когда приходит новый.
    // Вместе с задержкой ниже это даёт debounce без сторонних пакетов.
    on<CitySearchQueryChanged>(_onQueryChanged, transformer: restartable());
  }

  final SearchLocations _searchLocations;

  /// Пауза после ввода, после которой отправляется запрос.
  final Duration debounceDuration;

  Future<void> _onQueryChanged(
    CitySearchQueryChanged event,
    Emitter<CitySearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.length < SearchLocations.minQueryLength) {
      emit(CitySearchState(query: query));
      return;
    }

    emit(CitySearchState(status: CitySearchStatus.loading, query: query));

    await Future<void>.delayed(debounceDuration);
    // Пока ждали, пользователь продолжил ввод — этот обработчик отменён.
    if (emit.isDone) return;

    final result = await _searchLocations(query);
    if (emit.isDone) return;

    switch (result) {
      case Success(:final data):
        emit(CitySearchState(
          status: CitySearchStatus.success,
          query: query,
          locations: data,
        ));
      case Failed(:final failure):
        emit(CitySearchState(
          status: CitySearchStatus.failure,
          query: query,
          errorMessage: failure.message,
        ));
    }
  }
}
