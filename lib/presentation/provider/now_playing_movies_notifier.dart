import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:flutter/cupertino.dart';

class NowPlayingMoviesNotifier extends ChangeNotifier {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMoviesNotifier({required this.getNowPlayingMovies});

  List<Movie> _nowPlayingMovies = [];
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  Future<void> fetchNowPlayingMovies() async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getNowPlayingMovies.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.error;
        notifyListeners();
      },
      (moviesData) {
        _nowPlayingMovies = moviesData;
        _state = RequestState.loaded;
        notifyListeners();
      },
    );
  }
}
