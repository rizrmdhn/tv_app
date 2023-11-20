import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/helpers/dummy_objects.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movie_bloc.dart';

import 'popular_movie_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMovieBloc bloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    bloc = PopularMovieBloc(mockGetPopularMovies);
  });

  final tMovieList = <Movie>[testMovie];

  test('initial state should be empty', () {
    // assert
    expect(bloc.state, PopularMovieInitial());
  });

  blocTest<PopularMovieBloc, PopularMovieState>(
    'should emit [PopularMovieLoading, PopularMovieHasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadPopularMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularMovieLoading(),
      PopularMovieHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
      return LoadPopularMovie().props.contains(LoadPopularMovie());
    },
  );

  blocTest<PopularMovieBloc, PopularMovieState>(
    'should emit [PopularMovieLoading, PopularMovieError] when get data is unsuccessful',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadPopularMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularMovieLoading(),
      const PopularMovieError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
      return LoadPopularMovie().props.contains(LoadPopularMovie());
    },
  );

  blocTest<PopularMovieBloc, PopularMovieState>(
    'should emit [PopularMovieLoading, PopularMovieHasNoData] when data is empty',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => const Right(<Movie>[]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadPopularMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularMovieLoading(),
      const PopularMovieHasNoData('No Data'),
    ],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
      return LoadPopularMovie().props.contains(LoadPopularMovie());
    },
  );
}
