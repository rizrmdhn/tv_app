part of 'tv_production_companies_bloc.dart';

abstract class TvProductionCompaniesState extends Equatable {
  const TvProductionCompaniesState();

  @override
  List<Object> get props => [];
}

class TvProductionCompaniesInitial extends TvProductionCompaniesState {}

class TvProductionCompaniesLoading extends TvProductionCompaniesState {}

class TvProductionCompaniesHasData extends TvProductionCompaniesState {
  final List<ProductionCompany> result;

  const TvProductionCompaniesHasData(this.result);

  @override
  List<Object> get props => [result];
}

class TvProductionCompaniesError extends TvProductionCompaniesState {
  final String message;

  const TvProductionCompaniesError(this.message);

  @override
  List<Object> get props => [message];
}

class TvProductionCompaniesNoData extends TvProductionCompaniesState {
  final String message;

  const TvProductionCompaniesNoData(this.message);

  @override
  List<Object> get props => [message];
}
