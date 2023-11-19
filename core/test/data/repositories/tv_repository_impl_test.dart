import 'dart:io';

import 'package:core/data/models/episode_detail_model.dart';
import 'package:core/data/models/season_detail_model.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/exception.dart';
import 'package:core/common/failure.dart';
import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/last_episode_to_air_model.dart';
import 'package:core/data/models/network_model.dart';
import 'package:core/data/models/next_episode_to_air_model.dart';
import 'package:core/data/models/production_company_model.dart';
import 'package:core/data/models/production_countries_model.dart';
import 'package:core/data/models/season_model.dart';
import 'package:core/data/models/spoken_languages_model.dart';
import 'package:core/data/models/tv_detail_model.dart';
import 'package:core/data/models/tv_model.dart';
import 'package:core/data/models/user_model.dart';
import 'package:core/data/repositories/tv_repository_impl.dart';
import 'package:core/domain/entities/production_company.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();
    repository = TvRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  const tTvModel = TvModel(
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

  const tProductionCompanyModel = ProductionCompanyModel(
    id: 1,
    logoPath: '/logoPath',
    name: 'name',
    originCountry: 'originCountry',
  );

  const tProductionCompany = ProductionCompany(
    id: 1,
    logoPath: '/logoPath',
    name: 'name',
    originCountry: 'originCountry',
  );

  var tSeasonModel = SeasonModel(
    airDate: DateTime.parse('2020-05-05'),
    episodeCount: 1,
    id: 1,
    name: "Name",
    overview: "Overview",
    posterPath: "/path.jpg",
    seasonNumber: 1,
    voteAverage: 1.0,
  );

  var tSeason = Season(
    airDate: DateTime.parse('2020-05-05'),
    episodeCount: 1,
    id: 1,
    name: "Name",
    overview: "Overview",
    posterPath: "/path.jpg",
    seasonNumber: 1,
    voteAverage: 1.0,
  );

  final tTvModelList = <TvModel>[tTvModel];
  final tTvList = <Tv>[tTv];
  final tProductionCompanyModelList = <ProductionCompanyModel>[
    tProductionCompanyModel
  ];
  final tProductionCompanyList = <ProductionCompany>[tProductionCompany];
  final tSeasonModelList = <SeasonModel>[tSeasonModel];
  final tSeasonList = <Season>[tSeason];

  group('Airing Today', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getAiringTodayTvs())
            .thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.getAiringTodayTvs();
        // assert
        verify(mockRemoteDataSource.getAiringTodayTvs());
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(tTvList));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getAiringTodayTvs())
            .thenThrow(ServerException());
        // act
        final result = await repository.getAiringTodayTvs();
        // assert
        verify(mockRemoteDataSource.getAiringTodayTvs());
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when device is offline',
      () async {
        // arrange
        when(mockRemoteDataSource.getAiringTodayTvs()).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getAiringTodayTvs();
        // assert
        verify(mockRemoteDataSource.getAiringTodayTvs());
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('On The Air', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getOnTheAirTvs())
            .thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.getOnTheAirTvs();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTvs());
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(tTvList));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getOnTheAirTvs())
            .thenThrow(ServerException());
        // act
        final result = await repository.getOnTheAirTvs();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTvs());
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when device is offline',
      () async {
        // arrange
        when(mockRemoteDataSource.getOnTheAirTvs()).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getOnTheAirTvs();
        // assert
        verify(mockRemoteDataSource.getOnTheAirTvs());
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('Popular', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getPopularTvs())
            .thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.getPopularTvs();
        // assert
        verify(mockRemoteDataSource.getPopularTvs());
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(tTvList));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getPopularTvs()).thenThrow(ServerException());
        // act
        final result = await repository.getPopularTvs();
        // assert
        verify(mockRemoteDataSource.getPopularTvs());
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when device is offline',
      () async {
        // arrange
        when(mockRemoteDataSource.getPopularTvs()).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getPopularTvs();
        // assert
        verify(mockRemoteDataSource.getPopularTvs());
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('Top Rated', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedTvs())
            .thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.getTopRatedTvs();
        // assert
        verify(mockRemoteDataSource.getTopRatedTvs());
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(tTvList));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedTvs())
            .thenThrow(ServerException());
        // act
        final result = await repository.getTopRatedTvs();
        // assert
        verify(mockRemoteDataSource.getTopRatedTvs());
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when device is offline',
      () async {
        // arrange
        when(mockRemoteDataSource.getTopRatedTvs()).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTopRatedTvs();
        // assert
        verify(mockRemoteDataSource.getTopRatedTvs());
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('Get Tv Detail', () {
    const tId = 1;
    var tTvResponse = TvDetailModel(
      adult: false,
      createdBy: const [
        UserModel(
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
      lastEpisodeToAir: LastEpisodeToAirModel(
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
        NetworkModel(
          id: 1,
          logoPath: '/logoPath',
          name: 'name',
          originCountry: 'originCountry',
        ),
      ],
      nextEpisodeToAir: NextEpisodeToAirModel(
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
        ProductionCompanyModel(
          id: 1,
          logoPath: '/logoPath',
          name: 'name',
          originCountry: 'originCountry',
        ),
      ],
      productionCountries: const [
        ProductionCountriesModel(
          iso31661: 'iso31661',
          name: 'name',
        ),
      ],
      spokenLanguages: const [
        SpokenLanguagesModel(
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
        GenreModel(id: 1, name: "Action"),
        GenreModel(id: 2, name: "Adventure"),
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
        SeasonModel(
          airDate: DateTime.parse('2020-05-05'),
          episodeCount: 1,
          id: 1,
          name: "Name",
          overview: "Overview",
          posterPath: "/path.jpg",
          seasonNumber: 1,
          voteAverage: 1.0,
        ),
        SeasonModel(
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

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTvDetail(tId))
            .thenAnswer((_) async => tTvResponse);
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvDetail(tId));
        expect(result, equals(Right(tTvResponse.toEntity())));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTvDetail(tId))
            .thenThrow(ServerException());
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvDetail(tId));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when device is offline',
      () async {
        // arrange
        when(mockRemoteDataSource.getTvDetail(tId)).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(mockRemoteDataSource.getTvDetail(tId));
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('Get Tv Production Company', () {
    const tId = 1;

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTvProductionCompany(tId))
            .thenAnswer((_) async => tProductionCompanyModelList);
        // act
        final result = await repository.getTvProductionCompany(tId);
        // assert
        verify(mockRemoteDataSource.getTvProductionCompany(tId));
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(tProductionCompanyList));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTvProductionCompany(tId))
            .thenThrow(ServerException());
        // act
        final result = await repository.getTvProductionCompany(tId);
        // assert
        verify(mockRemoteDataSource.getTvProductionCompany(tId));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when device is offline',
      () async {
        // arrange
        when(mockRemoteDataSource.getTvProductionCompany(tId)).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvProductionCompany(tId);
        // assert
        verify(mockRemoteDataSource.getTvProductionCompany(tId));
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('Get Tv Seasons', () {
    const tId = 1;

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTvSeasons(tId))
            .thenAnswer((_) async => tSeasonModelList);
        // act
        final result = await repository.getTvSeasons(tId);
        // assert
        verify(mockRemoteDataSource.getTvSeasons(tId));
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(tSeasonList));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTvSeasons(tId))
            .thenThrow(ServerException());
        // act
        final result = await repository.getTvSeasons(tId);
        // assert
        verify(mockRemoteDataSource.getTvSeasons(tId));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when device is offline',
      () async {
        // arrange
        when(mockRemoteDataSource.getTvSeasons(tId)).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvSeasons(tId);
        // assert
        verify(mockRemoteDataSource.getTvSeasons(tId));
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('Get Tv Recommendations', () {
    final tMovieList = <Tv>[tTv];
    const tId = 1;

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTvRecommendations(tId))
            .thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.getTvRecommendations(tId);
        // assert
        verify(mockRemoteDataSource.getTvRecommendations(tId));
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(tMovieList));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTvRecommendations(tId))
            .thenThrow(ServerException());
        // act
        final result = await repository.getTvRecommendations(tId);
        // assert
        verify(mockRemoteDataSource.getTvRecommendations(tId));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when device is offline',
      () async {
        // arrange
        when(mockRemoteDataSource.getTvRecommendations(tId)).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvRecommendations(tId);
        // assert
        verify(mockRemoteDataSource.getTvRecommendations(tId));
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('Search Tvs', () {
    const tQuery = 'query';

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.searchTvs(tQuery))
            .thenAnswer((_) async => tTvModelList);
        // act
        final result = await repository.searchTvs(tQuery);
        // assert
        verify(mockRemoteDataSource.searchTvs(tQuery));
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(tTvList));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.searchTvs(tQuery))
            .thenThrow(ServerException());
        // act
        final result = await repository.searchTvs(tQuery);
        // assert
        verify(mockRemoteDataSource.searchTvs(tQuery));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when device is offline',
      () async {
        // arrange
        when(mockRemoteDataSource.searchTvs(tQuery)).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.searchTvs(tQuery);
        // assert
        verify(mockRemoteDataSource.searchTvs(tQuery));
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('Get Watchlist Status', () {
    test('should run watch status wheter data is found', () async {
      // arrange
      const tId = 1;
      when(mockLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlistTv(tId);
      // assert
      expect(result, false);
    });
  });

  group('Get Watchlist Tvs', () {
    test('should return list of TvTable from database', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistTv())
          .thenAnswer((_) async => [testTvTable]);
      // act
      final result = await repository.getWatchlistTvs();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTv]);
    });
  });

  group('Get Tv Season Detail', () {
    const tId = 1;
    const tSeasonNumber = 1;
    const tTvSeasonDetailResponse = SeasonDetailModel(
      airDate: '2020-05-05',
      episodes: [],
      id: 1,
      name: "Name",
      overview: "Overview",
      posterPath: "/path.jpg",
      seasonNumber: 1,
      voteAverage: 1.0,
    );

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTvSeasonDetail(tId, tSeasonNumber))
            .thenAnswer((_) async => tTvSeasonDetailResponse);
        // act
        final result = await repository.getTvSeasonDetail(tId, tSeasonNumber);
        // assert
        verify(mockRemoteDataSource.getTvSeasonDetail(tId, tSeasonNumber));
        expect(result, equals(Right(tTvSeasonDetailResponse.toEntity())));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTvSeasonDetail(tId, tSeasonNumber))
            .thenThrow(ServerException());
        // act
        final result = await repository.getTvSeasonDetail(tId, tSeasonNumber);
        // assert
        verify(mockRemoteDataSource.getTvSeasonDetail(tId, tSeasonNumber));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when device is offline',
      () async {
        // arrange
        when(mockRemoteDataSource.getTvSeasonDetail(tId, tSeasonNumber))
            .thenThrow(
                const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.getTvSeasonDetail(tId, tSeasonNumber);
        // assert
        verify(mockRemoteDataSource.getTvSeasonDetail(tId, tSeasonNumber));
        expect(
            result,
            equals(const Left(
                ConnectionFailure('Failed to connect to the network'))));
      },
    );
  });

  group('Get Tv Episode Detail', () {
    const tId = 1;
    const tSeasonNumber = 1;
    const tEpisodeNumber = 1;
    const tTvEpisodeDetailResponse = EpisodeDetailModel(
      episodeNumber: 1,
      runtime: 1,
      airDate: '2020-05-05',
      id: 1,
      name: "Name",
      overview: "Overview",
      productionCode: "productionCode",
      seasonNumber: 1,
      stillPath: "/path.jpg",
      voteAverage: 1.0,
      voteCount: 1,
    );

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTvEpisodeDetail(
                tId, tSeasonNumber, tEpisodeNumber))
            .thenAnswer((_) async => tTvEpisodeDetailResponse);
        // act
        final result = await repository.getTvEpisodeDetail(
            tId, tSeasonNumber, tEpisodeNumber);
        // assert
        verify(mockRemoteDataSource.getTvEpisodeDetail(
            tId, tSeasonNumber, tEpisodeNumber));
        expect(result, equals(Right(tTvEpisodeDetailResponse.toEntity())));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getTvEpisodeDetail(
                tId, tSeasonNumber, tEpisodeNumber))
            .thenThrow(ServerException());
        // act
        final result = await repository.getTvEpisodeDetail(
            tId, tSeasonNumber, tEpisodeNumber);
        // assert
        verify(mockRemoteDataSource.getTvEpisodeDetail(
            tId, tSeasonNumber, tEpisodeNumber));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when device is offline',
      () async {
        // arrange
        when(mockRemoteDataSource.getTvEpisodeDetail(
                tId, tSeasonNumber, tEpisodeNumber))
            .thenThrow(
          const SocketException('Failed to connect to the network'),
        );
        // act
        final result = await repository.getTvEpisodeDetail(
          tId,
          tSeasonNumber,
          tEpisodeNumber,
        );
        // assert
        verify(
          mockRemoteDataSource.getTvEpisodeDetail(
            tId,
            tSeasonNumber,
            tEpisodeNumber,
          ),
        );
        expect(
          result,
          equals(
            const Left(
              ConnectionFailure('Failed to connect to the network'),
            ),
          ),
        );
      },
    );
  });

  group('save watchlist', () {
    test('should run save watchlist wheter data is found', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlistTv(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testTvDetail);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return failure when call to local data source is unsuccessful',
        () async {
      // arrange
      when(mockLocalDataSource.insertWatchlistTv(testTvTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testTvDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should run remove watchlist wheter data is found', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlistTv(testTvTable))
          .thenAnswer((_) async => 'Removed from Watchlist');
      // act
      final result = await repository.removeWatchlist(testTvDetail);
      // assert
      expect(result, const Right('Removed from Watchlist'));
    });

    test('should return failure when call to local data source is unsuccessful',
        () async {
      // arrange
      when(mockLocalDataSource.removeWatchlistTv(testTvTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(testTvDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });
}
