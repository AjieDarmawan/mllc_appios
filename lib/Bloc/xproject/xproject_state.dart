part of 'xproject_bloc.dart';

abstract class XprojectState extends Equatable {
  const XprojectState();

  @override
  List<Object> get props => [];
}

class XprojectInitial extends XprojectState {}

class XprojectLoading extends XprojectState {}

class NoXprojectFound extends XprojectState {
  final String messsage;

  const NoXprojectFound(this.messsage);
  @override
  List<Object> get props => [messsage];
  @override
  String toString() => messsage;
}

class GetXprojectListSuccessful extends XprojectState {
  final String status;
  final List<dynamic> projectList;

  const GetXprojectListSuccessful(this.status, this.projectList);
  @override
  List<Object> get props => [status, projectList];
  @override
  String toString() => status;
}

class GetXprojectDetailsSuccessful extends XprojectState {
  final String status;
  final dynamic details;

  const GetXprojectDetailsSuccessful(this.status, this.details);
  @override
  List<Object> get props => [status, details];
  @override
  String toString() => status;
}

class GetInterestSuccessful extends XprojectState {
  final String status;
  final dynamic details;

  const GetInterestSuccessful(this.status, this.details);
  @override
  List<Object> get props => [status, details];
  @override
  String toString() => status;
}
