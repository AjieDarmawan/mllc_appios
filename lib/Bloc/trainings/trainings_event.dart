part of 'trainings_bloc.dart';

abstract class TrainingsEvent extends Equatable {
  const TrainingsEvent();

  @override
  List<Object> get props => [];
}

class GetTrainersList extends TrainingsEvent {
  const GetTrainersList();
  @override
  List<Object> get props => [];
}

class GetTrainingsList extends TrainingsEvent {
  final dynamic arg;

  const GetTrainingsList(this.arg);
  @override
  List<Object> get props => [arg];
}

class GetTrainingDetails extends TrainingsEvent {
  final int id;

  const GetTrainingDetails(this.id);
  @override
  List<Object> get props => [id];
}

class JoinTraining extends TrainingsEvent {
  final dynamic arg;

  const JoinTraining(this.arg);
  @override
  List<Object> get props => [arg];
}

class UpdateFavoriteTraining extends TrainingsEvent {
  final dynamic formData;

  const UpdateFavoriteTraining(this.formData);
  @override
  List<Object> get props => [formData];
}

class UpdateFavoriteTrainer extends TrainingsEvent {
  final dynamic formData;

  const UpdateFavoriteTrainer(this.formData);
  @override
  List<Object> get props => [formData];
}

class UpdateFavoriteMedia extends TrainingsEvent {
  final dynamic formData;

  const UpdateFavoriteMedia(this.formData);
  @override
  List<Object> get props => [formData];
}
