import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popular_movie_event.dart';
part 'popular_movie_state.dart';

class PopularMovieBloc extends Bloc<PopularMovieEvent, PopularMovieState> {
  final GetPopularMovies getPopularMovies;

  PopularMovieBloc(this.getPopularMovies) : super(PopularMovieInitial()) {
    on<LoadPopularMovie>(fetchPopularMovie);
  }

  Future<void> fetchPopularMovie(
      LoadPopularMovie event, Emitter<PopularMovieState> emit) async {
    emit(PopularMovieLoading());

    final result = await getPopularMovies.execute();

    result.fold(
      (failure) => emit(PopularMovieError(failure.message)),
      (moviesData) {
        if (moviesData.isEmpty) {
          emit(const PopularMovieHasNoData('No Data'));
        } else {
          emit(PopularMovieHasData(moviesData));
        }
      },
    );
  }
}
