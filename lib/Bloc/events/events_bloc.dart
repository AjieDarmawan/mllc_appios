import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';
import 'package:dio/dio.dart' as DIO;
part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final HttpProvider httpProvider;
  EventsBloc(this.httpProvider) : super(EventsInitial()) {
    on<EventsEvent>(eventHandler);
  }

  // renamed/migrated from mapEventToState
  eventHandler(event, emit) {
    if (event is GetEventsList) {
      return _mapGetEventsListToState(event, emit);
    } else if (event is GetEventDetails) {
      return _mapEventDetailsToState(event, emit);
    } else if (event is JoinEvent) {
      return _mapJoinEventToState(event, emit);
    } else if (event is UpdateFavoriteEvents) {
      return _mapUpdateFavoriteToState(event, emit);
    }
  }

  void _mapUpdateFavoriteToState(event, emit) async {
    final DIO.FormData data = DIO.FormData.fromMap({
      'user_id': event.formData['user_id'],
      'device_id': event.formData['device_id'],
      'event_id': event.formData['event_id'],
    });

    var trainersListDataReturn =
        await httpProvider.postHttp("event/favourite", data);
    if (trainersListDataReturn != null) {
      Get.snackbar('Add to favorite successfully', '',
          backgroundColor: kPrimaryColor, colorText: Colors.white);
      emit(GetEventsListSuccessful(
          "Update Successful", trainersListDataReturn, '', ''));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapGetEventsListToState(event, emit) async {
    emit(EventsLoading());

    print("eventtes12${event.arg['user_id']}");
    //print("eventtesya${event.formData['user_id']}");
    // var eventsListDataReturn = await httpProvider.getHttp("event/listing");
    var eventsListDataReturn = await httpProvider.getHttp(
        "event/upcoming?user_id=${event.arg['user_id']}&log_user_id${event.arg['user_id']}");

    var eventsListDataReturnPast = await httpProvider.getHttp("event/past");

    var formData = {
      'user_id': event.arg['user_id'],
      'log_user_id': event.arg['user_id']
    };
    var eventsListDataJoinReturn = await httpProvider.postHttp(
        "event/joined?log_user_id${event.arg['user_id']}", formData);

    if (eventsListDataReturn != null) {
      emit(GetEventsListSuccessful(
          "Get Events List Successful",
          eventsListDataReturn,
          eventsListDataJoinReturn,
          eventsListDataReturnPast));
    } else {
      emit(const NoEventsFound("No Events Found"));
    }
  }

  void _mapEventDetailsToState(event, emit) async {
    emit(EventsLoading());
    var eventDetailDataReturn =
        await httpProvider.postHttp("event/info", {'event_id': event.id});
    if (eventDetailDataReturn != null) {
      emit(GetEventDetailSuccessful(
          "Get Event Details Successful", eventDetailDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapJoinEventToState(event, emit) async {
    emit(EventsLoading());
    var joinEventDataReturn =
        await httpProvider.postHttp("event/participate", event.arg);
    if (joinEventDataReturn ==
        "Thank you for joining this event. You will receive notification on the day of event.") {
      emit(JoinEventSuccessful("Join Event Successful", joinEventDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }
}
