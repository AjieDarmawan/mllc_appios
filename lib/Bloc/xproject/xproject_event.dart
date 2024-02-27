part of 'xproject_bloc.dart';

abstract class XprojectEvent extends Equatable {
  const XprojectEvent();

  @override
  List<Object> get props => [];
}

class GetXprojectList extends XprojectEvent {
  const GetXprojectList();
  @override
  List<Object> get props => [];
}

class GetXprojectDetails extends XprojectEvent {
  final int id;

  const GetXprojectDetails(this.id);
  @override
  List<Object> get props => [id];
}
