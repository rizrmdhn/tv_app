import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/episode_detail.dart';
import 'package:ditonton/domain/usecases/get_episode_tv_detail.dart';
import 'package:flutter/foundation.dart';

class TvEpisodeDetailNotifier extends ChangeNotifier {
  final GetEpisodeTvDetail getEpisodeTvDetail;

  TvEpisodeDetailNotifier({
    required this.getEpisodeTvDetail,
  });

  late EpisodeDetail _episodeDetail;
  EpisodeDetail get episodeDetail => _episodeDetail;

  RequestState _episodeDetailState = RequestState.empty;
  RequestState get episodeDetailState => _episodeDetailState;

  String _message = '';
  String get message => _message;

  Future<void> fetchEpisodeDetail(
    int tvId,
    int seasonNumber,
    int episodeNumber,
  ) async {
    _episodeDetailState = RequestState.loading;
    notifyListeners();

    final result =
        await getEpisodeTvDetail.execute(tvId, seasonNumber, episodeNumber);
    result.fold(
      (failure) {
        _episodeDetailState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (data) {
        _episodeDetail = data;
        _episodeDetailState = RequestState.loaded;
        notifyListeners();
      },
    );
  }
}
