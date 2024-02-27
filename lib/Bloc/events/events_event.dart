part of 'events_bloc.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object> get props => [];
}

// class GetEventsList extends EventsEvent {
//   const GetEventsList();
//   @override
//   List<Object> get props => [];
// }

class GetEventsList extends EventsEvent {
  final dynamic arg;
  const GetEventsList(this.arg);
  @override
  List<Object> get props => [arg];
}

class GetEventDetails extends EventsEvent {
  final int id;

  const GetEventDetails(this.id);
  @override
  List<Object> get props => [id];
}

class JoinEvent extends EventsEvent {
  final dynamic arg;

  const JoinEvent(this.arg);
  @override
  List<Object> get props => [arg];
}

class UpdateFavoriteEvents extends EventsEvent {
  final dynamic formData;

  const UpdateFavoriteEvents(this.formData);
  @override
  List<Object> get props => [formData];
}
