import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_popular_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popular_tv_event.dart';
part 'popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTv _getPopularTv;

  PopularTvBloc(this._getPopularTv) : super(PopularTvInitial()) {
    on<LoadPopularTv>((event, emit) => fetchPopularTv(event, emit));
  }

  Future<void> fetchPopularTv(
      LoadPopularTv event, Emitter<PopularTvState> emit) async {
    emit(PopularTvLoading());

    final result = await _getPopularTv.execute();

    result.fold(
      (failure) => emit(PopularTvError(failure.message)),
      (tvData) {
        if (tvData.isEmpty) {
          emit(const PopularTvNoData('No Data'));
        } else {
          emit(PopularTvHasData(tvData));
        }
      },
    );
  }
}
