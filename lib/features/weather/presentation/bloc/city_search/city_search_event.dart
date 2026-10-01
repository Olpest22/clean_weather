part of 'city_search_bloc.dart';

sealed class CitySearchEvent extends Equatable {
  const CitySearchEvent();

  @override
  List<Object?> get props => [];
}

/// Пользователь изменил текст в поле поиска.
final class CitySearchQueryChanged extends CitySearchEvent {
  const CitySearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
