import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'now_playing_movie_event.dart';
part 'now_playing_movie_state.dart';

class NowPlayingMovieBloc
    extends Bloc<NowPlayingMovieEvent, NowPlayingMovieState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMovieBloc(this.getNowPlayingMovies)
      : super(NowPlayingMovieInitial()) {
    on<LoadNowPlayingMovie>(fetchNowPlayingMovie);
  }

  Future<void> fetchNowPlayingMovie(
      LoadNowPlayingMovie event, Emitter<NowPlayingMovieState> emit) async {
    emit(NowPlayingMovieLoading());

    final result = await getNowPlayingMovies.execute();

    result.fold(
      (failure) => emit(NowPlayingMovieError(failure.message)),
      (moviesData) {
        if (moviesData.isEmpty) {
          emit(const NowPlayingMovieHasNoData('No Data'));
        } else {
          emit(NowPlayingMovieHasData(moviesData));
        }
      },
    );
  }
}
