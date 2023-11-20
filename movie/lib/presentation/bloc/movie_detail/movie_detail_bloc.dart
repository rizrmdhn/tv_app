import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;

  MovieDetailBloc(this.getMovieDetail) : super(MovieDetailInitial()) {
    on<LoadMovieDetail>(fetchMovieDetail);
  }

  Future<void> fetchMovieDetail(
      LoadMovieDetail event, Emitter<MovieDetailState> emit) async {
    final id = event.id;

    emit(MovieDetailLoading());

    final result = await getMovieDetail.execute(id);

    result.fold(
      (failure) => emit(MovieDetailError(failure.message)),
      (movieDetail) => emit(MovieDetailHasData(movieDetail)),
    );
  }
}
