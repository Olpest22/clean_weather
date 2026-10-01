part of 'city_search_bloc.dart';

enum CitySearchStatus { initial, loading, success, failure }

final class CitySearchState extends Equatable {
  const CitySearchState({
    this.status = CitySearchStatus.initial,
    this.query = '',
    this.locations = const [],
    this.errorMessage,
  });

  final CitySearchStatus status;
  final String query;
  final List<Location> locations;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, query, locations, errorMessage];
}
