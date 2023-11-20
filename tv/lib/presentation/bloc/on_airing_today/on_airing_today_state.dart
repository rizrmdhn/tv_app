part of 'on_airing_today_bloc.dart';

abstract class OnAiringTodayState extends Equatable {
  const OnAiringTodayState();

  @override
  List<Object?> get props => [];
}

class OnAiringTodayInitial extends OnAiringTodayState {}

class OnAiringTodayLoading extends OnAiringTodayState {}

class OnAiringTodayError extends OnAiringTodayState {
  final String message;

  const OnAiringTodayError(this.message);

  @override
  List<Object?> get props => [message];
}

class OnAiringTodayHasData extends OnAiringTodayState {
  final List<Tv> result;

  const OnAiringTodayHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class OnAiringTodayNoData extends OnAiringTodayState {
  final String message;

  const OnAiringTodayNoData(this.message);

  @override
  List<Object?> get props => [message];
}
