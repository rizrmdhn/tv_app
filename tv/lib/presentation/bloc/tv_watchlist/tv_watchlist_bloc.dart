import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/usecases/get_tv_watchlist_status.dart';
import 'package:core/domain/usecases/get_watchlist_tv.dart';
import 'package:core/domain/usecases/tv_remove_watchlist.dart';
import 'package:core/domain/usecases/tv_save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_watchlist_event.dart';
part 'tv_watchlist_state.dart';

class TvWatchlistBloc extends Bloc<TvWatchlistEvent, TvWatchlistState> {
  final GetWatchListTv _getWatchlistTv;
  final TvSaveWatchList _saveWatchlistTv;
  final TvRemoveWatchList _removeWatchlistTv;
  final GetTvWatchlistStatus _checkWatchlistTv;

  TvWatchlistBloc(this._getWatchlistTv, this._saveWatchlistTv,
      this._removeWatchlistTv, this._checkWatchlistTv)
      : super(TvWatchlistInitial()) {
    on<LoadTvWatchlist>((event, emit) => fetchWatchlistTv(event, emit));
    on<AddTvWatchlist>((event, emit) => saveWatchlistTv(event, emit));
    on<RemoveTvWatchlist>((event, emit) => removeWatchlistTv(event, emit));
    on<LoadSavedTvWatchlist>((event, emit) => checkWatchlistTv(event, emit));
  }

  Future<void> fetchWatchlistTv(
    LoadTvWatchlist event,
    Emitter<TvWatchlistState> emit,
  ) async {
    emit(TvWatchlistLoading());

    final result = await _getWatchlistTv.execute();

    result.fold(
      (failure) => emit(TvWatchlistError(failure.message)),
      (data) {
        if (data.isEmpty) {
          emit(const TvWatchlistNoData('No watchlist data'));
        } else {
          emit(TvWatchlistHasData(data));
        }
      },
    );
  }

  Future<void> saveWatchlistTv(
    AddTvWatchlist event,
    Emitter<TvWatchlistState> emit,
  ) async {
    final TvDetail tvDetail = event.tvDetail;
    final result = await _saveWatchlistTv.execute(tvDetail);

    result.fold(
      (failure) => emit(TvWatchlistError(failure.message)),
      (success) => emit(TvWatchlistMessage(success)),
    );
  }

  Future<void> removeWatchlistTv(
    RemoveTvWatchlist event,
    Emitter<TvWatchlistState> emit,
  ) async {
    final TvDetail tvDetail = event.tvDetail;
    final result = await _removeWatchlistTv.execute(tvDetail);

    result.fold(
      (failure) => emit(TvWatchlistError(failure.message)),
      (success) => emit(TvWatchlistMessage(success)),
    );
  }

  Future<void> checkWatchlistTv(
    LoadSavedTvWatchlist event,
    Emitter<TvWatchlistState> emit,
  ) async {
    final result = await _checkWatchlistTv.execute(event.id);

    if (result) {
      emit(const TvWatchlistIsAdded(true));
    } else {
      emit(const TvWatchlistIsAdded(false));
    }
  }
}
