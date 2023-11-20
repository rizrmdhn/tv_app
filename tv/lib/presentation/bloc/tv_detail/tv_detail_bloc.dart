import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail _getTvDetail;

  TvDetailBloc(
    this._getTvDetail,
  ) : super(TvDetailInitial()) {
    on<LoadTvDetail>((event, emit) => _fetchTvDetail(event, emit));
  }

  Future<void> _fetchTvDetail(
      LoadTvDetail event, Emitter<TvDetailState> emit) async {
    final id = event.id;

    emit(TvDetailLoading());

    final detailResult = await _getTvDetail.execute(id);

    detailResult.fold(
      (failure) => emit(TvDetailError(failure.message)),
      (detailData) async {
        emit(TvDetailHasData(detailData));
      },
    );
  }
}
