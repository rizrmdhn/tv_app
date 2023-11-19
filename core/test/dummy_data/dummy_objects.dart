import 'package:core/data/models/movie_table.dart';
import 'package:core/data/models/tv_table.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/last_episode_to_air.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/entities/network.dart';
import 'package:core/domain/entities/next_episode_to_air.dart';
import 'package:core/domain/entities/production_company.dart';
import 'package:core/domain/entities/production_countries.dart';
import 'package:core/domain/entities/season.dart';
import 'package:core/domain/entities/spoken_languages.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/entities/user.dart';

const testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

const testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

const testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTvMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};

const testTvTable = TvTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testWatchlistTv = Tv.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

var testTvDetail = TvDetail(
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
