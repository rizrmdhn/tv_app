import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_airing_today_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/on_airing_today/on_airing_today_bloc.dart';

import 'on_airing_today_bloc_test.mocks.dart';

@GenerateMocks([GetAiringTodayTv])
void main() {
  late OnAiringTodayBloc bloc;
  late MockGetAiringTodayTv mockGetAiringTodayTv;

  setUp(() {
    mockGetAiringTodayTv = MockGetAiringTodayTv();
    bloc = OnAiringTodayBloc(mockGetAiringTodayTv);
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
    expect(bloc.state, OnAiringTodayInitial());
  });

  blocTest<OnAiringTodayBloc, OnAiringTodayState>(
    'should emit [OnAiringTodayLoading, OnAiringTodayHasData] when data is gotten successfully',
    build: () {
      when(mockGetAiringTodayTv.execute())
          .thenAnswer((_) async => const Right(tTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadOnAiringTodayTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      OnAiringTodayLoading(),
      const OnAiringTodayHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTv.execute());
      return LoadOnAiringTodayTv().props.contains(LoadOnAiringTodayTv());
    },
  );

  blocTest<OnAiringTodayBloc, OnAiringTodayState>(
    'should emit [OnAiringTodayLoading, OnAiringTodayError] when get data is unsuccessful',
    build: () {
      when(mockGetAiringTodayTv.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadOnAiringTodayTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      OnAiringTodayLoading(),
      const OnAiringTodayError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTv.execute());
    },
  );

  blocTest<OnAiringTodayBloc, OnAiringTodayState>(
    'should emit [OnAiringTodayLoading, OnAiringTodayNoData] when get data is unsuccessful',
    build: () {
      when(mockGetAiringTodayTv.execute())
          .thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadOnAiringTodayTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      OnAiringTodayLoading(),
      const OnAiringTodayNoData('No Data'),
    ],
    verify: (bloc) {
      verify(mockGetAiringTodayTv.execute());
    },
  );
}
