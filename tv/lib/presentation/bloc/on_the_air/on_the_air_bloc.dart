import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_on_the_air_tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'on_the_air_event.dart';
part 'on_the_air_state.dart';

class OnTheAirBloc extends Bloc<OnTheAirEvent, OnTheAirState> {
  final GetOnTheAirTv _getOnTheAirTv;

  OnTheAirBloc(this._getOnTheAirTv) : super(OnTheAirInitial()) {
    on<LoadOnTheAirTv>((event, emit) => fetchOnTheAirTv(event, emit));
  }

  Future<void> fetchOnTheAirTv(
      LoadOnTheAirTv event, Emitter<OnTheAirState> emit) async {
    emit(OnTheAirLoading());

    final result = await _getOnTheAirTv.execute();

    result.fold(
      (failure) => emit(OnTheAirError(failure.message)),
      (tvData) {
        if (tvData.isEmpty) {
          emit(const OnTheAirNoData('No Data'));
        } else {
          emit(OnTheAirHasData(tvData));
        }
      },
    );
  }
}
