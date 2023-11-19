part of 'tv_season_detail_bloc.dart';

abstract class TvSeasonDetailState extends Equatable {
  const TvSeasonDetailState();

  @override
  List<Object> get props => [];
}

class TvSeasonDetailInitial extends TvSeasonDetailState {}

class TvSeasonDetailLoading extends TvSeasonDetailState {}

class TvSeasonDetailLoaded extends TvSeasonDetailState {
  final SeasonDetail seasonDetail;

  const TvSeasonDetailLoaded(
    this.seasonDetail,
  );

  @override
  List<Object> get props => [seasonDetail];
}

class TvSeasonDetailError extends TvSeasonDetailState {
  final String message;

  const TvSeasonDetailError(
    this.message,
  );

  @override
  List<Object> get props => [message];
}
