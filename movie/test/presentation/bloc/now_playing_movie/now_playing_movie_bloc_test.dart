import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/helpers/dummy_objects.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/now_playing_movie/now_playing_movie_bloc.dart';

import 'now_playing_movie_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late NowPlayingMovieBloc bloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    bloc = NowPlayingMovieBloc(mockGetNowPlayingMovies);
  });

  final tMovieList = <Movie>[testMovie];

  test('initial state should be empty', () {
    // assert
    expect(bloc.state, NowPlayingMovieInitial());
  });

  blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
    'should emit [NowPlayingMovieLoading, NowPlayingMovieHasData] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadNowPlayingMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      NowPlayingMovieLoading(),
      NowPlayingMovieHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
      return LoadNowPlayingMovie().props.contains(LoadNowPlayingMovie());
    },
  );

  blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
    'should emit [NowPlayingMovieLoading, NowPlayingMovieError] when get data is unsuccessful',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadNowPlayingMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      NowPlayingMovieLoading(),
      const NowPlayingMovieError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
      return LoadNowPlayingMovie().props.contains(LoadNowPlayingMovie());
    },
  );

  blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
    'should emit [NowPlayingMovieLoading, NowPlayingMovieNoData] when data is empty',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadNowPlayingMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      NowPlayingMovieLoading(),
      const NowPlayingMovieHasNoData('No Data'),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies.execute());
      return LoadNowPlayingMovie().props.contains(LoadNowPlayingMovie());
    },
  );
}
