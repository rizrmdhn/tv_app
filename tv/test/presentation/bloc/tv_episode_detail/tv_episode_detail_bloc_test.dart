import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/episode_detail.dart';
import 'package:core/domain/usecases/get_episode_tv_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/tv_episode_detail/tv_episode_detail_bloc.dart';

import 'tv_episode_detail_bloc_test.mocks.dart';

@GenerateMocks([GetEpisodeTvDetail])
void main() {
  late TvEpisodeDetailBloc bloc;
  late MockGetEpisodeTvDetail mockGetEpisodeTvDetail;

  setUp(() {
    mockGetEpisodeTvDetail = MockGetEpisodeTvDetail();
    bloc = TvEpisodeDetailBloc(mockGetEpisodeTvDetail);
  });

  const tTvId = 1;
  const tSeasonNumber = 1;
  const tEpisodeNumber = 1;
  const tEpisodeDetail = EpisodeDetail(
    episodeNumber: 1,
    runtime: 1,
    airDate: 'airDate',
    id: 1,
    name: 'name',
    overview: 'overview',
    productionCode: 'productionCode',
    seasonNumber: 1,
    stillPath: 'stillPath',
    voteAverage: 1,
    voteCount: 1,
  );

  test('initial state should be empty', () {
    expect(bloc.state, TvEpisodeDetailInitial());
  });

  blocTest<TvEpisodeDetailBloc, TvEpisodeDetailState>(
    'should emit [loading, loaded] when data is gotten successfully',
    build: () {
      when(mockGetEpisodeTvDetail.execute(
        tTvId,
        tSeasonNumber,
        tEpisodeNumber,
      )).thenAnswer((_) async => const Right(tEpisodeDetail));
      return bloc;
    },
    act: (bloc) => bloc.add(
      TvEpisodeDetailLoad(
        tTvId,
        tSeasonNumber,
        tEpisodeNumber,
      ),
    ),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvEpisodeDetailLoading(),
      const TvEpisodeDetailLoaded(tEpisodeDetail),
    ],
    verify: (bloc) {
      verify(mockGetEpisodeTvDetail.execute(
        tTvId,
        tSeasonNumber,
        tEpisodeNumber,
      ));
      return TvEpisodeDetailLoad(
        tTvId,
        tSeasonNumber,
        tEpisodeNumber,
      ).props.contains(TvEpisodeDetailLoad(
            tTvId,
            tSeasonNumber,
            tEpisodeNumber,
          ));
    },
  );

  blocTest<TvEpisodeDetailBloc, TvEpisodeDetailState>(
    'should emit [loading, error] when get data is unsuccessful',
    build: () {
      when(mockGetEpisodeTvDetail.execute(
        tTvId,
        tSeasonNumber,
        tEpisodeNumber,
      )).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(
      TvEpisodeDetailLoad(
        tTvId,
        tSeasonNumber,
        tEpisodeNumber,
      ),
    ),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvEpisodeDetailLoading(),
      const TvEpisodeDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetEpisodeTvDetail.execute(
        tTvId,
        tSeasonNumber,
        tEpisodeNumber,
      ));
      return TvEpisodeDetailLoad(
        tTvId,
        tSeasonNumber,
        tEpisodeNumber,
      ).props.contains(TvEpisodeDetailLoad(
            tTvId,
            tSeasonNumber,
            tEpisodeNumber,
          ));
    },
  );

  blocTest<TvEpisodeDetailBloc, TvEpisodeDetailState>(
    'should emit [loading, error] when get data is unsuccessful',
    build: () {
      when(mockGetEpisodeTvDetail.execute(
        tTvId,
        tSeasonNumber,
        tEpisodeNumber,
      )).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(
      TvEpisodeDetailLoad(
        tTvId,
        tSeasonNumber,
        tEpisodeNumber,
      ),
    ),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvEpisodeDetailLoading(),
      const TvEpisodeDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetEpisodeTvDetail.execute(
        tTvId,
        tSeasonNumber,
        tEpisodeNumber,
      ));
      return TvEpisodeDetailLoad(
        tTvId,
        tSeasonNumber,
        tEpisodeNumber,
      ).props.contains(TvEpisodeDetailLoad(
            tTvId,
            tSeasonNumber,
            tEpisodeNumber,
          ));
    },
  );
}
