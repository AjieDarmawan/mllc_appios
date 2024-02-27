import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';
import 'package:dio/dio.dart' as DIO;
part 'trainings_event.dart';
part 'trainings_state.dart';

class TrainingsBloc extends Bloc<TrainingsEvent, TrainingsState> {
  final HttpProvider httpProvider;
  TrainingsBloc(this.httpProvider) : super(TrainingsInitial()) {
    on<TrainingsEvent>(eventHandler);
  }

  // renamed/migrated from mapEventToState
  eventHandler(event, emit) {
    if (event is GetTrainersList) {
      return _mapGetTrainersListToState(event, emit);
    } else if (event is GetTrainingsList) {
      return _mapGetTrainingsListToState(event, emit);
    } else if (event is GetTrainingDetails) {
      return _mapGetTrainingDetailsToState(event, emit);
    } else if (event is JoinTraining) {
      return _mapJoinTrainingToState(event, emit);
    } else if (event is UpdateFavoriteTraining) {
      return _mapUpdateFavoriteToState(event, emit);
    } else if (event is UpdateFavoriteTrainer) {
      return _mapUpdateFavoriteTrainerToState(event, emit);
    } else if (event is UpdateFavoriteMedia) {
      return _mapUpdateFavoriteMediaToState(event, emit);
    }
  }

  void _mapUpdateFavoriteTrainerToState(event, emit) async {
    final DIO.FormData data = DIO.FormData.fromMap({
      'user_id': event.formData['user_id'],
      'device_id': event.formData['device_id'],
      'trainer_id': event.formData['trainer_id'],
    });

    var trainersListDataReturn =
        await httpProvider.postHttp("trainer/favourite", data);
    if (trainersListDataReturn != null) {
      Get.snackbar('Add to favorite successfully', '',
          backgroundColor: kPrimaryColor, colorText: Colors.white);
      // emit(GetTrainersListSuccessful(
      //     "Update Successful", trainersListDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapUpdateFavoriteMediaToState(event, emit) async {
    final DIO.FormData data = DIO.FormData.fromMap({
      'user_id': event.formData['user_id'],
      'media_id': event.formData['media_id'],
    });

    var trainersListDataReturn =
        await httpProvider.postHttp("video/favourite", data);
    if (trainersListDataReturn != null) {
      Get.snackbar('Add to favorite successfully', '',
          backgroundColor: kPrimaryColor, colorText: Colors.white);
      // emit(GetTrainersListSuccessful(
      //     "Update Successful", trainersListDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapUpdateFavoriteToState(event, emit) async {
    final DIO.FormData data = DIO.FormData.fromMap({
      'user_id': event.formData['user_id'],
      'device_id': event.formData['device_id'],
      'training_id': event.formData['training_id'],
    });

    var trainersListDataReturn =
        await httpProvider.postHttp("training/favourite", data);
    if (trainersListDataReturn != null) {
      Get.snackbar('Add to favorite successfully', '',
          backgroundColor: kPrimaryColor, colorText: Colors.white);
      emit(GetTrainersListSuccessful(
          "Update Successful", trainersListDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapGetTrainersListToState(event, emit) async {
    emit(TrainingsLoading());
    var trainersListDataReturn = await httpProvider.getHttp("trainer/listing");
    if (trainersListDataReturn != null) {
      emit(GetTrainersListSuccessful(
          "Get Trainers List Successful", trainersListDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapGetTrainingsListToState(event, emit) async {
    emit(TrainingsLoading());
    var trainingsListDataReturn = await httpProvider
        .postHttp("training/listing", {'trainer_id': event.arg['id']});
    if (trainingsListDataReturn != null) {
      emit(GetTrainingsListSuccessful(
          "Get Trainings List Successful", trainingsListDataReturn));
    } else {
      emit(const NoTrainingsFound("No Trainings Found"));
    }
  }

  void _mapGetTrainingDetailsToState(event, emit) async {
    emit(TrainingsLoading());
    var trainingDetailsDataReturn =
        await httpProvider.postHttp("training/info", {'training_id': event.id});
    if (trainingDetailsDataReturn != null) {
      emit(GetTrainingDetailsSuccessful(
          "Get Training Details Successful", trainingDetailsDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapJoinTrainingToState(event, emit) async {
    emit(TrainingsLoading());
    var joinTrainingDataReturn =
        await httpProvider.postHttp("training/participate", event.arg);
    if (joinTrainingDataReturn ==
        "Thank you for enrolling to this training. You will receive notification once the training is started.") {
      emit(JoinTrainingSuccessful(
          "Join Training Successful", joinTrainingDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }
}
