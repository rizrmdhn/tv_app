import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/search_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/search_tv/search_tv_bloc.dart';

import 'search_tv_bloc_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late SearchTvBloc searchTvBloc;
  late MockSearchTv mockSearchTv;

  setUp(() {
    mockSearchTv = MockSearchTv();
    searchTvBloc = SearchTvBloc(mockSearchTv);
  });

  const tTv = Tv(
    adult: false,
    backdropPath: '/backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [1, 2],
    id: 1,
    name: 'name',
    originalCountry: ['originCountry'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: '/posterPath',
    voteAverage: 1.0,
    voteCount: 1,
  );
  const tTvList = <Tv>[tTv];
  const tQuery = 'spy';

  test('initial state should be empty', () {
    expect(searchTvBloc.state, SearchEmpty());
  });

  blocTest<SearchTvBloc, SearchState>(
    'should emit [SearchLoading, SearchLoaded] when data is gotten successfully',
    build: () {
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => const Right(tTvList));
      return searchTvBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      const SearchHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockSearchTv.execute(tQuery));
      return OnQueryChanged(tQuery).props.contains(tQuery);
    },
  );

  blocTest<SearchTvBloc, SearchState>(
    'should emit [SearchLoading, SearchError] when get data is unsuccessful',
    build: () {
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return searchTvBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      const SearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTv.execute(tQuery));
    },
  );

  blocTest<SearchTvBloc, SearchState>(
    'should emit [SearchLoading, SearchEmpty] when query is empty',
    build: () {
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => const Right(tTvList));
      return searchTvBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged('')),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      QueryEmpty(),
    ],
    verify: (bloc) {
      verifyNever(mockSearchTv.execute(tQuery));
    },
  );

  blocTest<SearchTvBloc, SearchState>(
    'should emit [SearchLoading, SearchNoData] when data is empty',
    build: () {
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => const Right([]));
      return searchTvBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchNoData(),
    ],
    verify: (bloc) {
      verify(mockSearchTv.execute(tQuery));
    },
  );
}
