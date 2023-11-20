import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/last_episode_to_air.dart';
import 'package:core/domain/entities/network.dart';
import 'package:core/domain/entities/next_episode_to_air.dart';
import 'package:core/domain/entities/production_company.dart';
import 'package:core/domain/entities/production_countries.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/entities/spoken_languages.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/entities/user.dart';
import 'package:core/domain/usecases/get_tv_watchlist_status.dart';
import 'package:core/domain/usecases/get_watchlist_tv.dart';
import 'package:core/domain/usecases/tv_remove_watchlist.dart';
import 'package:core/domain/usecases/tv_save_watchlist.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/tv_watchlist/tv_watchlist_bloc.dart';

import 'tv_watchlist_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchListTv,
  TvSaveWatchList,
  TvRemoveWatchList,
  GetTvWatchlistStatus,
])
void main() {
  late TvWatchlistBloc bloc;
  late MockGetWatchListTv mockGetWatchListTv;
  late MockTvSaveWatchList mockSaveWatchList;
  late MockTvRemoveWatchList mockRemoveWatchList;
  late MockGetTvWatchlistStatus mockGetTvWatchlistStatus;

  setUp(() {
    mockGetWatchListTv = MockGetWatchListTv();
    mockSaveWatchList = MockTvSaveWatchList();
    mockRemoveWatchList = MockTvRemoveWatchList();
    mockGetTvWatchlistStatus = MockGetTvWatchlistStatus();
    bloc = TvWatchlistBloc(mockGetWatchListTv, mockSaveWatchList,
        mockRemoveWatchList, mockGetTvWatchlistStatus);
  });

  const tId = 1;
  const tTv = Tv(
    adult: false,
    backdropPath: '/backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [1, 2],
    id: 1,
    name: 'name',
    originalCountry: ['originCountry'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: '/posterPath',
    voteAverage: 1.0,
    voteCount: 1,
  );
  const tTvList = <Tv>[tTv];
  final tTvDetail = TvDetail(
    adult: false,
    createdBy: const [
      User(
        id: 1,
        creditId: "creditId",
        name: 'name',
        gender: 1,
        profilePath: '/profilePath',
      ),
    ],
    episodeRunTime: const [1, 2, 3],
    homepage: "homepage",
    inProduction: false,
    languages: const ["en", "id"],
    lastAirDate: "2020-05-05",
    lastEpisodeToAir: LastEpisodeToAir(
      id: 1,
      name: 'name',
      airDate: DateTime.parse('2020-05-05'),
      overview: 'overview',
      episodeNumber: 1,
      episodeType: 'episodeType',
      productionCode: 'productionCode',
      runtime: 1,
      seasonNumber: 1,
      showId: 1,
      stillPath: '/stillPath',
    ),
    networks: const [
      Network(
        id: 1,
        logoPath: '/logoPath',
        name: 'name',
        originCountry: 'originCountry',
      ),
    ],
    nextEpisodeToAir: NextEpisodeToAir(
      id: 1,
      name: 'name',
      airDate: DateTime.parse('2020-05-05'),
      overview: 'overview',
      episodeNumber: 1,
      episodeType: 'episodeType',
      productionCode: 'productionCode',
      runtime: 1,
      seasonNumber: 1,
      showId: 1,
      stillPath: '/stillPath',
    ),
    numberOfEpisodes: 1,
    numberOfSeasons: 1,
    originCountry: const ["US", "ID"],
    productionCompanies: const [
      ProductionCompany(
        id: 1,
        logoPath: '/logoPath',
        name: 'name',
        originCountry: 'originCountry',
      ),
    ],
    productionCountries: const [
      ProductionCountries(
        iso31661: 'iso31661',
        name: 'name',
      ),
    ],
    spokenLanguages: const [
      SpokenLanguages(
        englishName: 'englishName',
        iso6391: 'iso6391',
        name: 'name',
      ),
    ],
    status: "status",
    tagline: "tagline",
    type: "type",
    backdropPath: "/path.jpg",
    firstAirDate: "2020-05-05",
    genres: const [
      Genre(id: 1, name: "Action"),
      Genre(id: 2, name: "Adventure"),
    ],
    id: 1,
    name: "Name",
    originalLanguage: "en",
    originalName: "Original Name",
    overview: "Overview",
    popularity: 1.0,
    posterPath: "/path.jpg",
    voteAverage: 1.0,
    voteCount: 1,
    seasons: [
      Season(
        airDate: DateTime.parse('2020-05-05'),
        episodeCount: 1,
        id: 1,
        name: "Name",
        overview: "Overview",
        posterPath: "/path.jpg",
        seasonNumber: 1,
        voteAverage: 1.0,
      ),
      Season(
        airDate: DateTime.parse('2020-05-05'),
        episodeCount: 1,
        id: 1,
        name: "Name",
        overview: "Overview",
        posterPath: "/path.jpg",
        seasonNumber: 1,
        voteAverage: 1.0,
      ),
    ],
  );

  test('initial state should be empty', () {
    expect(bloc.state, equals(TvWatchlistInitial()));
  });

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'should emit [loading, loaded] when data is gotten successfully',
    build: () {
      when(mockGetWatchListTv.execute())
          .thenAnswer((_) async => const Right(tTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTvWatchlist()),
    expect: () => [
      TvWatchlistLoading(),
      const TvWatchlistHasData(tTvList),
    ],
    verify: (_) {
      verify(mockGetWatchListTv.execute());
      return LoadTvWatchlist().props.contains(tId);
    },
  );

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'should emit [loading, error] when get data is unsuccessful',
    build: () {
      when(mockGetWatchListTv.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTvWatchlist()),
    expect: () => [
      TvWatchlistLoading(),
      const TvWatchlistError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetWatchListTv.execute());
      return LoadTvWatchlist().props.contains(tId);
    },
  );

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'should emit [loading, no data] when get data is empty',
    build: () {
      when(mockGetWatchListTv.execute())
          .thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTvWatchlist()),
    expect: () => [
      TvWatchlistLoading(),
      const TvWatchlistNoData('No watchlist data'),
    ],
    verify: (_) {
      verify(mockGetWatchListTv.execute());
      return LoadTvWatchlist().props.contains(tId);
    },
  );

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'should emit [loading, loaded] when data is gotten successfully',
    build: () {
      when(mockGetTvWatchlistStatus.execute(tId))
          .thenAnswer((_) async => Future(() => true));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadSavedTvWatchlist(tId)),
    expect: () => [
      const TvWatchlistIsAdded(true),
    ],
    verify: (_) {
      verify(mockGetTvWatchlistStatus.execute(tId));
      return LoadSavedTvWatchlist(tId).props.contains(tId);
    },
  );

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'should emit [loading, loaded] when data is gotten successfully',
    build: () {
      when(mockSaveWatchList.execute(tTvDetail))
          .thenAnswer((_) async => const Right('Added to watchlist'));
      return bloc;
    },
    act: (bloc) => bloc.add(AddTvWatchlist(tTvDetail)),
    expect: () => [
      const TvWatchlistMessage('Added to watchlist'),
    ],
    verify: (_) {
      verify(mockSaveWatchList.execute(tTvDetail));
      return AddTvWatchlist(tTvDetail).props.contains(tTvDetail);
    },
  );

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'should emit [loading, loaded] when data is gotten successfully',
    build: () {
      when(mockRemoveWatchList.execute(tTvDetail))
          .thenAnswer((_) async => const Right('Removed from watchlist'));
      return bloc;
    },
    act: (bloc) => bloc.add(RemoveTvWatchlist(tTvDetail)),
    expect: () => [
      const TvWatchlistMessage('Removed from watchlist'),
    ],
    verify: (_) {
      verify(mockRemoveWatchList.execute(tTvDetail));
      return RemoveTvWatchlist(tTvDetail).props.contains(tTvDetail);
    },
  );

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'should emit [loading, loaded] when data is gotten successfully',
    build: () {
      when(mockGetTvWatchlistStatus.execute(tId))
          .thenAnswer((_) async => Future(() => false));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadSavedTvWatchlist(tId)),
    expect: () => [
      const TvWatchlistIsAdded(false),
    ],
    verify: (_) {
      verify(mockGetTvWatchlistStatus.execute(tId));
      return LoadSavedTvWatchlist(tId).props.contains(tId);
    },
  );

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'should emit [loading, error] when get data is unsuccessful',
    build: () {
      when(mockRemoveWatchList.execute(tTvDetail))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(RemoveTvWatchlist(tTvDetail)),
    expect: () => [
      const TvWatchlistError('Server Failure'),
    ],
    verify: (_) {
      verify(mockRemoveWatchList.execute(tTvDetail));
      return RemoveTvWatchlist(tTvDetail).props.contains(tTvDetail);
    },
  );

  blocTest<TvWatchlistBloc, TvWatchlistState>(
    'should emit [loading, error] when get data is unsuccessful',
    build: () {
      when(mockSaveWatchList.execute(tTvDetail))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(AddTvWatchlist(tTvDetail)),
    expect: () => [
      const TvWatchlistError('Server Failure'),
    ],
    verify: (_) {
      verify(mockSaveWatchList.execute(tTvDetail));
      return AddTvWatchlist(tTvDetail).props.contains(tTvDetail);
    },
  );
}
