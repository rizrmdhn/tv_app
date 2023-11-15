import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_season_detail.dart';
import 'package:ditonton/presentation/provider/tv_season_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_season_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvSeasonDetail,
])
void main() {
  late TvSeasonDetailNotifier provider;
  late MockGetTvSeasonDetail mockGetTvSeasonDetail;

  setUp(() {
    mockGetTvSeasonDetail = MockGetTvSeasonDetail();
    provider = TvSeasonDetailNotifier(
      getTvSeasonDetail: mockGetTvSeasonDetail,
    );
  });

  const tTvSeasonDetail = SeasonDetail(
    voteAverage: 60,
    airDate: 'airDate',
    episodes: [],
    id: 1,
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
    seasonNumber: 1,
  );

  test('initialState should be Empty', () {
    expect(provider.tvSeasonDetailState, equals(RequestState.empty));
  });

  test('should get data from the usecase', () async {
    // arrange
    when(mockGetTvSeasonDetail.execute(1, 1))
        .thenAnswer((_) async => const Right(tTvSeasonDetail));
    // act
    await provider.fetchTvSeasonDetail(1, 1);
    // assert
    expect(provider.tvSeasonDetailState, equals(RequestState.loaded));
    expect(provider.tvSeasonDetail, equals(tTvSeasonDetail));
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetTvSeasonDetail.execute(1, 1))
        .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
    // act
    await provider.fetchTvSeasonDetail(1, 1);
    // assert
    expect(provider.tvSeasonDetailState, equals(RequestState.error));
    expect(provider.message, equals('Server Failure'));
  });
}
