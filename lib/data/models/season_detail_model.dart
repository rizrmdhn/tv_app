import 'package:ditonton/data/models/episode_model.dart';
import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:equatable/equatable.dart';

class SeasonDetailModel extends Equatable {
  final int id;
  final String? airDate;
  final List<EpisodeModel?> episodes;
  final String name;
  final String overview;
  final String? posterPath;
  final int? seasonNumber;
  final double voteAverage;

  const SeasonDetailModel({
    required this.airDate,
    required this.episodes,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  factory SeasonDetailModel.fromJson(Map<String, dynamic> json) =>
      SeasonDetailModel(
        airDate: json["air_date"],
        episodes: List<EpisodeModel>.from(
            json["episodes"].map((x) => EpisodeModel.fromJson(x))),
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"],
        voteAverage: json["vote_average"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "air_date": airDate,
        "episodes": List<dynamic>.from(episodes.map((x) => x?.toJson())),
        "id": id,
        "name": name,
        "overview": overview,
        "poster_path": posterPath,
        "season_number": seasonNumber,
        "vote_average": voteAverage,
      };

  SeasonDetail toEntity() {
    return SeasonDetail(
      airDate: airDate,
      episodes: episodes.map((e) => e?.toEntity()).toList(),
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath,
      seasonNumber: seasonNumber,
      voteAverage: voteAverage,
    );
  }

  @override
  List<Object?> get props {
    return [
      airDate,
      episodes,
      id,
      name,
      overview,
      posterPath,
      seasonNumber,
      voteAverage,
    ];
  }
}
