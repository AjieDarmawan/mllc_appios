import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';
import 'package:dio/dio.dart' as DIO;
part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final HttpProvider httpProvider;
  DashboardBloc(this.httpProvider) : super(DashboardInitial()) {
    on<DashboardEvent>(eventHandler);
  }

  // renamed/migrated from mapEventToState
  eventHandler(event, emit) {
    if (event is GetBannerNewsletter) {
      return _mapGetBannerNewsletterToState(event, emit);
    } else if (event is GetRequestList) {
      return _mapGetRequestListToState(event, emit);
    } else if (event is GetRefferalList) {
      return _mapGetRefferalListToState(event, emit);
    } else if (event is ClearServices) {
      emit(DashboardInitial());
    } else if (event is UpdateRequestList) {
      return _mapUpdateRequestListToState(event, emit);
    } else if (event is UpdateRefferalList) {
      return _mapUpdateRefferalListToState(event, emit);
    } else if (event is GetOrderList) {
      return _mapGetOrderListToState(event, emit);
    } else if (event is GetOrderDetail) {
      return _mapGetOrderDetailToState(event, emit);
    }
  }

  void _mapGetRequestListToState(event, emit) async {
    emit(DashboardLoading());

    var entrepreneurDetailDataReturn = await httpProvider
        .postHttp2("entrepreneur/connect/listing", {'user_id': event.arg});
    if (entrepreneurDetailDataReturn != null) {
      emit(GetReqestListSuccessful(
          "Get Request List Successful", entrepreneurDetailDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapGetRefferalListToState(event, emit) async {
    emit(DashboardLoading());

    var entrepreneurDetailDataReturn = await httpProvider
        .postHttp2("entrepreneur/referral/listing", {'user_id': event.arg});
    if (entrepreneurDetailDataReturn != null) {
      emit(GetRefferalListSuccessful("Get Referral Request List Successful",
          entrepreneurDetailDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapGetOrderListToState(event, emit) async {
    emit(DashboardLoading());

    var entrepreneurDetailDataReturn =
        await httpProvider.postHttp3("order_history", {'user_id': event.arg});
    if (entrepreneurDetailDataReturn != null) {
      emit(GetOrderListSuccessful(
          "Get Order List Successful", entrepreneurDetailDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapGetOrderDetailToState(event, emit) async {
    emit(DashboardLoading());

    var entrepreneurDetailDataReturn =
        await httpProvider.postHttp3("order_info", {'order_id': event.arg});
    if (entrepreneurDetailDataReturn != null) {
      emit(GetOrderDetailSuccessful(
          "Get Order List Successful", entrepreneurDetailDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapUpdateRequestListToState(event, emit) async {
    final DIO.FormData data = DIO.FormData.fromMap({
      'user_id': event.formData['user_id'],
      'connect_id': event.formData['connect_id'],
      'status': event.formData['status'],
    });

    var requestListDataReturn =
        await httpProvider.postHttp2("entrepreneur/connect/update", data);
    if (requestListDataReturn != null) {
      Get.snackbar('Update Request Successfully', '',
          backgroundColor: kPrimaryColor, colorText: Colors.white);
      // emit(GetBannerNewsletterSuccessful("Update Successful", requestListDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapUpdateRefferalListToState(event, emit) async {
    final DIO.FormData data = DIO.FormData.fromMap({
      'user_id': event.formData['user_id'],
      'refer_id': event.formData['refer_id'],
      'status': event.formData['status'],
      'reason': event.formData['reason'],
    });

    var requestListDataReturn =
        await httpProvider.postHttp2("entrepreneur/referral/update", data);
    if (requestListDataReturn != null) {
      Get.snackbar('Update Request Successfully', '',
          backgroundColor: kPrimaryColor, colorText: Colors.white);
      // emit(GetBannerNewsletterSuccessful("Update Successful", requestListDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapGetBannerNewsletterToState(event, emit) async {
    List<String> banners = [];
    Map<String, dynamic> dataReturn = {};

    emit(DashboardLoading());
    List bannerDataReturn = await httpProvider.getHttp('banner');
    if (bannerDataReturn.isNotEmpty) {
      for (var element in bannerDataReturn) {
        banners.add(link + element);
      }
      dataReturn.addAll({'banner': banners});
    }

    var newsletterListDataReturn =
        await httpProvider.getHttp("newsletter/listing");
    if (newsletterListDataReturn != null) {
      dataReturn.addAll({'newsletter': newsletterListDataReturn});
    }

    if (dataReturn.isNotEmpty) {
      emit(GetBannerNewsletterSuccessful(
          "Get Banner Newsletter Successful", dataReturn));
    }
  }
}
