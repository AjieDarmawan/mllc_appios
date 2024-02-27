part of 'events_bloc.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object> get props => [];
}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class ErrorOccured extends EventsState {
  const ErrorOccured();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'Error Occured!';
}

class GetEventsListSuccessful extends EventsState {
  final String status;
  final dynamic eventsList;
  final dynamic eventsJoinList;
  final dynamic eventsPastList;

  const GetEventsListSuccessful(
      this.status, this.eventsList, this.eventsJoinList, this.eventsPastList);
  @override
  List<Object> get props =>
      [status, eventsList, eventsJoinList, eventsPastList];
  @override
  String toString() => status;
}

class NoEventsFound extends EventsState {
  final String status;

  const NoEventsFound(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => status;
}

class GetEventDetailSuccessful extends EventsState {
  final String status;
  final dynamic eventData;

  const GetEventDetailSuccessful(this.status, this.eventData);
  @override
  List<Object> get props => [status, eventData];
  @override
  String toString() => status;
}

class JoinEventSuccessful extends EventsState {
  final String status;
  final dynamic joinEventData;

  const JoinEventSuccessful(this.status, this.joinEventData);
  @override
  List<Object> get props => [status, joinEventData];
  @override
  String toString() => status;
}
