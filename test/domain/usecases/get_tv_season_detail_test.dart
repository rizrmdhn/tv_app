import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_season_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeasonDetail usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvSeasonDetail(mockTvRepository);
  });

  const tId = 1;
  const tSeasonNumber = 1;
  const tTvSeasonDetail = SeasonDetail(
    airDate: 'airDate',
    episodes: [],
    voteAverage: 1,
    id: 3627,
    name: "Season 1",
    overview: "overview",
    posterPath: "/nvrJ5K7zB5oE6mEw16vHMKHOgOn.jpg",
    seasonNumber: 1,
  );

  test('should get tv season detail from the repository', () async {
    // arrange
    when(mockTvRepository.getTvSeasonDetail(tId, tSeasonNumber))
        .thenAnswer((_) async => const Right(tTvSeasonDetail));
    // act
    final result = await usecase.execute(tId, tSeasonNumber);
    // assert
    expect(result, const Right(tTvSeasonDetail));
  });
}
