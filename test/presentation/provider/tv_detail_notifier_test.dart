// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/last_episode_to_air.dart';
import 'package:ditonton/domain/entities/network.dart';
import 'package:ditonton/domain/entities/next_episode_to_air.dart';
import 'package:ditonton/domain/entities/production_company.dart';
import 'package:ditonton/domain/entities/production_countries.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/spoken_languages.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/user.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_production_company.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_tv_season.dart';
import 'package:ditonton/domain/usecases/get_tv_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tv_remove_watchlist.dart';
import 'package:ditonton/domain/usecases/tv_save_watchlist.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvProductionCompany,
  GetTvSeasons,
  GetTvRecommendations,
  TvSaveWatchList,
  TvRemoveWatchList,
  GetTvWatchlistStatus,
])
void main() {
  late TvDetailNotifier provider;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvProductionCompany mockGetTvProductionCompany;
  late MockGetTvSeasons mockGetTvSeasons;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockTvSaveWatchList mockSaveWatchlist;
  late MockTvRemoveWatchList mockRemoveWatchlist;
  late MockGetTvWatchlistStatus mockGetWatchlistStatus;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvProductionCompany = MockGetTvProductionCompany();
    mockGetTvSeasons = MockGetTvSeasons();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockSaveWatchlist = MockTvSaveWatchList();
    mockRemoveWatchlist = MockTvRemoveWatchList();
    mockGetWatchlistStatus = MockGetTvWatchlistStatus();
    provider = TvDetailNotifier(
      getTvDetail: mockGetTvDetail,
      getTvProductionCompany: mockGetTvProductionCompany,
      getTvSeasons: mockGetTvSeasons,
      getTvRecommendations: mockGetTvRecommendations,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
      getWatchlistStatus: mockGetWatchlistStatus,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  const tId = 1;
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

  final tTvs = <Tv>[];

  void _arrangeUsecase() {
    when(mockGetTvDetail.execute(tId))
        .thenAnswer((_) async => Right(tTvDetail));
    when(mockGetTvProductionCompany.execute(tId))
        .thenAnswer((_) async => Right(tTvDetail.productionCompanies));
    when(mockGetTvSeasons.execute(tId))
        .thenAnswer((_) async => Right(tTvDetail.seasons));
    when(mockGetTvRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tTvs));
  }

  group('Get Tv Detail', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchTvDetail(tId);
      // assert
      expect(provider.tvState, RequestState.loading);
      expect(listenerCallCount, 1);
    });

    test('should change tv data when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.tvState, RequestState.loaded);
      expect(provider.tv, tTvDetail);
      expect(listenerCallCount, 6);
    });

    test(
        'should change production compaines tv when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.productionCompaniesState, RequestState.loaded);
      expect(provider.productionCompanies, tTvDetail.productionCompanies);
      expect(listenerCallCount, 6);
    });

    test('should change season tv when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.seasonsState, RequestState.loaded);
      expect(provider.seasons, tTvDetail.seasons);
      expect(listenerCallCount, 6);
    });

    test('should change recommendations tv when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.loaded);
      expect(provider.tvRecommendations, tTvs);
      expect(listenerCallCount, 6);
    });

    test('should return error when fetching tv is unsuccessful', () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      when(mockGetTvProductionCompany.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      when(mockGetTvSeasons.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.tvState, RequestState.error);
      expect(provider.message, 'Failed');
      expect(listenerCallCount, 2);
    });

    test('should return error when fetching production company is unsuccessful',
        () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(tTvDetail));
      when(mockGetTvProductionCompany.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      when(mockGetTvSeasons.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.productionCompaniesState, RequestState.error);
      expect(provider.message, 'Failed');
      expect(listenerCallCount, 6);
    });

    test('should return error when fetching season is unsuccessful', () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(tTvDetail));
      when(mockGetTvProductionCompany.execute(tId))
          .thenAnswer((_) async => Right(tTvDetail.productionCompanies));
      when(mockGetTvSeasons.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.seasonsState, RequestState.error);
      expect(provider.message, 'Failed');
      expect(listenerCallCount, 6);
    });

    test('should return error when fetching recommendations is unsuccessful',
        () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(tTvDetail));
      when(mockGetTvProductionCompany.execute(tId))
          .thenAnswer((_) async => Right(tTvDetail.productionCompanies));
      when(mockGetTvSeasons.execute(tId))
          .thenAnswer((_) async => Right(tTvDetail.seasons));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.error);
      expect(provider.message, 'Failed');
      expect(listenerCallCount, 6);
    });
  });

  group('Watchlist', () {
    test('should change watchlist status when data is gotten successfully',
        () async {
      // arrange
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(tId);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlist.execute(tTvDetail))
          .thenAnswer((_) async => const Right('Added to watchlist'));
      when(mockGetWatchlistStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(tTvDetail);
      // assert
      verify(mockSaveWatchlist.execute(tTvDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlist.execute(tTvDetail)).thenAnswer(
          (_) => Future.value(const Right('Removed from watchlist')));
      when(mockGetWatchlistStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(tTvDetail);
      // assert
      verify(mockRemoveWatchlist.execute(tTvDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlist.execute(tTvDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(tTvDetail);
      // assert
      verify(mockGetWatchlistStatus.execute(tTvDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 2);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlist.execute(tTvDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addWatchlist(tTvDetail);
      // assert
      verify(mockGetWatchlistStatus.execute(tTvDetail.id));
      expect(provider.isAddedToWatchlist, false);
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 2);
    });

    test('should update watchlist status when remove watchlist success',
        () async {
      // arrange
      when(mockRemoveWatchlist.execute(tTvDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(mockGetWatchlistStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(tTvDetail);
      // assert
      verify(mockGetWatchlistStatus.execute(tTvDetail.id));
      expect(provider.isAddedToWatchlist, false);
      expect(provider.watchlistMessage, 'Removed from Watchlist');
      expect(listenerCallCount, 2);
    });

    test('should update watchlist message when remove watchlist failed',
        () async {
      // arrange
      when(mockRemoveWatchlist.execute(tTvDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.removeFromWatchlist(tTvDetail);
      // assert
      verify(mockGetWatchlistStatus.execute(tTvDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 2);
    });
  });

  group('On Error', () {
    test('should change state to error when data is unsuccessful', () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('error')));
      when(mockGetTvProductionCompany.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('error')));
      when(mockGetTvSeasons.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('error')));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('error')));
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.tvState, RequestState.error);
      expect(provider.message, 'error');
      expect(listenerCallCount, 2);
    });
  });
}
