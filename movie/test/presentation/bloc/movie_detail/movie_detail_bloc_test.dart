import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/helpers/dummy_objects.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';

import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    bloc = MovieDetailBloc(mockGetMovieDetail);
  });

  const tId = 1;

  test('initial shoulde be empty', () {
    //assert
    expect(bloc.state, MovieDetailInitial());
  });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit [MovieDetailLoading, MovieDetailHasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => const Right(testMovieDetail));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadMovieDetail(tId)),
    expect: () => [
      MovieDetailLoading(),
      const MovieDetailHasData(testMovieDetail),
    ],
    verify: (_) {
      verify(mockGetMovieDetail.execute(tId));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit [MovieDetailLoading, MovieDetailError] when get data is unsuccessful',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadMovieDetail(tId)),
    expect: () => [
      MovieDetailLoading(),
      const MovieDetailError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetMovieDetail.execute(tId));
      return LoadMovieDetail(tId).props.contains(tId);
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'should emit [MovieDetailLoading, MovieDetailError] when get data is unsuccessful',
    build: () {
      when(mockGetMovieDetail.execute(tId)).thenAnswer(
          (_) async => const Left(ConnectionFailure('No Connection')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadMovieDetail(tId)),
    expect: () => [
      MovieDetailLoading(),
      const MovieDetailError('No Connection'),
    ],
    verify: (_) {
      verify(mockGetMovieDetail.execute(tId));
      return LoadMovieDetail(tId).props.contains(tId);
    },
  );
}
