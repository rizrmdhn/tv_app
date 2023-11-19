import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/search_tv.dart';
import 'package:core/helpers/debouncer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_tv_event.dart';
part 'search_tv_state.dart';

class SearchTvBloc extends Bloc<SearchEvent, SearchState> {
  final SearchTv _searchTv;

  SearchTvBloc(this._searchTv) : super(SearchEmpty()) {
    on<OnQueryChanged>(
      (event, emit) async {
        final query = event.query;

        if (query.isEmpty) {
          emit(QueryEmpty());
          return;
        }

        emit(SearchLoading());
        final result = await _searchTv.execute(query);

        result.fold(
          (failure) => emit(SearchError(failure.message)),
          (tvData) {
            if (tvData.isEmpty) {
              emit(SearchNoData());
            } else {
              emit(SearchHasData(tvData));
            }
          },
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }
}
