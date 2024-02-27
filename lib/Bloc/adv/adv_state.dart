part of 'adv_bloc.dart';

abstract class AdvState extends Equatable {
  const AdvState();

  @override
  List<Object> get props => [];
}

class AdvInitial extends AdvState {}

class AdvLoading extends AdvState {}

class ErrorOccured extends AdvState {
  const ErrorOccured();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'Error Occured!';
}

class GetAdvListSuccessful extends AdvState {
  final String status;
  final dynamic vouchersList;
  final dynamic rewardsList;
  final dynamic productsList;

  const GetAdvListSuccessful(
      this.status, this.vouchersList, this.rewardsList, this.productsList);
  @override
  List<Object> get props => [status, vouchersList, rewardsList];
  @override
  String toString() => status;
}

class GetSponsoredAdvListSuccessful extends AdvState {
  final String status;
  final dynamic sponsoredList;

  const GetSponsoredAdvListSuccessful(this.status, this.sponsoredList);
  @override
  List<Object> get props => [status, sponsoredList];
  @override
  String toString() => status;
}

class NoAdvFound extends AdvState {
  final String status;

  const NoAdvFound(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => status;
}

class GetAdvDetailSuccessful extends AdvState {
  final String status;
  final dynamic advData;

  const GetAdvDetailSuccessful(this.status, this.advData);
  @override
  List<Object> get props => [status, advData];
  @override
  String toString() => status;
}

class GetProductDetailSuccessful extends AdvState {
  final String status;
  final dynamic advData;

  const GetProductDetailSuccessful(this.status, this.advData);
  @override
  List<Object> get props => [status, advData];
  @override
  String toString() => status;
}

class RedeemAdvSuccessful extends AdvState {
  final String status;
  final dynamic redeemAdvData;

  const RedeemAdvSuccessful(this.status, this.redeemAdvData);
  @override
  List<Object> get props => [status, redeemAdvData];
  @override
  String toString() => status;
}
