import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/season_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_season_detail.dart';
import 'package:flutter/material.dart';

class TvSeasonDetailNotifier extends ChangeNotifier {
  final GetTvSeasonDetail getTvSeasonDetail;

  TvSeasonDetailNotifier({
    required this.getTvSeasonDetail,
  });

  late SeasonDetail _tvSeasonDetail;
  SeasonDetail get tvSeasonDetail => _tvSeasonDetail;

  RequestState _tvSeasonDetailState = RequestState.empty;
  RequestState get tvSeasonDetailState => _tvSeasonDetailState;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvSeasonDetail(int tvId, int seasonNumber) async {
    _tvSeasonDetailState = RequestState.loading;
    notifyListeners();

    final result = await getTvSeasonDetail.execute(tvId, seasonNumber);
    result.fold(
      (failure) {
        _tvSeasonDetailState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _tvSeasonDetail = data;
        _tvSeasonDetailState = RequestState.loaded;
        notifyListeners();
      },
    );
  }
}
