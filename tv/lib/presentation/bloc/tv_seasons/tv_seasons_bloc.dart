import 'package:core/domain/entities/season.dart';
import 'package:core/domain/usecases/get_tv_season.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_seasons_event.dart';
part 'tv_seasons_state.dart';

class TvSeasonsBloc extends Bloc<TvSeasonsEvent, TvSeasonsState> {
  final GetTvSeasons getTvSeasons;

  TvSeasonsBloc(this.getTvSeasons) : super(TvSeasonsInitial()) {
    on<LoadTvSeasons>((event, emit) => fetchTvSeasons(event, emit));
  }

  Future<void> fetchTvSeasons(
      LoadTvSeasons event, Emitter<TvSeasonsState> emit) async {
    final int id = event.id;

    emit(TvSeasonsLoading());

    final result = await getTvSeasons.execute(id);

    result.fold(
      (failure) => emit(TvSeasonsError(failure.message)),
      (data) {
        if (data.isEmpty) {
          emit(const TvSeasonsNoData('No Data'));
        } else {
          emit(TvSeasonsHasData(data));
        }
      },
    );
  }
}
