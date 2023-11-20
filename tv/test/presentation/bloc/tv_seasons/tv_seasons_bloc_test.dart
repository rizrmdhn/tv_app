import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/usecases/get_tv_season.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/tv_seasons/tv_seasons_bloc.dart';

import 'tv_seasons_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeasons])
void main() {
  late TvSeasonsBloc bloc;
  late MockGetTvSeasons mockGetTvSeasons;

  setUp(() {
    mockGetTvSeasons = MockGetTvSeasons();
    bloc = TvSeasonsBloc(mockGetTvSeasons);
  });

  const tId = 1;
  final tTvSeason = Season(
    voteAverage: 1.0,
    airDate: DateTime.parse('2020-05-05'),
    episodeCount: 1,
    id: 1,
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    seasonNumber: 1,
  );

  test('initial state should be empty', () {
    expect(bloc.state, equals(TvSeasonsInitial()));
  });

  blocTest<TvSeasonsBloc, TvSeasonsState>(
    'should emit [loading, loaded] when data is gotten successfully',
    build: () {
      when(mockGetTvSeasons.execute(tId))
          .thenAnswer((_) async => Right([tTvSeason]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTvSeasons(tId)),
    expect: () => [
      TvSeasonsLoading(),
      TvSeasonsHasData([tTvSeason]),
    ],
    verify: (_) {
      verify(mockGetTvSeasons.execute(tId));
      return LoadTvSeasons(tId).props.contains(tId);
    },
  );

  blocTest<TvSeasonsBloc, TvSeasonsState>(
    'should emit [loading, error] when get data is unsuccessful',
    build: () {
      when(mockGetTvSeasons.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTvSeasons(tId)),
    expect: () => [
      TvSeasonsLoading(),
      const TvSeasonsError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetTvSeasons.execute(tId));
      return LoadTvSeasons(tId).props.contains(tId);
    },
  );

  blocTest<TvSeasonsBloc, TvSeasonsState>(
    'should emit [loading, no data] when get data is empty',
    build: () {
      when(mockGetTvSeasons.execute(tId))
          .thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTvSeasons(tId)),
    expect: () => [
      TvSeasonsLoading(),
      const TvSeasonsNoData('No Data'),
    ],
    verify: (_) {
      verify(mockGetTvSeasons.execute(tId));
      return LoadTvSeasons(tId).props.contains(tId);
    },
  );
}
