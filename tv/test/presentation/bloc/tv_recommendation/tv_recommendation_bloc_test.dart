import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/tv_recommendation/tv_recommendation_bloc.dart';

import 'tv_recommendation_bloc_test.mocks.dart';

@GenerateMocks([GetTvRecommendations])
void main() {
  late TvRecommendationBloc bloc;
  late MockGetTvRecommendations mockGetTvRecommendations;

  setUp(() {
    mockGetTvRecommendations = MockGetTvRecommendations();
    bloc = TvRecommendationBloc(mockGetTvRecommendations);
  });

  const tId = 1;
  const tTvRecommendation = Tv(
    adult: false,
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [1, 2],
    id: 1,
    name: 'name',
    originalCountry: ['originCountry'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    voteAverage: 1.0,
    voteCount: 1,
  );

  test('initial state should be empty', () {
    expect(bloc.state, equals(TvRecommendationInitial()));
  });

  blocTest<TvRecommendationBloc, TvRecommendationState>(
    'should emit [loading, loaded] when data is gotten successfully',
    build: () {
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => const Right([tTvRecommendation]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTvRecommendation(tId)),
    expect: () => [
      TvRecommendationLoading(),
      const TvRecommendationHasData([tTvRecommendation]),
    ],
    verify: (_) {
      verify(mockGetTvRecommendations.execute(tId));
      return LoadTvRecommendation(tId).props.contains(tId);
    },
  );

  blocTest<TvRecommendationBloc, TvRecommendationState>(
    'should emit [loading, error] when get data is unsuccessful',
    build: () {
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTvRecommendation(tId)),
    expect: () => [
      TvRecommendationLoading(),
      const TvRecommendationError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetTvRecommendations.execute(tId));
      return LoadTvRecommendation(tId).props.contains(tId);
    },
  );

  blocTest<TvRecommendationBloc, TvRecommendationState>(
    'should emit [loading, no data] when get data is empty',
    build: () {
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTvRecommendation(tId)),
    expect: () => [
      TvRecommendationLoading(),
      const TvRecommendationNoData('No Data'),
    ],
    verify: (_) {
      verify(mockGetTvRecommendations.execute(tId));
      return LoadTvRecommendation(tId).props.contains(tId);
    },
  );
}
