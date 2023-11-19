import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_airing_today_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'on_airing_today_event.dart';
part 'on_airing_today_state.dart';

class OnAiringTodayBloc extends Bloc<OnAiringTodayEvent, OnAiringTodayState> {
  final GetAiringTodayTv _getAiringTodayTv;

  OnAiringTodayBloc(this._getAiringTodayTv) : super(OnAiringTodayInitial()) {
    on<LoadOnAiringTodayTv>((event, emit) => fetchOnAiringTodayTv(event, emit));
  }

  Future<void> fetchOnAiringTodayTv(
      LoadOnAiringTodayTv event, Emitter<OnAiringTodayState> emit) async {
    emit(OnAiringTodayLoading());

    final result = await _getAiringTodayTv.execute();

    result.fold(
      (failure) => emit(OnAiringTodayError(failure.message)),
      (tvData) {
        if (tvData.isEmpty) {
          emit(const OnAiringTodayNoData('No Data'));
        } else {
          emit(OnAiringTodayHasData(tvData));
        }
      },
    );
  }
}
