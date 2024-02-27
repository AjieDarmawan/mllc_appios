import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';

part 'xproject_event.dart';
part 'xproject_state.dart';

class XprojectBloc extends Bloc<XprojectEvent, XprojectState> {
  final HttpProvider httpProvider;
  XprojectBloc(this.httpProvider) : super(XprojectInitial()) {
    on<XprojectEvent>(eventHandler);
  }

  eventHandler(event, emit) {
    if (event is GetXprojectList) {
      return _mapGetXprojectListToState(event, emit);
    } else if (event is GetXprojectDetails) {
      return _mapGetXprojectDetailsToState(event, emit);
    } else if (event is GetXprojectDetails) {
      return _mapGetInterestToState(event, emit);
    }
  }

  void _mapGetXprojectListToState(event, emit) async {
    emit(XprojectLoading());
    var xprojectListData = await httpProvider.getHttp4("projects_listing");
    if (xprojectListData != null) {
      var xprojectList = xprojectListData;
      emit(GetXprojectListSuccessful(
          "Get XProject List Successful", xprojectList));
    } else {
      emit(const NoXprojectFound("No XProject Found"));
    }
  }

  void _mapGetXprojectDetailsToState(event, emit) async {
    emit(XprojectLoading());
    var xprojectDetailsData =
        await httpProvider.postHttp4("project_info", {'project_id': event.id});
    if (xprojectDetailsData != null) {
      var xprojectDetails = xprojectDetailsData;
      emit(GetXprojectDetailsSuccessful(
          "Get XProject Details Successful", xprojectDetails));
    } else {
      emit(const NoXprojectFound("No XProject Found"));
    }
  }

  void _mapGetInterestToState(event, emit) async {
    emit(XprojectLoading());
    var interestData =
        await httpProvider.postHttp4("project/interested", event.formData);
    if (interestData != null) {
      var interest = interestData;
      emit(GetInterestSuccessful("Interest Successful", interest));
    } else {
      emit(const NoXprojectFound("No XProject Found"));
    }
  }
}
