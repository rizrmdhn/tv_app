import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tv.dart';
import 'package:flutter/material.dart';

class OnAiringTodayNotifier extends ChangeNotifier {
  final GetAiringTodayTv getAiringTodayTv;

  OnAiringTodayNotifier({required this.getAiringTodayTv});

  List<Tv> _onAiringTodayTv = [];
  List<Tv> get onAiringTodayTv => _onAiringTodayTv;

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  Future<void> fetchOnAiringTodayTv() async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getAiringTodayTv.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.error;
        notifyListeners();
      },
      (tvData) {
        _onAiringTodayTv = tvData;
        _state = RequestState.loaded;
        notifyListeners();
      },
    );
  }
}
