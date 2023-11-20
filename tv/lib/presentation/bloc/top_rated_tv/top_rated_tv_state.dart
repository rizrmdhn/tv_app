part of 'top_rated_tv_bloc.dart';

abstract class TopRatedTvState extends Equatable {
  const TopRatedTvState();

  @override
  List<Object> get props => [];
}

class TopRatedTvInitial extends TopRatedTvState {}

class TopRatedTvLoading extends TopRatedTvState {}

class TopRatedTvHasData extends TopRatedTvState {
  final List<Tv> tvs;

  const TopRatedTvHasData(this.tvs);

  @override
  List<Object> get props => [tvs];
}

class TopRatedTvNoData extends TopRatedTvState {
  final String message;

  const TopRatedTvNoData(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedTvError extends TopRatedTvState {
  final String message;

  const TopRatedTvError(this.message);

  @override
  List<Object> get props => [message];
}
