import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/last_episode_to_air_model.dart';
import 'package:ditonton/data/models/network_model.dart';
import 'package:ditonton/data/models/next_episode_to_air_model.dart';
import 'package:ditonton/data/models/production_company_model.dart';
import 'package:ditonton/data/models/production_countries_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/data/models/spoken_languages_model.dart';
import 'package:ditonton/data/models/user_model.dart';
import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  final bool adult;
  final String? backdropPath;
  final List<UserModel> createdBy;
  final List<int> episodeRunTime;
  final List<GenreModel> genres;
  final String firstAirDate;
  final String homepage;
  final int id;
  final bool inProduction;
  final List<String> languages;
  final String lastAirDate;
  final LastEpisodeToAirModel lastEpisodeToAir;
  final String name;
  final NextEpisodeToAirModel nextEpisodeToAir;
  final List<NetworkModel> networks;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final List<ProductionCompanyModel> productionCompanies;
  final List<ProductionCountriesModel> productionCountries;
  final List<SeasonModel> seasons;
  final List<SpokenLanguagesModel> spokenLanguages;
  final String status;
  final String tagline;
  final String type;
  final double voteAverage;
  final int voteCount;

  const TvDetail({
    required this.adult,
    required this.backdropPath,
    required this.createdBy,
    required this.episodeRunTime,
    required this.genres,
    required this.firstAirDate,
    required this.homepage,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.lastAirDate,
    required this.lastEpisodeToAir,
    required this.name,
    required this.nextEpisodeToAir,
    required this.networks,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.seasons,
    required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
  });

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        createdBy,
        episodeRunTime,
        genres,
        firstAirDate,
        homepage,
        id,
        inProduction,
        languages,
        lastAirDate,
        lastEpisodeToAir,
        name,
        nextEpisodeToAir,
        networks,
        numberOfEpisodes,
        numberOfSeasons,
        originCountry,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        productionCompanies,
        productionCountries,
        seasons,
        spokenLanguages,
        status,
        tagline,
        type,
        voteAverage,
        voteCount,
      ];
}
