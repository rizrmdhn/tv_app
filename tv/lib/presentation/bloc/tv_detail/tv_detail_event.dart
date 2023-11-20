part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable {}

class LoadTvDetail extends TvDetailEvent {
  final int id;

  LoadTvDetail(this.id);

  @override
  List<Object?> get props => [id];
}
