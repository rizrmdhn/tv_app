import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:core/helpers/dummy_objects.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/top_rated_movie/top_rated_movie_bloc.dart';

import 'top_rated_movie_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMovieBloc bloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    bloc = TopRatedMovieBloc(mockGetTopRatedMovies);
  });

  final tMovieList = <Movie>[testMovie];

  test('initial state should be empty', () {
    // assert
    expect(bloc.state, TopRatedMovieInitial());
  });

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
    'should emit [TopRatedMovieLoading, TopRatedMovieHasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTopRatedMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TopRatedMovieLoading(),
      TopRatedMovieHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
      return LoadTopRatedMovie().props.contains(LoadTopRatedMovie());
    },
  );

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
    'should emit [TopRatedMovieLoading, TopRatedMovieError] when get data is unsuccessful',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTopRatedMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TopRatedMovieLoading(),
      const TopRatedMovieError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
      return LoadTopRatedMovie().props.contains(LoadTopRatedMovie());
    },
  );

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
    'should emit [TopRatedMovieLoading, TopRatedMovieHasNoData] when data is empty',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => const Right(<Movie>[]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTopRatedMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TopRatedMovieLoading(),
      const TopRatedMovieHasNoData('No Data'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
      return LoadTopRatedMovie().props.contains(LoadTopRatedMovie());
    },
  );
}
