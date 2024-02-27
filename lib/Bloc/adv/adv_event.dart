part of 'adv_bloc.dart';

abstract class AdvEvent extends Equatable {
  const AdvEvent();

  @override
  List<Object> get props => [];
}

class ClearService extends AdvEvent {}

class UnloadAdv extends AdvEvent {}

class GetAdvList extends AdvEvent {
  const GetAdvList();
  @override
  List<Object> get props => [];
}

class GetAdvDetails extends AdvEvent {
  final dynamic args;
  final int id;

  const GetAdvDetails(this.args, this.id);
  @override
  List<Object> get props => [args, id];
}

class GetSponsoredAdvDetails extends AdvEvent {
  final int id;

  const GetSponsoredAdvDetails(this.id);
  @override
  List<Object> get props => [id];
}

class GetProductDetails extends AdvEvent {
  final dynamic args;
  final int id;

  const GetProductDetails(this.args, this.id);
  @override
  List<Object> get props => [args, id];
}

class RedeemAdv extends AdvEvent {
  final dynamic args;
  final int id;

  const RedeemAdv(this.args, this.id);
  @override
  List<Object> get props => [args, id];
}
