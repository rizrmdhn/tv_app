import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies _getWatchlistMovie;
  final SaveWatchlist _saveWatchlistMovie;
  final RemoveWatchlist _removeWatchlistMovie;
  final GetWatchListStatus _checkWatchlistMovie;

  WatchlistMovieBloc(this._getWatchlistMovie, this._saveWatchlistMovie,
      this._removeWatchlistMovie, this._checkWatchlistMovie)
      : super(WatchlistMovieInitial()) {
    on<LoadWatchlistMovie>(fetchWatchlistMovie);
    on<AddMovieWatchlist>(saveWatchlistMovie);
    on<RemoveMovieWatchlist>(removeWatchlistMovie);
    on<LoadSavedMovieWatchlist>(checkWatchlistMovie);
  }

  Future<void> fetchWatchlistMovie(
    LoadWatchlistMovie event,
    Emitter<WatchlistMovieState> emit,
  ) async {
    emit(WatchlistMovieLoading());

    final result = await _getWatchlistMovie.execute();

    result.fold(
      (failure) => emit(WatchlistMovieError(failure.message)),
      (data) {
        if (data.isEmpty) {
          emit(const WatchlistMovieNoData('No watchlist data'));
        } else {
          emit(WatchlistMovieHasData(data));
        }
      },
    );
  }

  Future<void> saveWatchlistMovie(
    AddMovieWatchlist event,
    Emitter<WatchlistMovieState> emit,
  ) async {
    final MovieDetail movieDetail = event.movieDetail;
    final result = await _saveWatchlistMovie.execute(movieDetail);

    result.fold(
      (failure) => emit(WatchlistMovieError(failure.message)),
      (success) => emit(WatchlistMovieMessage(success)),
    );
  }

  Future<void> removeWatchlistMovie(
    RemoveMovieWatchlist event,
    Emitter<WatchlistMovieState> emit,
  ) async {
    final MovieDetail movie = event.movieDetail;
    final result = await _removeWatchlistMovie.execute(movie);

    result.fold(
      (failure) => emit(WatchlistMovieError(failure.message)),
      (success) => emit(WatchlistMovieMessage(success)),
    );
  }

  Future<void> checkWatchlistMovie(
    LoadSavedMovieWatchlist event,
    Emitter<WatchlistMovieState> emit,
  ) async {
    final result = await _checkWatchlistMovie.execute(event.id);

    if (result) {
      emit(const WatchlistMovieIsAdded(true));
    } else {
      emit(const WatchlistMovieIsAdded(false));
    }
  }
}
