part of 'tv_watchlist_bloc.dart';

abstract class TvWatchlistState extends Equatable {
  const TvWatchlistState();

  @override
  List<Object> get props => [];
}

class TvWatchlistInitial extends TvWatchlistState {}

class TvWatchlistLoading extends TvWatchlistState {}

class TvWatchlistHasData extends TvWatchlistState {
  final List<Tv> result;

  const TvWatchlistHasData(this.result);

  @override
  List<Object> get props => [result];
}

class TvWatchlistNoData extends TvWatchlistState {
  final String message;

  const TvWatchlistNoData(this.message);

  @override
  List<Object> get props => [message];
}

class TvWatchlistIsAdded extends TvWatchlistState {
  final bool isAdded;

  const TvWatchlistIsAdded(this.isAdded);

  @override
  List<Object> get props => [isAdded];
}

class TvWatchlistError extends TvWatchlistState {
  final String message;

  const TvWatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class TvWatchlistMessage extends TvWatchlistState {
  final String message;

  const TvWatchlistMessage(this.message);

  @override
  List<Object> get props => [message];
}
