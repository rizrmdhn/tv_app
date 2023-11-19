part of 'tv_production_companies_bloc.dart';

abstract class TvProductionCompaniesEvent extends Equatable {}

class LoadTvProductionCompanies extends TvProductionCompaniesEvent {
  final int id;

  LoadTvProductionCompanies(this.id);

  @override
  List<Object> get props => [id];
}
