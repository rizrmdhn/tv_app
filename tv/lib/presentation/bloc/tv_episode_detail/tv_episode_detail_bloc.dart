import 'package:core/domain/entities/episode_detail.dart';
import 'package:core/domain/usecases/get_episode_tv_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_episode_detail_event.dart';
part 'tv_episode_detail_state.dart';

class TvEpisodeDetailBloc
    extends Bloc<TvEpisodeDetailEvent, TvEpisodeDetailState> {
  final GetEpisodeTvDetail getTvEpisodeDetail;

  TvEpisodeDetailBloc(
    this.getTvEpisodeDetail,
  ) : super(TvEpisodeDetailInitial()) {
    on<TvEpisodeDetailLoad>(
      (event, emit) => fetchTvEpisodeDetail(event, emit),
    );
  }

  Future<void> fetchTvEpisodeDetail(
    TvEpisodeDetailLoad event,
    Emitter<TvEpisodeDetailState> emit,
  ) async {
    final int tvId = event.tvId;
    final int seasonNumber = event.seasonNumber;
    final int episodeNumber = event.episodeNumber;

    emit(TvEpisodeDetailLoading());

    final result =
        await getTvEpisodeDetail.execute(tvId, seasonNumber, episodeNumber);

    result.fold(
      (failure) => emit(TvEpisodeDetailError(failure.message)),
      (data) => emit(TvEpisodeDetailLoaded(data)),
    );
  }
}
