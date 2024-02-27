import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';

part 'adv_event.dart';
part 'adv_state.dart';

class AdvBloc extends Bloc<AdvEvent, AdvState> {
  final HttpProvider httpProvider;
  AdvBloc(this.httpProvider) : super(AdvInitial()) {
    on<AdvEvent>(eventHandler);
  }

  // renamed/migrated from mapEventToState
  eventHandler(event, emit) {
    if (event is GetAdvList) {
      return _mapGetAdvListToState(event, emit);
    } else if (event is GetAdvDetails) {
      return _mapGetAdvDetailsToState(event, emit);
    } else if (event is RedeemAdv) {
      return _mapRedeemAdvToState(event, emit);
    } else if (event is GetProductDetails) {
      return _mapGetProductDetailsToState(event, emit);
    } else if (event is GetSponsoredAdvDetails) {
      return _mapGetSponsoredListToState(event, emit);
    }
  }

  void _mapGetAdvListToState(event, emit) async {
    emit(AdvLoading());
    var advListDataReturn =
        await httpProvider.getHttp3("advertisement/listing");
    if (advListDataReturn != null) {
      var vouchersList = advListDataReturn[0]['vouchers'];
      var rewardsList = advListDataReturn[0]['rewards'];
      var productsList = advListDataReturn[0]['product'];
      emit(GetAdvListSuccessful(
          "Get Adv List Successful", vouchersList, rewardsList, productsList));
    } else {
      emit(const NoAdvFound("No Adv Found"));
    }
  }

  void _mapGetSponsoredListToState(event, emit) async {
    emit(AdvLoading());
    var advListDataReturn =
        await httpProvider.getHttp3("advertisement/sponsored_ads");
    if (advListDataReturn != null) {
      emit(GetSponsoredAdvListSuccessful(
          "Get Sponsored Adv List Successful", advListDataReturn));
    } else {
      emit(const NoAdvFound("No Sponsored Adv Found"));
    }
  }

  void _mapGetAdvDetailsToState(event, emit) async {
    emit(AdvLoading());
    var advDetailDataReturn = await httpProvider
        .postHttp3("advertisement/info", {'advertisement_id': event.id});
    if (advDetailDataReturn != null) {
      emit(GetAdvDetailSuccessful(
          "Get Adv Details Successful", advDetailDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapGetProductDetailsToState(event, emit) async {
    emit(AdvLoading());
    var advDetailDataReturn =
        await httpProvider.postHttp3("product_info", {'product_id': event.id});
    if (advDetailDataReturn != null) {
      emit(GetProductDetailSuccessful(
          "Get Adv Details Successful", advDetailDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapRedeemAdvToState(event, emit) async {
    emit(AdvLoading());

    var formData = {
      'advertisement_id': event.args['advertisement_id'],
      'user_id': event.args['user_id']
    };
    var redeemAdvDataReturn =
        await httpProvider.postHttp3("advertisement/redeem", formData);
    if (redeemAdvDataReturn == "Thank you for redeem this voucher / rewards.") {
      // emit(RedeemAdvSuccessful("Redeem Adv Successful", redeemAdvDataReturn));
      var advDetailDataReturn = await httpProvider
          .postHttp3("advertisement/info", {'advertisement_id': event.id});
      if (advDetailDataReturn != null) {
        emit(GetAdvDetailSuccessful(
            "Get Adv Details Successful", advDetailDataReturn));
      } else {
        emit(const ErrorOccured());
      }
    } else {
      emit(const ErrorOccured());
    }
  }
}
