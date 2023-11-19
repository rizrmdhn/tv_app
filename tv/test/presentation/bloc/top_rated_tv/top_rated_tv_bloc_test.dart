import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_top_rated_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/top_rated_tv/top_rated_tv_bloc.dart';

import 'top_rated_tv_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTv])
void main() {
  late TopRatedTvBloc bloc;
  late MockGetTopRatedTv mockGetTopRatedTv;

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
    bloc = TopRatedTvBloc(mockGetTopRatedTv);
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
    expect(bloc.state, TopRatedTvInitial());
  });

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'should emit [TopRatedTvLoading, TopRatedTvLoaded] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => const Right(tTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTopRatedTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TopRatedTvLoading(),
      const TopRatedTvHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTv.execute());
      return LoadTopRatedTv().props.contains(LoadTopRatedTv());
    },
  );

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'should emit [TopRatedTvLoading, TopRatedTvError] when get data is unsuccessful',
    build: () {
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTopRatedTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TopRatedTvLoading(),
      const TopRatedTvError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTv.execute());
      return LoadTopRatedTv().props.contains(LoadTopRatedTv());
    },
  );

  blocTest<TopRatedTvBloc, TopRatedTvState>(
    'should emit [TopRatedTvLoading, TopRatedTvNoData] when data is empty',
    build: () {
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTopRatedTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TopRatedTvLoading(),
      const TopRatedTvNoData('No Data'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTv.execute());
      return LoadTopRatedTv().props.contains(LoadTopRatedTv());
    },
  );
}
