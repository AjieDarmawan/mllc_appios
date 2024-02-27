part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class ClearServices extends DashboardEvent {}

class GetBannerNewsletter extends DashboardEvent {
  const GetBannerNewsletter();
  @override
  List<Object> get props => [];
}

class GetRequestList extends DashboardEvent {
  final int arg;

  const GetRequestList(this.arg);
  @override
  List<Object> get props => [arg];
}

class GetRefferalList extends DashboardEvent {
  final int arg;

  const GetRefferalList(this.arg);
  @override
  List<Object> get props => [arg];
}

class GetOrderList extends DashboardEvent {
  final int arg;

  const GetOrderList(this.arg);
  @override
  List<Object> get props => [arg];
}

class GetOrderDetail extends DashboardEvent {
  final int arg;

  const GetOrderDetail(this.arg);
  @override
  List<Object> get props => [arg];
}

class UpdateRequestList extends DashboardEvent {
  final dynamic formData;

  const UpdateRequestList(this.formData);
  @override
  List<Object> get props => [formData];
}

class UpdateRefferalList extends DashboardEvent {
  final dynamic formData;

  const UpdateRefferalList(this.formData);
  @override
  List<Object> get props => [formData];
}
