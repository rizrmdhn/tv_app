part of 'tv_season_detail_bloc.dart';

abstract class TvSeasonDetailEvent extends Equatable {}

class LoadTvSeasonDetail extends TvSeasonDetailEvent {
  final int id;
  final int seasonNumber;

  LoadTvSeasonDetail(this.id, this.seasonNumber);

  @override
  List<Object?> get props => [id, seasonNumber];
}
