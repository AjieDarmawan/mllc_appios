part of 'entrepreneurs_bloc.dart';

abstract class EntrepreneursState extends Equatable {
  const EntrepreneursState();
  
  @override
  List<Object> get props => [];
}

class EntrepreneursInitial extends EntrepreneursState {}

class EntrepreneursLoading extends EntrepreneursState {}

class ErrorOccured extends EntrepreneursState {
  const ErrorOccured();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'Error Occured!';
}

class GetEntrepreneursListSuccessful extends EntrepreneursState {
  final String status;
  final dynamic entrepreneursList;

  const GetEntrepreneursListSuccessful(this.status, this.entrepreneursList);
  @override
  List<Object> get props => [status, entrepreneursList];
  @override
  String toString() => status;
}

class NoEntrepreneursFound extends EntrepreneursState {
  final String status;

  const NoEntrepreneursFound(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => status;
}

class GetEntrepreneurDetailSuccessful extends EntrepreneursState {
  final String status;
  final dynamic entrepreneurData;

  const GetEntrepreneurDetailSuccessful(this.status, this.entrepreneurData);
  @override
  List<Object> get props => [status, entrepreneurData];
  @override
  String toString() => status;
}