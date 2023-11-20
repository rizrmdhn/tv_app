import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_recommendation_event.dart';
part 'tv_recommendation_state.dart';

class TvRecommendationBloc
    extends Bloc<TvRecommendationEvent, TvRecommendationState> {
  final GetTvRecommendations getTvRecommendations;

  TvRecommendationBloc(this.getTvRecommendations)
      : super(TvRecommendationInitial()) {
    on<LoadTvRecommendation>(
        (event, emit) => fetchTvRecommendation(event, emit));
  }

  Future<void> fetchTvRecommendation(
      LoadTvRecommendation event, Emitter<TvRecommendationState> emit) async {
    emit(TvRecommendationLoading());

    final result = await getTvRecommendations.execute(event.id);

    result.fold(
      (failure) => emit(TvRecommendationError(failure.message)),
      (tvData) {
        if (tvData.isEmpty) {
          emit(const TvRecommendationNoData('No Data'));
        } else {
          emit(TvRecommendationHasData(tvData));
        }
      },
    );
  }
}
