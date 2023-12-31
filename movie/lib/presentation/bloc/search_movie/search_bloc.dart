import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/search_movies.dart';
import 'package:core/helpers/debouncer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';
part 'search_event.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies _searchMovies;

  SearchBloc(this._searchMovies) : super(SearchEmpty()) {
    on<OnQueryChanged>(
      (event, emit) async {
        final query = event.query;

        if (query.isEmpty) {
          emit(QueryEmpty());
          return;
        }

        emit(SearchLoading());
        final result = await _searchMovies.execute(query);

        result.fold(
          (failure) => emit(SearchError(failure.message)),
          (moviesData) => emit(SearchHasData(moviesData)),
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }
}
