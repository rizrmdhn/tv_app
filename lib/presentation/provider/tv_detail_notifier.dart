import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/production_company.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_production_company.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_tv_season.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/tv_remove_watchlist.dart';

import 'package:ditonton/domain/usecases/tv_save_watchlist.dart';
import 'package:flutter/material.dart';

class TvDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvProductionCompany getTvProductionCompany;
  final GetTvSeasons getTvSeasons;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final TvSaveWatchList saveWatchlist;
  final TvRemoveWatchList removeWatchlist;
  final GetWatchListStatus getWatchlistStatus;

  TvDetailNotifier({
    required this.getTvDetail,
    required this.getTvProductionCompany,
    required this.getTvSeasons,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
    required this.getWatchlistStatus,
  });

  late TvDetail _tv;
  TvDetail get tv => _tv;

  RequestState _tvState = RequestState.empty;
  RequestState get tvState => _tvState;

  List<ProductionCompany> _productionCompanies = [];
  List<ProductionCompany> get productionCompanies => _productionCompanies;

  RequestState _productionCompaniesState = RequestState.empty;
  RequestState get productionCompaniesState => _productionCompaniesState;

  List<Season> _seasons = [];
  List<Season> get seasons => _seasons;

  RequestState _seasonsState = RequestState.empty;
  RequestState get seasonsState => _seasonsState;

  List<Tv> _tvRecommendations = [];
  List<Tv> get tvRecommendations => _tvRecommendations;

  RequestState _recommendationState = RequestState.empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> fetchTvDetail(int id) async {
    _tvState = RequestState.loading;
    notifyListeners();
    final detailResult = await getTvDetail.execute(id);
    final productionCompaniesResult = await getTvProductionCompany.execute(id);
    final seasonsResult = await getTvSeasons.execute(id);
    final recommendationResult = await getTvRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) {
        _recommendationState = RequestState.loading;
        _tv = tv;
        notifyListeners();
        productionCompaniesResult.fold(
          (failure) {
            _productionCompaniesState = RequestState.error;
            _message = failure.message;
            notifyListeners();
          },
          (companies) {
            _productionCompaniesState = RequestState.loaded;
            _productionCompanies = companies;
            notifyListeners();
          },
        );
        seasonsResult.fold(
          (failure) {
            _seasonsState = RequestState.error;
            _message = failure.message;
            notifyListeners();
          },
          (seasons) {
            _seasonsState = RequestState.loaded;
            _seasons = seasons;
            notifyListeners();
          },
        );
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.error;
            _message = failure.message;
            notifyListeners();
          },
          (movies) {
            _recommendationState = RequestState.loaded;
            _tvRecommendations = movies;
            notifyListeners();
          },
        );

        _tvState = RequestState.loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(TvDetail tv) async {
    final result = await saveWatchlist.execute(tv);
    result.fold(
      (failure) {
        _watchlistMessage = failure.message;
        notifyListeners();
      },
      (_) {
        _isAddedtoWatchlist = true;
        _watchlistMessage = watchlistAddSuccessMessage;
        notifyListeners();
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    final result = await removeWatchlist.execute(tv);
    result.fold(
      (failure) {
        _watchlistMessage = failure.message;
        notifyListeners();
      },
      (_) {
        _isAddedtoWatchlist = false;
        _watchlistMessage = watchlistRemoveSuccessMessage;
        notifyListeners();
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
