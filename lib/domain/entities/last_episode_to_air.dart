import 'package:equatable/equatable.dart';

class LastEpisodeToAir extends Equatable {
  final int id;
  final String name;
  final DateTime airDate;
  final String? overview;
  final int episodeNumber;
  final String episodeType;
  final String productionCode;
  final int? runtime;
  final int seasonNumber;
  final int showId;
  final dynamic stillPath;

  const LastEpisodeToAir({
    required this.id,
    required this.name,
    required this.airDate,
    required this.overview,
    required this.episodeNumber,
    required this.episodeType,
    required this.productionCode,
    required this.runtime,
    required this.seasonNumber,
    required this.showId,
    required this.stillPath,
  });

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
