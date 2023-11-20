import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/season_detail.dart';
import 'package:core/domain/usecases/get_tv_season_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/tv_season_detail/tv_season_detail_bloc.dart';

import 'tv_season_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTvSeasonDetail])
void main() {
  late TvSeasonDetailBloc bloc;
  late MockGetTvSeasonDetail mockGetTvSeasonDetail;

  setUp(() {
    mockGetTvSeasonDetail = MockGetTvSeasonDetail();
    bloc = TvSeasonDetailBloc(mockGetTvSeasonDetail);
  });

  const tId = 1;
  const tSeasonNumber = 1;
  const tSeasonDetail = SeasonDetail(
    airDate: 'airDate',
    episodes: [],
    id: 1,
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    seasonNumber: 2,
    voteAverage: 1,
  );

  test('initial state should be empty', () {
    expect(bloc.state, TvSeasonDetailInitial());
  });

  blocTest<TvSeasonDetailBloc, TvSeasonDetailState>(
    'should emit [loading, loaded] when data is gotten successfully',
    build: () {
      when(mockGetTvSeasonDetail.execute(tId, tSeasonNumber))
          .thenAnswer((_) async => const Right(tSeasonDetail));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTvSeasonDetail(tId, tSeasonNumber)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSeasonDetailLoading(),
      const TvSeasonDetailLoaded(tSeasonDetail),
    ],
    verify: (bloc) {
      verify(mockGetTvSeasonDetail.execute(tId, tSeasonNumber));
      return LoadTvSeasonDetail(tId, tSeasonNumber)
          .props
          .contains(LoadTvSeasonDetail(tId, tSeasonNumber));
    },
  );

  blocTest<TvSeasonDetailBloc, TvSeasonDetailState>(
    'should emit [loading, error] when get data is unsuccessful',
    build: () {
      when(mockGetTvSeasonDetail.execute(tId, tSeasonNumber))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTvSeasonDetail(tId, tSeasonNumber)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSeasonDetailLoading(),
      const TvSeasonDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvSeasonDetail.execute(tId, tSeasonNumber));
      return LoadTvSeasonDetail(tId, tSeasonNumber)
          .props
          .contains(LoadTvSeasonDetail(tId, tSeasonNumber));
    },
  );

  blocTest<TvSeasonDetailBloc, TvSeasonDetailState>(
    'should emit [loading, error] when get data is unsuccessful',
    build: () {
      when(mockGetTvSeasonDetail.execute(tId, tSeasonNumber))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTvSeasonDetail(tId, tSeasonNumber)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSeasonDetailLoading(),
      const TvSeasonDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvSeasonDetail.execute(tId, tSeasonNumber));
      return LoadTvSeasonDetail(tId, tSeasonNumber)
          .props
          .contains(LoadTvSeasonDetail(tId, tSeasonNumber));
    },
  );
}
