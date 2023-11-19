part of 'tv_seasons_bloc.dart';

abstract class TvSeasonsEvent extends Equatable {}

class LoadTvSeasons extends TvSeasonsEvent {
  final int id;

  LoadTvSeasons(this.id);

  @override
  List<Object?> get props => [id];
}
