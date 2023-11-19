part of 'tv_recommendation_bloc.dart';

abstract class TvRecommendationEvent extends Equatable {}

class LoadTvRecommendation extends TvRecommendationEvent {
  final int id;

  LoadTvRecommendation(this.id);

  @override
  List<Object?> get props => [id];
}
