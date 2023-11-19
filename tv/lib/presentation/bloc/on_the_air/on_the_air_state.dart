part of 'on_the_air_bloc.dart';

abstract class OnTheAirState extends Equatable {
  const OnTheAirState();

  @override
  List<Object> get props => [];
}

class OnTheAirInitial extends OnTheAirState {}

class OnTheAirLoading extends OnTheAirState {}

class OnTheAirError extends OnTheAirState {
  final String message;

  const OnTheAirError(this.message);

  @override
  List<Object> get props => [message];
}

class OnTheAirHasData extends OnTheAirState {
  final List<Tv> result;

  const OnTheAirHasData(this.result);

  @override
  List<Object> get props => [result];
}

class OnTheAirNoData extends OnTheAirState {
  final String message;

  const OnTheAirNoData(this.message);

  @override
  List<Object> get props => [message];
}
