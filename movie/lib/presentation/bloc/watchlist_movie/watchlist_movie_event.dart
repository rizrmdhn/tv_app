part of 'watchlist_movie_bloc.dart';

abstract class WatchlistMovieEvent extends Equatable {}

class LoadWatchlistMovie extends WatchlistMovieEvent {
  @override
  List<Object?> get props => [];
}

class LoadSavedMovieWatchlist extends WatchlistMovieEvent {
  final int id;

  LoadSavedMovieWatchlist(this.id);

  @override
  List<Object?> get props => [id];
}

class AddMovieWatchlist extends WatchlistMovieEvent {
  final MovieDetail movieDetail;

  AddMovieWatchlist(this.movieDetail);

  @override
  List<Object?> get props => [movieDetail];
}

class RemoveMovieWatchlist extends WatchlistMovieEvent {
  final MovieDetail movieDetail;

  RemoveMovieWatchlist(this.movieDetail);

  @override
  List<Object?> get props => [movieDetail];
}
