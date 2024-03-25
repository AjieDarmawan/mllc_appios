import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';
import 'package:dio/dio.dart' as DIO;

import '../../constant.dart';

part 'entrepreneurs_event.dart';
part 'entrepreneurs_state.dart';

class EntrepreneursBloc extends Bloc<EntrepreneursEvent, EntrepreneursState> {
  final HttpProvider httpProvider;
  EntrepreneursBloc(this.httpProvider) : super(EntrepreneursInitial()) {
    on<EntrepreneursEvent>(eventHandler);
  }

  // renamed/migrated from mapEventToState
  eventHandler(event, emit) {
    if (event is GetEntrepreneursList) {
      return _mapGetEntrepreneursListToState(event, emit);
    } else if (event is GetEntrepreneurDetails) {
      return _mapEntrepreneurDetailsToState(event, emit);
    } else if (event is ClearService) {
      emit(EntrepreneursInitial());
    } else if (event is UpdateToRequestConnected) {
      return _mapUpdateToRequestConnectedToState(event, emit);
    } else if (event is UpdateToRequestRefferal) {
      return _mapUpdateToRequestRefferalToState(event, emit);
    }
  }

  void _mapUpdateToRequestConnectedToState(event, emit) async {
    final DIO.FormData data = DIO.FormData.fromMap({
      'user_id': event.formData['user_id'],
      'connector_id': event.formData['connector_id'],
    });

    var enterpreneursListDataReturn =
        await httpProvider.postHttp2("entrepreneur/connect/request", data);
    if (enterpreneursListDataReturn != null) {
      Get.snackbar('Send Request Successfully', '',
          backgroundColor: kPrimaryColor, colorText: Colors.white);
      emit(GetEntrepreneursListSuccessful(
          "Update Successful", enterpreneursListDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapUpdateToRequestRefferalToState(event, emit) async {
    final DIO.FormData data = DIO.FormData.fromMap({
      'request_user_id': event.formData['request_user_id'],
      'user_id': event.formData['user_id'],
      'name': event.formData['name'],
      'contact': event.formData['contact'],
      'email': event.formData['email'],
      'remark': event.formData['remark'],
      'company_name': event.formData['company_name'],
      'company_address': event.formData['company_address'],
      'company_postcode': event.formData['company_postcode'],
      'company_city': event.formData['company_city'],
      'company_state_id': event.formData['company_state_id'],
      'company_country_id': event.formData['company_country_id'],
    });

    var enterpreneursListDataReturn =
        await httpProvider.postHttp2("entrepreneur/referral/request", data);
    print("enterpreneursListDataReturn${enterpreneursListDataReturn}");
    if (enterpreneursListDataReturn != null) {
      if (enterpreneursListDataReturn != "duplicate") {
        Get.snackbar('Send Request Successfully', '',
            backgroundColor: kPrimaryColor, colorText: Colors.white);
        emit(GetEntrepreneursListSuccessful(
            "Update Successful", enterpreneursListDataReturn));
      } else if (enterpreneursListDataReturn == "duplicate") {
        print("enterpreneursListDataReturn-duplicate");
        emit(const ErrorOccured());
      }
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapGetEntrepreneursListToState(event, emit) async {
    emit(EntrepreneursLoading());
    var entrepreneursListDataReturn = await httpProvider.getHttp(
        "entrepreneur/listing&user_id=${event.arg}&log_user_id=${event.arg}");
    if (entrepreneursListDataReturn != null) {
      emit(GetEntrepreneursListSuccessful(
          "Get Entrepreneurs List Successful", entrepreneursListDataReturn));
    } else {
      emit(const NoEntrepreneursFound("No Entrepreneurs Found"));
    }
  }

  void _mapEntrepreneurDetailsToState(event, emit) async {
    emit(EntrepreneursLoading());
    var formData = {
      'user_id': event.formData['user_id'],
      'log_user_id': event.formData['user_id']
    };
    var entrepreneurDetailDataReturn =
        await httpProvider.postHttp2("entrepreneur/info", formData);

//  'user_id': event.formData['user_id'],
//       'connector_id': event.formData['connector_id'],

    var formData_check_status = {
      'user_id': event.formData['user_id'],
      'log_user_id': event.formData['log_user_id']
    };

    print("formData_check_status${formData_check_status}");

    var check_status = await httpProvider.postHttp(
        "member/check_referral", formData_check_status);

    if (entrepreneurDetailDataReturn != null) {
      emit(GetEntrepreneurDetailSuccessful(
          "Get Entrepreneur Details Successful",
          entrepreneurDetailDataReturn,
          check_status));
    } else {
      emit(const ErrorOccured());
    }
  }
}
