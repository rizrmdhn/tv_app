import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_top_rated_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTv _getTopRatedTv;

  TopRatedTvBloc(this._getTopRatedTv) : super(TopRatedTvInitial()) {
    on<LoadTopRatedTv>((event, emit) => fetchTopRatedTv(event, emit));
  }

  Future<void> fetchTopRatedTv(
      LoadTopRatedTv event, Emitter<TopRatedTvState> emit) async {
    emit(TopRatedTvLoading());

    final result = await _getTopRatedTv.execute();

    result.fold(
      (failure) => emit(TopRatedTvError(failure.message)),
      (tvData) {
        if (tvData.isEmpty) {
          emit(const TopRatedTvNoData('No Data'));
        } else {
          emit(TopRatedTvHasData(tvData));
        }
      },
    );
  }
}
