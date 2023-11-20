import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/helpers/dummy_objects.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/movie_recommendation/movie_recommendation_bloc.dart';

import 'movie_recommendation_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MovieRecommendationBloc bloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    bloc = MovieRecommendationBloc(mockGetMovieRecommendations);
  });

  const tId = 1;
  const tMovieList = <Movie>[testMovie];

  test('initial shoulde be empty', () {
    //assert
    expect(bloc.state, MovieRecommendationInitial());
  });

  blocTest<MovieRecommendationBloc, MovieRecommendationState>(
    'should emit [MovieRecommendationLoading, MovieRecommendationHasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => const Right(tMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadMovieRecommendation(tId)),
    expect: () => [
      MovieRecommendationLoading(),
      const MovieRecommendationHasData(tMovieList),
    ],
    verify: (_) {
      verify(mockGetMovieRecommendations.execute(tId));
      return LoadMovieRecommendation(tId).props.contains(tId);
    },
  );

  blocTest<MovieRecommendationBloc, MovieRecommendationState>(
    'should emit [MovieRecommendationLoading, MovieRecommendationError] when get data is unsuccessful',
    build: () {
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadMovieRecommendation(tId)),
    expect: () => [
      MovieRecommendationLoading(),
      const MovieRecommendationError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetMovieRecommendations.execute(tId));
      return LoadMovieRecommendation(tId).props.contains(tId);
    },
  );

  blocTest<MovieRecommendationBloc, MovieRecommendationState>(
    'should emit [MovieRecommendationLoading, MovieRecommendationHasNoData] when get data is unsuccessful',
    build: () {
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadMovieRecommendation(tId)),
    expect: () => [
      MovieRecommendationLoading(),
      const MovieRecommendationHasNoData('No Data'),
    ],
    verify: (_) {
      verify(mockGetMovieRecommendations.execute(tId));
      return LoadMovieRecommendation(tId).props.contains(tId);
    },
  );
}
