part of 'entrepreneurs_bloc.dart';

abstract class EntrepreneursEvent extends Equatable {
  const EntrepreneursEvent();

  @override
  List<Object> get props => [];
}

class ClearService extends EntrepreneursEvent {}

class UnloadEntrepreneur extends EntrepreneursEvent {}

class GetEntrepreneursList extends EntrepreneursEvent {
  final dynamic arg;
  const GetEntrepreneursList(this.arg);
  @override
  List<Object> get props => [arg];
}

class GetEntrepreneurDetails extends EntrepreneursEvent {
  final dynamic arg;

  const GetEntrepreneurDetails(this.arg);
  @override
  List<Object> get props => [arg];
}

class UpdateToRequestConnected extends EntrepreneursEvent {
  final dynamic formData;

  const UpdateToRequestConnected(this.formData);
  @override
  List<Object> get props => [formData];
}

class UpdateToRequestRefferal extends EntrepreneursEvent {
  final dynamic formData;

  const UpdateToRequestRefferal(this.formData);
  @override
  List<Object> get props => [formData];
}
