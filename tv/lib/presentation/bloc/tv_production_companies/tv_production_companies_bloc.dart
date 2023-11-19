import 'package:core/domain/entities/production_company.dart';
import 'package:core/domain/usecases/get_tv_production_company.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_production_companies_event.dart';
part 'tv_production_companies_state.dart';

class TvProductionCompaniesBloc
    extends Bloc<TvProductionCompaniesEvent, TvProductionCompaniesState> {
  final GetTvProductionCompany _getTvProductionCompanies;

  TvProductionCompaniesBloc(this._getTvProductionCompanies)
      : super(TvProductionCompaniesInitial()) {
    on<LoadTvProductionCompanies>(
        (event, emit) => fetchTvProductionCompanies(event, emit));
  }

  Future<void> fetchTvProductionCompanies(LoadTvProductionCompanies event,
      Emitter<TvProductionCompaniesState> emit) async {
    final int id = event.id;

    emit(TvProductionCompaniesLoading());

    final result = await _getTvProductionCompanies.execute(id);

    result.fold(
      (failure) => emit(TvProductionCompaniesError(failure.message)),
      (data) {
        if (data.isEmpty) {
          emit(const TvProductionCompaniesNoData('No Data'));
        } else {
          emit(TvProductionCompaniesHasData(data));
        }
      },
    );
  }
}
