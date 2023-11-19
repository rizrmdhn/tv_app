import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_on_the_air_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/on_the_air/on_the_air_bloc.dart';

import 'on_the_air_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirTv])
void main() {
  late OnTheAirBloc bloc;
  late MockGetOnTheAirTv mockGetOnTheAirTv;

  setUp(() {
    mockGetOnTheAirTv = MockGetOnTheAirTv();
    bloc = OnTheAirBloc(mockGetOnTheAirTv);
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
    expect(bloc.state, OnTheAirInitial());
  });

  blocTest<OnTheAirBloc, OnTheAirState>(
    'should emit [OnTheAirLoading, OnTheAirHasData] when data is gotten successfully',
    build: () {
      when(mockGetOnTheAirTv.execute())
          .thenAnswer((_) async => const Right(tTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadOnTheAirTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      OnTheAirLoading(),
      const OnTheAirHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockGetOnTheAirTv.execute());
      return LoadOnTheAirTv().props.contains(LoadOnTheAirTv());
    },
  );

  blocTest<OnTheAirBloc, OnTheAirState>(
    'should emit [OnTheAirLoading, OnTheAirError] when get data is unsuccessful',
    build: () {
      when(mockGetOnTheAirTv.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadOnTheAirTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      OnTheAirLoading(),
      const OnTheAirError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetOnTheAirTv.execute());
      return LoadOnTheAirTv().props.contains(LoadOnTheAirTv());
    },
  );

  blocTest<OnTheAirBloc, OnTheAirState>(
    'should emit [OnTheAirLoading, OnTheAirNoData] when data is empty',
    build: () {
      when(mockGetOnTheAirTv.execute())
          .thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadOnTheAirTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      OnTheAirLoading(),
      const OnTheAirNoData('No Data'),
    ],
    verify: (bloc) {
      verify(mockGetOnTheAirTv.execute());
      return LoadOnTheAirTv().props.contains(LoadOnTheAirTv());
    },
  );

  blocTest<OnTheAirBloc, OnTheAirState>(
    'should emit [OnTheAirLoading, OnTheAirError] when get data is unsuccessful',
    build: () {
      when(mockGetOnTheAirTv.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadOnTheAirTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      OnTheAirLoading(),
      const OnTheAirError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetOnTheAirTv.execute());
      return LoadOnTheAirTv().props.contains(LoadOnTheAirTv());
    },
  );
}
