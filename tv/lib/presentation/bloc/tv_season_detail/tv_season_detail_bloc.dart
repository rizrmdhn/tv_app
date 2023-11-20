import 'package:core/domain/entities/season_detail.dart';
import 'package:core/domain/usecases/get_tv_season_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_season_detail_event.dart';
part 'tv_season_detail_state.dart';

class TvSeasonDetailBloc
    extends Bloc<TvSeasonDetailEvent, TvSeasonDetailState> {
  final GetTvSeasonDetail getTvSeasonDetail;

  TvSeasonDetailBloc(
    this.getTvSeasonDetail,
  ) : super(TvSeasonDetailInitial()) {
    on<LoadTvSeasonDetail>((event, emit) => fetchTvSeasonDetail(event, emit));
  }

  Future<void> fetchTvSeasonDetail(
      LoadTvSeasonDetail event, Emitter<TvSeasonDetailState> emit) async {
    final int id = event.id;
    final int seasonNumber = event.seasonNumber;

    emit(TvSeasonDetailLoading());

    final result = await getTvSeasonDetail.execute(id, seasonNumber);

    result.fold(
      (failure) => emit(TvSeasonDetailError(failure.message)),
      (data) => emit(TvSeasonDetailLoaded(data)),
    );
  }
}
