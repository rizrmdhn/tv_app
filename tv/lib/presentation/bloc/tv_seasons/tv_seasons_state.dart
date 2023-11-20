part of 'tv_seasons_bloc.dart';

abstract class TvSeasonsState extends Equatable {
  const TvSeasonsState();

  @override
  List<Object> get props => [];
}

class TvSeasonsInitial extends TvSeasonsState {}

class TvSeasonsLoading extends TvSeasonsState {}

class TvSeasonsHasData extends TvSeasonsState {
  final List<Season> result;

  const TvSeasonsHasData(this.result);

  @override
  List<Object> get props => [result];
}

class TvSeasonsError extends TvSeasonsState {
  final String message;

  const TvSeasonsError(this.message);

  @override
  List<Object> get props => [message];
}

class TvSeasonsNoData extends TvSeasonsState {
  final String message;

  const TvSeasonsNoData(this.message);

  @override
  List<Object> get props => [message];
}
