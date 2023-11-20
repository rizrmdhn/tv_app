part of 'tv_episode_detail_bloc.dart';

abstract class TvEpisodeDetailEvent extends Equatable {}

class TvEpisodeDetailLoad extends TvEpisodeDetailEvent {
  final int tvId;
  final int seasonNumber;
  final int episodeNumber;

  TvEpisodeDetailLoad(
    this.tvId,
    this.seasonNumber,
    this.episodeNumber,
  );

  @override
  List<Object> get props => [tvId, seasonNumber, episodeNumber];
}
