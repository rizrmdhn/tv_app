part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {}

class OnQueryChanged extends SearchEvent {
  final String query;

  OnQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}
