import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_movie_event.dart';
part 'top_rated_movie_state.dart';

class TopRatedMovieBloc extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  final GetTopRatedMovies getTopRatedMovie;

  TopRatedMovieBloc(this.getTopRatedMovie) : super(TopRatedMovieInitial()) {
    on<LoadTopRatedMovie>(fetchTopRatedMovie);
  }

  Future<void> fetchTopRatedMovie(
    LoadTopRatedMovie event,
    Emitter<TopRatedMovieState> emit,
  ) async {
    emit(TopRatedMovieLoading());
    final result = await getTopRatedMovie.execute();
    result.fold(
      (failure) => emit(TopRatedMovieError(failure.message)),
      (moviesData) {
        if (moviesData.isEmpty) {
          emit(const TopRatedMovieHasNoData('No Data'));
        } else {
          emit(TopRatedMovieHasData(moviesData));
        }
      },
    );
  }
}
