import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/presentation/provider/now_playing_movies_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_playing_movies_notifier_test.mocks.dart';

@GenerateMocks([
  GetNowPlayingMovies,
])
void main() {
  late NowPlayingMoviesNotifier provider;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    provider = NowPlayingMoviesNotifier(
      getNowPlayingMovies: mockGetNowPlayingMovies,
    );
  });

  const tMovies = <Movie>[];

  test('should change state to loading when fetch now playing movies',
      () async {
    // arrange
    when(mockGetNowPlayingMovies.execute())
        .thenAnswer((_) async => const Right(tMovies));
    // act
    provider.fetchNowPlayingMovies();
    // assert
    expect(provider.state, RequestState.loading);
  });

  test('should change state to loaded when fetch now playing movies success',
      () async {
    // arrange
    when(mockGetNowPlayingMovies.execute())
        .thenAnswer((_) async => const Right(tMovies));
    // act
    await provider.fetchNowPlayingMovies();
    // assert
    expect(provider.state, RequestState.loaded);
  });

  test('should change state to error when fetch now playing movies failed',
      () async {
    // arrange
    when(mockGetNowPlayingMovies.execute())
        .thenAnswer((_) async => const Left(ServerFailure('error')));
    // act
    await provider.fetchNowPlayingMovies();
    // assert
    expect(provider.state, RequestState.error);
  });
}
