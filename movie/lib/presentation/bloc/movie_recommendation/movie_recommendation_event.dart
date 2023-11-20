part of 'movie_recommendation_bloc.dart';

abstract class MovieRecommendationEvent extends Equatable {}

class LoadMovieRecommendation extends MovieRecommendationEvent {
  final int id;

  LoadMovieRecommendation(this.id);

  @override
  List<Object?> get props => [id];
}
