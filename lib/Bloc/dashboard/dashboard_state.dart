part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class ErrorOccured extends DashboardState {
  const ErrorOccured();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'Error Occured!';
}

class GetBannerNewsletterSuccessful extends DashboardState {
  final String status;
  final dynamic bannerNewsletters;

  const GetBannerNewsletterSuccessful(this.status, this.bannerNewsletters);
  @override
  List<Object> get props => [status, bannerNewsletters];
  @override
  String toString() => status;
}

class GetReqestListSuccessful extends DashboardState {
  final String status;
  final dynamic requestList;

  const GetReqestListSuccessful(this.status, this.requestList);
  @override
  List<Object> get props => [status, requestList];
  @override
  String toString() => status;
}

class GetRefferalListSuccessful extends DashboardState {
  final String status;
  final dynamic refferalList;

  const GetRefferalListSuccessful(this.status, this.refferalList);
  @override
  List<Object> get props => [status, refferalList];
  @override
  String toString() => status;
}

class GetOrderListSuccessful extends DashboardState {
  final String status;
  final dynamic orderList;

  const GetOrderListSuccessful(this.status, this.orderList);
  @override
  List<Object> get props => [status, orderList];
  @override
  String toString() => status;
}

class GetOrderDetailSuccessful extends DashboardState {
  final String status;
  final dynamic orderDetailList;

  const GetOrderDetailSuccessful(this.status, this.orderDetailList);
  @override
  List<Object> get props => [status, orderDetailList];
  @override
  String toString() => status;
}
