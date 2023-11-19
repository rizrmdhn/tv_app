part of 'tv_episode_detail_bloc.dart';

abstract class TvEpisodeDetailState extends Equatable {
  const TvEpisodeDetailState();

  @override
  List<Object> get props => [];
}

class TvEpisodeDetailInitial extends TvEpisodeDetailState {}

class TvEpisodeDetailLoading extends TvEpisodeDetailState {}

class TvEpisodeDetailError extends TvEpisodeDetailState {
  final String message;

  const TvEpisodeDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class TvEpisodeDetailLoaded extends TvEpisodeDetailState {
  final EpisodeDetail tvEpisodeDetail;

  const TvEpisodeDetailLoaded(this.tvEpisodeDetail);

  @override
  List<Object> get props => [tvEpisodeDetail];
}
