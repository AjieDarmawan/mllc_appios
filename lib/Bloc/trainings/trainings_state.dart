part of 'trainings_bloc.dart';

abstract class TrainingsState extends Equatable {
  const TrainingsState();
  
  @override
  List<Object> get props => [];
}

class TrainingsInitial extends TrainingsState {}

class TrainingsLoading extends TrainingsState {}

class ErrorOccured extends TrainingsState {
  const ErrorOccured();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'Error Occured!';
}

class GetTrainersListSuccessful extends TrainingsState {
  final String status;
  final dynamic trainersList;

  const GetTrainersListSuccessful(this.status, this.trainersList);
  @override
  List<Object> get props => [status, trainersList];
  @override
  String toString() => status;
}

class NoTrainersFound extends TrainingsState {
  final String status;

  const NoTrainersFound(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => status;
}

class GetTrainingsListSuccessful extends TrainingsState {
  final String status;
  final dynamic trainingsList;

  const GetTrainingsListSuccessful(this.status, this.trainingsList);
  @override
  List<Object> get props => [status, trainingsList];
  @override
  String toString() => status;
}

class NoTrainingsFound extends TrainingsState {
  final String status;

  const NoTrainingsFound(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => status;
}

class GetTrainingDetailsSuccessful extends TrainingsState {
  final String status;
  final dynamic trainingData;

  const GetTrainingDetailsSuccessful(this.status, this.trainingData);
  @override
  List<Object> get props => [status, trainingData];
  @override
  String toString() => status;
}

class JoinTrainingSuccessful extends TrainingsState {
  final String status;
  final dynamic joinTrainingData;

  const JoinTrainingSuccessful(this.status, this.joinTrainingData);
  @override
  List<Object> get props => [status, joinTrainingData];
  @override
  String toString() => status;
}