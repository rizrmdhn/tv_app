part of 'now_playing_movie_bloc.dart';

abstract class NowPlayingMovieState extends Equatable {
  const NowPlayingMovieState();

  @override
  List<Object?> get props => [];
}

class NowPlayingMovieInitial extends NowPlayingMovieState {}

class NowPlayingMovieLoading extends NowPlayingMovieState {}

class NowPlayingMovieHasData extends NowPlayingMovieState {
  final List<Movie> nowPlayingMovie;

  const NowPlayingMovieHasData(this.nowPlayingMovie);

  @override
  List<Object?> get props => [nowPlayingMovie];
}

class NowPlayingMovieError extends NowPlayingMovieState {
  final String message;

  const NowPlayingMovieError(this.message);

  @override
  List<Object?> get props => [message];
}

class NowPlayingMovieHasNoData extends NowPlayingMovieState {
  final String message;

  const NowPlayingMovieHasNoData(this.message);

  @override
  List<Object?> get props => [message];
}
