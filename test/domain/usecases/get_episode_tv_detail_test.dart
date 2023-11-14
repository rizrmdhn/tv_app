import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/episode_detail.dart';
import 'package:ditonton/domain/usecases/get_episode_tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetEpisodeTvDetail usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetEpisodeTvDetail(mockTvRepository);
  });

  const tTvId = 1;
  const tSeasonNumber = 1;
  const tEpisodeNumber = 1;
  const tEpisodeDetail = EpisodeDetail(
    airDate: "2021-08-11",
    episodeNumber: 1,
    id: 1,
    name: "Pilot",
    overview:
        "When a young loner, Nathan, moves to a new town and assembles a secret bike, he discovers that the community is hiding a mysterious secret.",
    productionCode: "101",
    seasonNumber: 1,
    stillPath: "/pjeMs3yqRmFL3giJy4PMXWZTTPa.jpg",
    voteAverage: 7.5,
    voteCount: 2,
    runtime: null,
  );
  test('should get detail of tv episode from the repository', () async {
    // arrange
    when(mockTvRepository.getTvEpisodeDetail(
      tTvId,
      tSeasonNumber,
      tEpisodeNumber,
    )).thenAnswer((_) async => const Right(tEpisodeDetail));
    // act
    await usecase.execute(tTvId, tSeasonNumber, tEpisodeNumber);
    // assert
    verify(mockTvRepository.getTvEpisodeDetail(
      tTvId,
      tSeasonNumber,
      tEpisodeNumber,
    ));
    verifyNoMoreInteractions(mockTvRepository);
  });
}
