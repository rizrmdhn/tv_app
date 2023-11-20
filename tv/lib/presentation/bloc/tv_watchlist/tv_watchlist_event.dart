part of 'tv_watchlist_bloc.dart';

abstract class TvWatchlistEvent extends Equatable {}

class LoadTvWatchlist extends TvWatchlistEvent {
  @override
  List<Object?> get props => [];
}

class LoadSavedTvWatchlist extends TvWatchlistEvent {
  final int id;

  LoadSavedTvWatchlist(this.id);

  @override
  List<Object?> get props => [id];
}

class AddTvWatchlist extends TvWatchlistEvent {
  final TvDetail tvDetail;

  AddTvWatchlist(this.tvDetail);

  @override
  List<Object?> get props => [tvDetail];
}

class RemoveTvWatchlist extends TvWatchlistEvent {
  final TvDetail tvDetail;

  RemoveTvWatchlist(this.tvDetail);

  @override
  List<Object?> get props => [tvDetail];
}
