import 'package:bloc_test/bloc_test.dart';
import 'package:clean_weather/core/error/failures.dart';
import 'package:clean_weather/core/result/result.dart';
import 'package:clean_weather/features/weather/domain/entities/location.dart';
import 'package:clean_weather/features/weather/domain/usecases/search_locations.dart';
import 'package:clean_weather/features/weather/presentation/bloc/city_search/city_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../fixtures.dart';

class MockSearchLocations extends Mock implements SearchLocations {}

void main() {
  late MockSearchLocations searchLocations;

  setUp(() => searchLocations = MockSearchLocations());

  CitySearchBloc buildBloc({Duration debounce = Duration.zero}) =>
      CitySearchBloc(searchLocations: searchLocations, debounceDuration: debounce);

  blocTest<CitySearchBloc, CitySearchState>(
    'находит города по запросу',
    setUp: () => when(() => searchLocations('Москва'))
        .thenAnswer((_) async => const Success<List<Location>>([tLocation])),
    build: buildBloc,
    act: (bloc) => bloc.add(const CitySearchQueryChanged('Москва')),
    expect: () => const [
      CitySearchState(status: CitySearchStatus.loading, query: 'Москва'),
      CitySearchState(
        status: CitySearchStatus.success,
        query: 'Москва',
        locations: [tLocation],
      ),
    ],
  );

  blocTest<CitySearchBloc, CitySearchState>(
    'ошибка поиска переводит в failure',
    setUp: () => when(() => searchLocations('Москва')).thenAnswer(
      (_) async => const Failed<List<Location>>(NetworkFailure('Нет сети')),
    ),
    build: buildBloc,
    act: (bloc) => bloc.add(const CitySearchQueryChanged('Москва')),
    expect: () => const [
      CitySearchState(status: CitySearchStatus.loading, query: 'Москва'),
      CitySearchState(
        status: CitySearchStatus.failure,
        query: 'Москва',
        errorMessage: 'Нет сети',
      ),
    ],
  );

  blocTest<CitySearchBloc, CitySearchState>(
    'debounce: при быстром вводе запрос уходит только для последнего текста',
    setUp: () => when(() => searchLocations(any()))
        .thenAnswer((_) async => const Success<List<Location>>([tLocation])),
    build: () => buildBloc(debounce: const Duration(milliseconds: 50)),
    act: (bloc) => bloc
      ..add(const CitySearchQueryChanged('Мо'))
      ..add(const CitySearchQueryChanged('Москва')),
    wait: const Duration(milliseconds: 150),
    verify: (_) {
      verifyNever(() => searchLocations('Мо'));
      verify(() => searchLocations('Москва')).called(1);
    },
  );
}
