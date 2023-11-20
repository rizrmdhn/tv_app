part of 'movie_recommendation_bloc.dart';

abstract class MovieRecommendationState extends Equatable {
  const MovieRecommendationState();

  @override
  List<Object?> get props => [];
}

class MovieRecommendationInitial extends MovieRecommendationState {}

class MovieRecommendationLoading extends MovieRecommendationState {}

class MovieRecommendationHasData extends MovieRecommendationState {
  final List<Movie> movieRecommendation;

  const MovieRecommendationHasData(this.movieRecommendation);

  @override
  List<Object?> get props => [movieRecommendation];
}

class MovieRecommendationError extends MovieRecommendationState {
  final String message;

  const MovieRecommendationError(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieRecommendationHasNoData extends MovieRecommendationState {
  final String message;

  const MovieRecommendationHasNoData(this.message);

  @override
  List<Object?> get props => [message];
}
