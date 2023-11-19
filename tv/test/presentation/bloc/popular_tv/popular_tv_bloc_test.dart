import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_popular_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_bloc.dart';

import 'popular_tv_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTv])
void main() {
  late PopularTvBloc bloc;
  late MockGetPopularTv mockGetPopularTv;

  setUp(() {
    mockGetPopularTv = MockGetPopularTv();
    bloc = PopularTvBloc(mockGetPopularTv);
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

  test('initial state should be empty', () {
    expect(bloc.state, PopularTvInitial());
  });

  blocTest<PopularTvBloc, PopularTvState>(
    'should emit [PopularTvLoading, PopularTvHasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => const Right(tTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadPopularTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularTvLoading(),
      const PopularTvHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockGetPopularTv.execute());
      return LoadPopularTv().props.contains(LoadPopularTv());
    },
  );

  blocTest<PopularTvBloc, PopularTvState>(
    'should emit [PopularTvLoading, PopularTvError] when get data is unsuccessful',
    build: () {
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadPopularTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularTvLoading(),
      const PopularTvError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetPopularTv.execute());
      return LoadPopularTv().props.contains(LoadPopularTv());
    },
  );

  blocTest<PopularTvBloc, PopularTvState>(
    'should emit [PopularTvLoading, PopularTvNoData] when data is empty',
    build: () {
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => const Right(<Tv>[]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadPopularTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularTvLoading(),
      const PopularTvNoData('No Data'),
    ],
    verify: (bloc) {
      verify(mockGetPopularTv.execute());
      return LoadPopularTv().props.contains(LoadPopularTv());
    },
  );

  blocTest<PopularTvBloc, PopularTvState>(
    'should emit [PopularTvLoading, PopularTvError] when data is unsuccessful',
    build: () {
      when(mockGetPopularTv.execute()).thenAnswer(
          (_) async => const Left(ConnectionFailure('No Connection')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadPopularTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularTvLoading(),
      const PopularTvError('No Connection'),
    ],
    verify: (bloc) {
      verify(mockGetPopularTv.execute());
      return LoadPopularTv().props.contains(LoadPopularTv());
    },
  );
}
