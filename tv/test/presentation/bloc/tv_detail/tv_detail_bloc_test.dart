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
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/entities/user.dart';
import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/tv_detail/tv_detail_bloc.dart';

import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTvDetail])
void main() {
  late TvDetailBloc bloc;
  late MockGetTvDetail mockGetTvDetail;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    bloc = TvDetailBloc(mockGetTvDetail);
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

  test('initial state should be empty', () {
    expect(bloc.state, TvDetailInitial());
  });

  blocTest<TvDetailBloc, TvDetailState>(
    'should emit [TvDetailLoading, TvDetailHasData] when data is gotten successfully',
    build: () {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(tTvDetail));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTvDetail(tId)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvDetailLoading(),
      TvDetailHasData(tTvDetail),
    ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tId));
      return LoadTvDetail(tId).props.contains(LoadTvDetail(tId));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'should emit [TvDetailLoading, TvDetailError] when get data is unsuccessful',
    build: () {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadTvDetail(tId)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvDetailLoading(),
      const TvDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTvDetail.execute(tId));
      return LoadTvDetail(tId).props.contains(LoadTvDetail(tId));
    },
  );
}
