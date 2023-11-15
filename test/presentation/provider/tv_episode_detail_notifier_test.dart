import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/episode_detail.dart';
import 'package:ditonton/domain/usecases/get_episode_tv_detail.dart';
import 'package:ditonton/presentation/provider/tv_episode_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_episode_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetEpisodeTvDetail,
])
void main() {
  late TvEpisodeDetailNotifier provider;
  late MockGetEpisodeTvDetail mockGetEpisodeTvDetail;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetEpisodeTvDetail = MockGetEpisodeTvDetail();
    provider = TvEpisodeDetailNotifier(
      getEpisodeTvDetail: mockGetEpisodeTvDetail,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  const tEpisodeDetail = EpisodeDetail(
    runtime: 60,
    airDate: '2021-03-19',
    episodeNumber: 1,
    id: 2975607,
    name: 'Episode 1',
    overview: 'Overview',
    productionCode: 'productionCode',
    seasonNumber: 1,
    stillPath: '/stillPath',
    voteAverage: 8.0,
    voteCount: 1,
  );

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetEpisodeTvDetail.execute(1, 1, 1))
        .thenAnswer((_) async => const Right(tEpisodeDetail));
    // act
    provider.fetchEpisodeDetail(1, 1, 1);
    // assert
    expect(provider.episodeDetailState, RequestState.loading);
    expect(listenerCallCount, 1);
  });

  test('should change episode detail data when data is gotten successfully',
      () async {
    // arrange
    when(mockGetEpisodeTvDetail.execute(1, 1, 1))
        .thenAnswer((_) async => const Right(tEpisodeDetail));
    // act
    await provider.fetchEpisodeDetail(1, 1, 1);
    // assert
    expect(provider.episodeDetailState, RequestState.loaded);
    expect(provider.episodeDetail, tEpisodeDetail);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetEpisodeTvDetail.execute(1, 1, 1))
        .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
    // act
    await provider.fetchEpisodeDetail(1, 1, 1);
    // assert
    expect(provider.episodeDetailState, RequestState.error);
    expect(provider.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
