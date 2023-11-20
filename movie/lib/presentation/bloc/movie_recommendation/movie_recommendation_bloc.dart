import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_recommendation_event.dart';
part 'movie_recommendation_state.dart';

class MovieRecommendationBloc
    extends Bloc<MovieRecommendationEvent, MovieRecommendationState> {
  final GetMovieRecommendations getMovieRecommendation;

  MovieRecommendationBloc(this.getMovieRecommendation)
      : super(MovieRecommendationInitial()) {
    on<LoadMovieRecommendation>(fetchMovieRecommendation);
  }

  Future<void> fetchMovieRecommendation(LoadMovieRecommendation event,
      Emitter<MovieRecommendationState> emit) async {
    final id = event.id;

    emit(MovieRecommendationLoading());

    final result = await getMovieRecommendation.execute(id);

    result.fold((failure) => emit(MovieRecommendationError(failure.message)),
        (movieRecommendation) {
      if (movieRecommendation.isEmpty) {
        emit(const MovieRecommendationHasNoData('No Data'));
      } else {
        emit(MovieRecommendationHasData(movieRecommendation));
      }
    });
  }
}
