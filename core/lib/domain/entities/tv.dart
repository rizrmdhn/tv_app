import 'package:equatable/equatable.dart';

class Tv extends Equatable {
  final bool? adult;
  final String? backdropPath;
  final List<int>? genreIds;
  final int id;
  final List<String>? originalCountry;
  final String? originalLanguage;
  final String? originalName;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final String? firstAirDate;
  final String? name;
  final double? voteAverage;
  final int? voteCount;

  const Tv({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
  });

  const Tv.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.name,
    this.firstAirDate,
    this.voteAverage,
    this.voteCount,
    this.backdropPath,
    this.genreIds,
    this.adult,
    this.originalCountry,
    this.originalLanguage,
    this.originalName,
    this.popularity,
  });

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        genreIds,
        id,
        originalCountry,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        firstAirDate,
        name,
        voteAverage,
        voteCount,
      ];
}
