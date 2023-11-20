import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:core/helpers/dummy_objects.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';

import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
  SaveWatchlist,
  RemoveWatchlist,
  GetWatchListStatus,
])
void main() {
  late WatchlistMovieBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late MockGetWatchListStatus mockGetWatchListStatus;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    mockGetWatchListStatus = MockGetWatchListStatus();
    bloc = WatchlistMovieBloc(
      mockGetWatchlistMovies,
      mockSaveWatchlist,
      mockRemoveWatchlist,
      mockGetWatchListStatus,
    );
  });

  const tId = 1;
  final tMovieList = <Movie>[testMovie];

  test('initial state should be empty', () {
    // assert
    expect(bloc.state, WatchlistMovieInitial());
  });

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should emit [WatchlistMovieLoading, WatchlistMovieHasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadWatchlistMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WatchlistMovieLoading(),
      WatchlistMovieHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
      return LoadWatchlistMovie().props.contains(LoadWatchlistMovie());
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should emit [WatchlistMovieLoading, WatchlistMovieNoData] when data is empty',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadWatchlistMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WatchlistMovieLoading(),
      const WatchlistMovieNoData('No watchlist data'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
      return LoadWatchlistMovie().props.contains(LoadWatchlistMovie());
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should emit [WatchlistMovieLoading, WatchlistMovieError] when get data is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadWatchlistMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WatchlistMovieLoading(),
      const WatchlistMovieError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
      return LoadWatchlistMovie().props.contains(LoadWatchlistMovie());
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should emit [WatchlistMovieMessage] when data is added successfully',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      return bloc;
    },
    act: (bloc) => bloc.add(AddMovieWatchlist(testMovieDetail)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      const WatchlistMovieMessage('Added to Watchlist'),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testMovieDetail));
      return AddMovieWatchlist(testMovieDetail)
          .props
          .contains(AddMovieWatchlist(testMovieDetail));
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should emit [WatchlistMovieMessage] when data is removed successfully',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));
      return bloc;
    },
    act: (bloc) => bloc.add(RemoveMovieWatchlist(testMovieDetail)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      const WatchlistMovieMessage('Removed from Watchlist'),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
      return RemoveMovieWatchlist(testMovieDetail)
          .props
          .contains(RemoveMovieWatchlist(testMovieDetail));
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should emit [WatchlistMovieMessage] when data is gotten successfully',
    build: () {
      when(mockGetWatchListStatus.execute(tId))
          .thenAnswer((_) async => Future(() => true));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadSavedMovieWatchlist(tId)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      const WatchlistMovieIsAdded(true),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(tId));
      return LoadSavedMovieWatchlist(tId)
          .props
          .contains(LoadSavedMovieWatchlist(tId));
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should emit [WatchlistMovieError] when data saving movie is unsuccessful',
    build: () {
      when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer(
          (_) async => const Left(DatabaseFailure('Database Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(AddMovieWatchlist(testMovieDetail)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      const WatchlistMovieError('Database Failure'),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlist.execute(testMovieDetail));
      return AddMovieWatchlist(testMovieDetail)
          .props
          .contains(AddMovieWatchlist(testMovieDetail));
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should emit [WatchlistMovieError] when data removing movie is unsuccessful',
    build: () {
      when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
          (_) async => const Left(DatabaseFailure('Database Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(RemoveMovieWatchlist(testMovieDetail)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      const WatchlistMovieError('Database Failure'),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlist.execute(testMovieDetail));
      return RemoveMovieWatchlist(testMovieDetail)
          .props
          .contains(RemoveMovieWatchlist(testMovieDetail));
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'should emit [WatchlistMovieIsAdded] when the movie is not in watchlist',
    build: () {
      when(mockGetWatchListStatus.execute(tId))
          .thenAnswer((_) async => Future(() => false));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadSavedMovieWatchlist(tId)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      const WatchlistMovieIsAdded(false),
    ],
    verify: (bloc) {
      verify(mockGetWatchListStatus.execute(tId));
      return LoadSavedMovieWatchlist(tId)
          .props
          .contains(LoadSavedMovieWatchlist(tId));
    },
  );
}
