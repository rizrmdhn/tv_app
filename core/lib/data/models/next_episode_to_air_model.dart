import 'package:core/domain/entities/next_episode_to_air.dart';
import 'package:equatable/equatable.dart';

class NextEpisodeToAirModel extends Equatable {
  final int id;
  final String name;
  final String? overview;
  final DateTime airDate;
  final int episodeNumber;
  final String episodeType;
  final String productionCode;
  final int? runtime;
  final int seasonNumber;
  final int showId;
  final dynamic stillPath;

  const NextEpisodeToAirModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.airDate,
    required this.episodeNumber,
    required this.episodeType,
    required this.productionCode,
    required this.runtime,
    required this.seasonNumber,
    required this.showId,
    required this.stillPath,
  });

  factory NextEpisodeToAirModel.fromJson(Map<String, dynamic> json) =>
      NextEpisodeToAirModel(
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        airDate: DateTime.parse(json["air_date"]),
        episodeNumber: json["episode_number"],
        episodeType: json["episode_type"],
        productionCode: json["production_code"],
        runtime: json["runtime"],
        seasonNumber: json["season_number"],
        showId: json["show_id"],
        stillPath: json["still_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "overview": overview,
        "air_date":
            "${airDate.year.toString().padLeft(4, '0')}-${airDate.month.toString().padLeft(2, '0')}-${airDate.day.toString().padLeft(2, '0')}",
        "episode_number": episodeNumber,
        "episode_type": episodeType,
        "production_code": productionCode,
        "runtime": runtime,
        "season_number": seasonNumber,
        "show_id": showId,
        "still_path": stillPath,
      };

  NextEpisodeToAir toEntity() {
    return NextEpisodeToAir(
      id: id,
      name: name,
      overview: overview,
      airDate: airDate,
      episodeNumber: episodeNumber,
      episodeType: episodeType,
      productionCode: productionCode,
      runtime: runtime,
      seasonNumber: seasonNumber,
      showId: showId,
      stillPath: stillPath,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        airDate,
        episodeNumber,
        episodeType,
        productionCode,
        runtime,
        seasonNumber,
        showId,
        stillPath,
      ];
}
