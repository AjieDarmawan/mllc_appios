import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final HttpProvider httpProvider;
  AuthBloc(this.httpProvider) : super(AuthInitial()) {
    on<AuthEvent>(eventHandler);
  }

  // renamed/migrated from mapEventToState
  eventHandler(event, emit) {
    if (event is UnloadAuthState) {
      emit(AuthInitial());
    } else if (event is Login) {
      return _mapLoginToState(event, emit);
    } else if (event is CheckEmail) {
      return _mapCheckEmailToState(event, emit);
    } else if (event is Register) {
      return _mapRegisterToState(event, emit);
    } else if (event is ForgotPassword) {
      return _mapForgotPasswordToState(event, emit);
    } else if (event is Logout) {
      return _mapLogoutToState(event, emit);
    } else if (event is GetUserDetails) {
      return _mapGetUserDetailsToState(event, emit);
    } else if (event is CreateUpdateSocialMedia) {
      return _mapCreateUpdateSocialMediaToState(event, emit);
    } else if (event is CreateUpdateProfessionalCert) {
      return _mapCreateUpdateProfessionalCertToState(event, emit);
    } else if (event is CreateUpdateEducation) {
      return _mapCreateUpdateEducationToState(event, emit);
    } else if (event is CreateUpdateSocieties) {
      return _mapCreateUpdateSocietiesToState(event, emit);
    } else if (event is CreateUpdateWorkExperienced) {
      return _mapCreateUpdateWorkExperiencedToState(event, emit);
    } else if (event is UpdateUserDetail) {
      return _mapUpdateUserDetailToState(event, emit);
    } else if (event is GetWishlistDetail) {
      return _mapGetWishlistToState(event, emit);
    } else if (event is DeleteUpdateSocialMedia) {
      return _mapDeleteUpdateSocialMediaToState(event, emit);
    } else if (event is UpdateCompanyDetail) {
      return _mapUpdateCompanyDetailToState(event, emit);
    }
  }

  void _mapDeleteUpdateSocialMediaToState(event, emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(AuthLoading());
    var getDeleteSocialMedia;
    if (event.formData['type'] == 'Social Media') {
      var _formData = {
        "user_id": prefs.getInt("userId"),
        "social_media_id": event.formData['social_media_id']
      };
      getDeleteSocialMedia =
          await httpProvider.postHttp2("member/social/delete", _formData);
    } else if (event.formData['type'] == 'Education') {
      var _formData = {
        "user_id": prefs.getInt("userId"),
        "education_id": event.formData['education_id']
      };
      getDeleteSocialMedia =
          await httpProvider.postHttp2("member/education/delete", _formData);
    } else if (event.formData['type'] == 'Societies') {
      var _formData = {
        "user_id": prefs.getInt("userId"),
        "society_id": event.formData['society_id']
      };
      getDeleteSocialMedia =
          await httpProvider.postHttp2("member/society/delete", _formData);
    } else if (event.formData['type'] == 'Professional Cert & Rewards') {
      var _formData = {
        "user_id": prefs.getInt("userId"),
        "cert_id": event.formData['cert_id']
      };
      getDeleteSocialMedia =
          await httpProvider.postHttp2("member/cert/delete", _formData);
    } else if (event.formData['type'] == 'Work Experienced') {
      var _formData = {
        "user_id": prefs.getInt("userId"),
        "work_experience_id": event.formData['work_experience_id']
      };
      getDeleteSocialMedia =
          await httpProvider.postHttp2("member/work/delete", _formData);
    }
    if (getDeleteSocialMedia == "Delete Success") {
      emit(const UpdateDataSuccessful("Delete Social Media Successful"));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapLoginToState(event, emit) async {
    emit(AuthLoading());
    // var loginDataReturn = await httpProvider.postHttp("login", event.formData);
    // if (loginDataReturn == "Password not match" ||
    //     loginDataReturn == "User not found") {
    //   emit(LoginFailure(loginDataReturn));
    // } else if (loginDataReturn == "Account inactive") {
    //   emit(AccountInactive(loginDataReturn));
    // } else {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setInt("userId", loginDataReturn['id']);
    //   prefs.setBool("isLoggedIn", true);
    //   prefs.setString("email", loginDataReturn['email']);
    //   prefs.setString("username", loginDataReturn['username']);

    //   var updateAccessDataReturn = await httpProvider
    //       .postHttp("last_access", {'user_id': loginDataReturn['id']});
    //   if (updateAccessDataReturn == "Update Success") {
    //     emit(LoginSuccessful("Login Successful", loginDataReturn));
    //   } else {
    //     emit(const ErrorOccured());
    //   }
    // }
  }

  void _mapCheckEmailToState(event, emit) async {
    emit(AuthLoading());
    var checkEmailDataReturn =
        await httpProvider.postHttp("register/chk_email", event.formData);
    if (checkEmailDataReturn == "You can proceed to sign up as member.") {
      emit(const ValidEmail());
    } else if (checkEmailDataReturn ==
            "This email has registered. You may proceed to login." ||
        checkEmailDataReturn ==
            "Your previous registration with this email has rejected by admin." ||
        checkEmailDataReturn ==
            "This email has registered and pending for admin approval.") {
      emit(InvalidEmail(checkEmailDataReturn));
    }
  }

  void _mapRegisterToState(event, emit) async {
    FormData data;
    emit(AuthLoading());
    data = FormData.fromMap({
      'email': event.formData['email'],
      'password': event.formData['password'],
      'identity_card': event.formData['identity_card'],
      'phone_number': event.formData['phone_number'],
      'title_id': event.formData['title_id'],
      'name': event.formData['name'],
      'preferred_name': event.formData['preferred_name'],
      'chinese_name': event.formData['chinese_name'],
      'nationality_id': event.formData['nationality_id'],
      'state_id': event.formData['state_id'],
      'company_name': event.formData['company_name'],
      'designation': event.formData['designation'],
      'business_category_main_id': event.formData['business_category_main_id'],
      'business_category_sub_id': event.formData['business_category_sub_id'],
      'business_nature': event.formData['business_nature'],
      //'company_sales_id': event.formData['company_sales_id'],
      'expanding_area[]': event.formData['expanding_area'],
      'expectation': event.formData['expectation'],
      //'acknowledgement': event.formData['acknowledgement'],
      //'package': event.formData['package'],
      'others_nationality': event.formData['others_nationality'],
      'others_state': event.formData['others_state'],
      // 'referrer_number': event.formData['referrer_number'],
      // 'ssm_certificate': MultipartFile.fromFileSync(
      //     event.formData['ssm_cert'].path,
      //     filename: basename(event.formData['ssm_cert'].path)),
      // 'package_id': event.formData['package_id'],
    });

    var registerDataReturn = await httpProvider.postHttp("register", data);
    if (registerDataReturn == "Registration success") {
      emit(const RegisterSuccessful());
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapUpdateCompanyDetailToState(event, emit) async {
    print('salah12');
    FormData data;
    emit(AuthLoading());
    if (event.formData['ssm_cert'] != '') {
      data = FormData.fromMap({
        'user_id': event.formData['user_id'],
        'company_id': event.formData['company_id'],
        'company_sales_id': event.formData['company_sales_id'],
        'company_name': event.formData['company_name'],
        'designation': event.formData['designation'],
        'business_category_main_id':
            event.formData['business_category_main_id'],
        'business_category_sub_id': event.formData['business_category_sub_id'],
        'business_nature': event.formData['business_nature'],
        'expanding_areas': event.formData['expanding_areas'],
        'expanding_areas_others': event.formData['expanding_areas_others'],
        'expectation': event.formData['expectation'],
        'establish_year': event.formData['establish_year'],
        'company_state_id': event.formData['company_state_id'],
        'company_address': event.formData['company_address'],
        'company_postcode': event.formData['company_postcode'],
        'company_city': event.formData['company_city'],
        'company_country_id': event.formData['company_country_id'],
        //'ssm_cert': MultipartFile.fromFileSync(event.formData['ssm_cert'].path,
        //     filename: basename(event.formData['ssm_cert'].path)),
      });
    } else {
      data = FormData.fromMap({
        'user_id': event.formData['user_id'],
        'company_id': event.formData['company_id'],
        'company_sales_id': event.formData['company_sales_id'],
        'company_name': event.formData['company_name'],
        'designation': event.formData['designation'],
        'business_category_main_id':
            event.formData['business_category_main_id'],
        'business_category_sub_id': event.formData['business_category_sub_id'],
        'business_nature': event.formData['business_nature'],
        'expanding_areas': event.formData['expanding_areas'],
        'expanding_areas_others': event.formData['expanding_areas_others'],
        'expectation': event.formData['expectation'],
        'establish_year': event.formData['establish_year'],
        'company_state_id': event.formData['company_state_id'],
        'company_address': event.formData['company_address'],
        'company_postcode': event.formData['company_postcode'],
        'company_city': event.formData['company_city'],
        'company_country_id': event.formData['company_country_id'],
        // 'ssm_cert': MultipartFile.fromFileSync(event.formData['ssm_cert'].path,
        //     filename: basename(event.formData['ssm_cert'].path)),
      });
    }

    var UpdateCompanyDataReturn =
        await httpProvider.postHttp2("member/company/update", data);
    if (UpdateCompanyDataReturn == "Update Success") {
      emit(const UpdateCompanySuccessful("Get User Details Successful"));
    } else {
      print('salah');
      emit(const ErrorOccured());
    }
  }

  void _mapForgotPasswordToState(event, emit) async {
    emit(AuthLoading());
    var forgotPasswordDataReturn =
        await httpProvider.postHttp("forget_password", event.formData);
    if (forgotPasswordDataReturn ==
        "Reset password link will be sent to your email.") {
      emit(ForgotPasswordSuccessful(forgotPasswordDataReturn));
    } else if (forgotPasswordDataReturn == "User not found") {
      emit(UserNotFound(forgotPasswordDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapLogoutToState(event, emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("userId", 0);
    prefs.setBool("isLoggedIn", false);
    prefs.setString("email", '');
    prefs.setString("username", '');
    prefs.setBool("isExpired", false);
    emit(const LogoutSuccessful("Logout Successful"));
  }

  void _mapGetUserDetailsToState(event, emit) async {
    emit(AuthLoading());
    var _formData = {"user_id": event.formData['user_id']};
    print('yauserxx2--${_formData}');
    print('yauserxx2--${event.formData['user_id']}');
    var getUserDetailsDataReturn = await httpProvider
        .postHttp2("entrepreneur/info", {"user_id": event.formData['user_id']});

    print('userxx${getUserDetailsDataReturn}');
    if (getUserDetailsDataReturn != null) {
      emit(GetUserDetailsSuccessful(
          "Get User Details Successful", getUserDetailsDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapGetWishlistToState(event, emit) async {
    emit(AuthLoading());
    var getUserDetailsDataReturn =
        await httpProvider.postHttp("favourite", event.formData);
    if (getUserDetailsDataReturn != null) {
      emit(GetListDetailsSuccessful(
          "Get List Details Successful", getUserDetailsDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapCreateUpdateSocialMediaToState(event, emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(AuthLoading());
    event.formData['user_id'] = prefs.getInt("userId");
    if (event.formData['social_media_id'] != null) {
      var updateSocialMediaDataReturn =
          await httpProvider.postHttp2("member/social/update", event.formData);
      if (updateSocialMediaDataReturn == "Update Success") {
        emit(const UpdateDataSuccessful("Update Social Media Successful"));
      } else {
        emit(const ErrorOccured());
      }
    } else {
      var createSocialMediaDataReturn =
          await httpProvider.postHttp2("member/social/create", event.formData);
      if (createSocialMediaDataReturn == "Create Success") {
        emit(const CreateDataSuccessful("Create Social Media Successful"));
      } else {
        emit(const ErrorOccured());
      }
    }
    var _formData = {"user_id": event.formData['user_id']};
    var getUserDetailsDataReturn =
        await httpProvider.postHttp2("entrepreneur/info", _formData);
    if (getUserDetailsDataReturn != null) {
      emit(GetUserDetailsSuccessful(
          "Get User Details Successful", getUserDetailsDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapCreateUpdateProfessionalCertToState(event, emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(AuthLoading());
    event.formData['user_id'] = prefs.getInt("userId");
    if (event.formData['cert_id'] != null) {
      var updateProfessionalCertDataReturn =
          await httpProvider.postHttp2("member/cert/update", event.formData);
      if (updateProfessionalCertDataReturn == "Update Success") {
        emit(const UpdateDataSuccessful("Update Professional Cert Successful"));
      } else {
        emit(const ErrorOccured());
      }
    } else {
      var createProfessionalCertDataReturn =
          await httpProvider.postHttp2("member/cert/create", event.formData);
      if (createProfessionalCertDataReturn != null) {
        emit(const CreateDataSuccessful("Create Professional Cert Successful"));
      } else {
        emit(const ErrorOccured());
      }
    }
    var _formData = {"user_id": event.formData['user_id']};
    var getUserDetailsDataReturn =
        await httpProvider.postHttp2("entrepreneur/info", _formData);
    if (getUserDetailsDataReturn != null) {
      emit(GetUserDetailsSuccessful(
          "Get User Details Successful", getUserDetailsDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapCreateUpdateEducationToState(event, emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(AuthLoading());
    event.formData['user_id'] = prefs.getInt("userId");
    if (event.formData['education_id'] != null) {
      var updateEducationDataReturn = await httpProvider.postHttp2(
          "member/education/update", event.formData);
      if (updateEducationDataReturn == "Update Success") {
        emit(const UpdateDataSuccessful("Update Education Successful"));
      } else {
        emit(const ErrorOccured());
      }
    } else {
      var createEducationDataReturn = await httpProvider.postHttp2(
          "member/education/create", event.formData);
      if (createEducationDataReturn != null) {
        emit(const CreateDataSuccessful("Create Education Successful"));
      } else {
        emit(const ErrorOccured());
      }
    }
    var _formData = {"user_id": event.formData['user_id']};
    var getUserDetailsDataReturn =
        await httpProvider.postHttp2("entrepreneur/info", _formData);
    if (getUserDetailsDataReturn != null) {
      emit(GetUserDetailsSuccessful(
          "Get User Details Successful", getUserDetailsDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapCreateUpdateSocietiesToState(event, emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(AuthLoading());
    event.formData['user_id'] = prefs.getInt("userId");
    if (event.formData['society_id'] != null) {
      var updateSocietiesDataReturn =
          await httpProvider.postHttp2("member/society/update", event.formData);
      if (updateSocietiesDataReturn == "Update Success") {
        emit(const UpdateDataSuccessful("Update Societies Successful"));
      } else {
        emit(const ErrorOccured());
      }
    } else {
      var createSocietiesDataReturn =
          await httpProvider.postHttp2("member/society/create", event.formData);
      if (createSocietiesDataReturn != null) {
        emit(const CreateDataSuccessful("Create Societies Successful"));
      } else {
        emit(const ErrorOccured());
      }
    }
    var _formData = {"user_id": event.formData['user_id']};
    var getUserDetailsDataReturn =
        await httpProvider.postHttp2("entrepreneur/info", _formData);
    if (getUserDetailsDataReturn != null) {
      emit(GetUserDetailsSuccessful(
          "Get User Details Successful", getUserDetailsDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapCreateUpdateWorkExperiencedToState(event, emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(AuthLoading());
    event.formData['user_id'] = prefs.getInt("userId");
    if (event.formData['work_experience_id'] != null) {
      var updateWorkExperiencedDataReturn =
          await httpProvider.postHttp2("member/work/update", event.formData);
      if (updateWorkExperiencedDataReturn == "Update Success") {
        emit(const UpdateDataSuccessful("Update Work Experienced Successful"));
      } else {
        emit(const ErrorOccured());
      }
    } else {
      var createWorkExperiencedDataReturn =
          await httpProvider.postHttp2("member/work/create", event.formData);
      if (createWorkExperiencedDataReturn != null) {
        emit(const CreateDataSuccessful("Create Work Experienced Successful"));
      } else {
        emit(const ErrorOccured());
      }
    }
    var _formData = {"user_id": event.formData['user_id']};
    var getUserDetailsDataReturn =
        await httpProvider.postHttp2("entrepreneur/info", _formData);
    if (getUserDetailsDataReturn != null) {
      emit(GetUserDetailsSuccessful(
          "Get User Details Successful", getUserDetailsDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }

  void _mapUpdateUserDetailToState(event, emit) async {
    FormData data;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (event.formData['thumbnail'] != null) {
      data = FormData.fromMap({
        'user_id': event.formData['user_id'],
        'password': event.formData['password'],
        'title_id': event.formData['title_id'],
        'nationality_id': event.formData['nationality_id'],
        'state_id': event.formData['state_id'],
        'name': event.formData['name'],
        'preferred_name': event.formData['preferred_name'],
        'chinese_name': event.formData['chinese_name'],
        'identity_card': event.formData['identity_card'],
        'phone_number': event.formData['phone_number'],
        'gender': event.formData['gender'],
        'introduction': event.formData['introduction'],
        'passport_number': event.formData['passport_number'],
        'others_nationality': event.formData['others_nationality'],
        'others_state': event.formData['others_state'],
        'thumbnail': MultipartFile.fromFileSync(
            event.formData['thumbnail'].path,
            filename: basename(event.formData['thumbnail'].path)),
      });
    } else {
      data = FormData.fromMap({
        'user_id': event.formData['user_id'],
        'password': event.formData['password'],
        'title_id': event.formData['title_id'],
        'nationality_id': event.formData['nationality_id'],
        'state_id': event.formData['state_id'],
        'name': event.formData['name'],
        'preferred_name': event.formData['preferred_name'],
        'chinese_name': event.formData['chinese_name'],
        'identity_card': event.formData['identity_card'],
        'phone_number': event.formData['phone_number'],
        'gender': event.formData['gender'],
        'introduction': event.formData['introduction'],
        'passport_number': event.formData['passport_number'],
        'others_nationality': event.formData['others_nationality'],
        'others_state': event.formData['others_state'],
        'thumbnail': null,
      });
    }
    // FormData data = FormData.fromMap({
    //   'new_password': event.formData['new_password'],
    //   'password': event.formData['password'],
    //   'first_name': event.formData['first_name'],
    //   'last_name': event.formData['last_name'],
    //   'identity_card': event.formData['identity_card'],
    //   'phone_number': event.formData['phone_number'],
    //   'gender': event.formData['gender'],
    //   'introduction': event.formData['introduction'],
    //   'thumbnail': MultipartFile.fromFileSync(event.formData['thumbnail'].path,
    //       filename: basename(event.formData['thumbnail'].path))
    // });
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // event.formData['user_id'] = prefs.getInt("userId");
    emit(AuthLoading());
    var updateUserDetailDataReturn =
        await httpProvider.postHttp2("member/profile/update", data);
    if (updateUserDetailDataReturn == "Update Success") {
      emit(const UpdatePersonalBasicInfoDataSuccessful(
          "Update User Detail Successful"));
    } else {
      emit(const ErrorOccured());
    }
    var _formData = {"user_id": event.formData['user_id']};
    var getUserDetailsDataReturn =
        await httpProvider.postHttp2("entrepreneur/info", _formData);
    if (getUserDetailsDataReturn != null) {
      emit(GetUserDetailsSuccessful(
          "Get User Details Successful", getUserDetailsDataReturn));
    } else {
      emit(const ErrorOccured());
    }
  }
}
