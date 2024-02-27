// ignore_for_file: prefer_is_empty
import 'dart:async';

import 'package:delayed_display/delayed_display.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/entrepreneurs/entrepreneurs_bloc.dart';

import 'package:mlcc_app_ios/constant.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:mlcc_app_ios/main.dart';

import '../../../widget/block_button_widget.dart';
import '../../../widget/text_field_widget.dart';

class RegisterRefferalPage extends StatefulWidget {
  final dynamic data;
  const RegisterRefferalPage({Key? key, this.data}) : super(key: key);

  @override
  _RegisterRefferalPageState createState() => _RegisterRefferalPageState();
}

class _RegisterRefferalPageState extends State<RegisterRefferalPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> userData = {};

  final Map<String, dynamic> _formData = {
    // 'new_password': null,
    // 'password': null,
    // 'identity_card': null,
    'phone_number': null,
    // 'gender': null,
    'company_state_id': null,
    'company_city': null,
    'company_state_id': null,
    'nationality_id': null,
    'email': null,
    'name': null,
    'company_name': null,
    'company_postcode': null,
    'address_1': null,

    'company_address': null
  };

  int userId = 0;
  int selectedStateID = 0;
  String selectedState = "";
  int selectedCountryID = 0;
  String selectedCountry = "";
  String thumbnail = "";

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // email = prefs.getString("email")!;
      // username = prefs.getString("username")!;
      // showExpired = prefs.getBool("isExpired")!;
      userId = prefs.getInt("userId")!;
    });
    dynamic formData = {'user_id': prefs.getInt("userId")!};

    // Timer(const Duration(milliseconds: 600), () {
    context.read<AuthBloc>().add(GetUserDetails(formData));
    // });
  }

  @override
  void initState() {
    // _formData['name'] = widget.data['name'];
    // _formData['email'] = widget.data['email'];
    // _formData['phone_number'] = widget.data['phone_number'];
    // _formData['company_name'] = widget.data['company_name'];
    // _formData['company_state_id'] = widget.data['company_state_id'];
    // _formData['nationality_id'] = widget.data['nationality_id'];
    // _formData['address_1'] = widget.data['address_1'];
    // _formData['address_2'] = widget.data['address_2'];
    // _formData['postcode'] = widget.data['postcode'];

    getUser();
    getStateList();
    getNationality();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<dynamic> stateList = [];
  List<String> state_state = [];
  getStateList() async {
    stateList = await httpProvider.getHttp("state");
    setState(() {
      for (var element in stateList) {
        state_state.add(element['name']);
        if (widget.data['state_id'] == element['id']) {
          selectedState = element['name'];
        }
      }
    });
  }

  List<dynamic> nationalityList = [];
  List<String> nationality = [];
  getNationality() async {
    nationalityList = await httpProvider.getHttp("nationality");
    setState(() {
      for (var element in nationalityList) {
        if (element['name'] != "Others") {
          nationality.add(element['name']);
          if (widget.data['nationality_id'] == element['id']) {
            selectedCountry = element['name'];
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Referral Passing Form",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        body: DelayedDisplay(
          delay: const Duration(
            milliseconds: 600,
          ),
          child: BlocBuilder<AuthBloc, AuthState>(
              builder: (BuildContext context, AuthState state) {
            if (state is GetUserDetailsSuccessful) {
              userData = state.userData[0];
              // _formData['user_id'] = userData['id'];
              // _formData['title_id'] = userData['title_id'];
              // _formData['nationality_id'] = userData['nationality_id'];
              // _formData['state_id'] = userData['state_id'];
              // _formData['name'] = userData['name'];
              // _formData['preferred_name'] = userData['preferred_name'];
              // _formData['chinese_name'] = userData['chinese_name'];
              // _formData['identity_card'] = userData['identity_card'];
              // _formData['phone_number'] = userData['phone_number'];
              // _formData['passport_number'] = userData['passport_number'];
              // _formData['others_nationality'] = userData['others_nationality'];
              // _formData['others_state'] = userData['others_state'];
              // _formData['gender'] = userData['gender'];
              // _formData['introduction'] = userData['introduction'];

              _formData['name'] = userData['name'];
              _formData['email'] = userData['email'];
              _formData['phone_number'] = userData['phone_number'];
              _formData['company_name'] = userData['company_name'];
              _formData['company_state_id'] = userData['company_state_id'];

              _formData['nationality_id'] = userData['nationality_id'];
              _formData['company_address'] =
                  userData['company_details']['company_address'];

              _formData['company_postcode'] =
                  userData['company_details']['company_postcode'];

              _formData['company_state_id'] =
                  userData['company_details']['company_state_id'];
              _formData['company_city'] =
                  userData['company_details']['company_city'];

              if (userData['thumbnail'] != null) {
                thumbnail = userData['thumbnail'];
              }

              return ListView(
                primary: true,
                children: [
                  Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Container(
                          height: 160,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: kThirdColor,
                                  blurRadius: 10,
                                  offset: Offset(0, 5)),
                            ],
                          ),
                          margin: const EdgeInsets.only(bottom: 50),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  userData['title'] + " " + userData['name'],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 24),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  userData['company_name'],
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                // Text("Fill the following credentials to login your account",
                                //     style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(14)),
                            boxShadow: const [
                              BoxShadow(
                                  color: kThirdColor,
                                  blurRadius: 10,
                                  offset: Offset(0, 5)),
                            ],
                            border: Border.all(color: kThirdColor),
                            // gradient: gradient,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: Image.network(
                                userData['thumbnail'],
                                fit: BoxFit.contain,
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                        ),
                      ]),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFieldWidget(
                            labelText: "Email Address",
                            hintText: "johndoe@gmail.com",
                            iconData: Icons.alternate_email,
                            keyboardType: TextInputType.emailAddress,
                            isFirst: true,
                            isLast: false,
                            setValue: _setInputValue,
                            initialValue: _formData['email'],
                            field: 'email',
                            validator: emailValidator),
                        TextFieldWidget(
                          labelText: "Name",
                          hintText: "Lee Wei Wei",
                          iconData: Icons.person_outline,
                          isFirst: false,
                          isLast: false,
                          setValue: _setInputValue,
                          initialValue: _formData['name'],
                          field: 'name',
                          validator:
                              RequiredValidator(errorText: 'Name is required'),
                        ),
                        TextFieldWidget(
                          labelText: "Phone Number",
                          hintText: "0123456789",
                          iconData: Icons.phone_iphone,
                          keyboardType: TextInputType.phone,
                          isFirst: false,
                          isLast: true,
                          setValue: _setInputValue,
                          field: 'contact',
                          initialValue: _formData['phone_number'],
                          validator: phoneNumberValidator,
                        ),
                        TextFieldWidget(
                          labelText: "Company Name",
                          hintText: "Company Name",
                          iconData: Icons.business,
                          setValue: _setInputValue,
                          field: 'company_name',
                          initialValue: _formData['company_name'],
                        ),
                        TextFieldWidget(
                          labelText: "Company Address",
                          hintText: "Company Address",
                          keyboardType: TextInputType.multiline,
                          iconData: Icons.home,
                          // keyboardType: TextInputType.phone,
                          isFirst: true,
                          isLast: false,
                          setValue: _setInputValue,
                          field: 'company_address',
                          initialValue: _formData['company_address'],
                        ),
                        TextFieldWidget(
                          labelText: "Postcode",
                          hintText: "Postcode",
                          keyboardType: TextInputType.number,
                          iconData: Icons.home,
                          // keyboardType: TextInputType.phone,
                          setValue: _setInputValue,
                          initialValue: _formData['company_postcode'],
                          field: 'company_postcode',
                          isFirst: false,
                          isLast: false,
                        ),
                        TextFieldWidget(
                          labelText: "City",
                          hintText: "City",
                          iconData: Icons.home,
                          // keyboardType: TextInputType.phone,
                          setValue: _setInputValue,
                          initialValue: _formData['company_city'],
                          field: 'company_city',
                          isFirst: false,
                          isLast: false,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 14, left: 20, right: 20),
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 0, bottom: 0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(0)),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        Get.theme.focusColor.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5)),
                              ],
                              border: Border.all(
                                  color:
                                      Get.theme.focusColor.withOpacity(0.05))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "State",
                                style: Get.textTheme.bodyText1,
                                textAlign: TextAlign.start,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownSearch<String>(
                                  mode: Mode.BOTTOM_SHEET,
                                  showSelectedItems: true,
                                  items: state_state,
                                  label: "State",
                                  onChanged: (item) {
                                    _formData['company_state_id'] = '';
                                    final data = stateList
                                        .firstWhere((e) => e['name'] == item);
                                    _formData['company_state_id'] = data['id'];
                                  },
                                  onSaved: (item) {
                                    final data = stateList
                                        .firstWhere((e) => e['name'] == item);
                                    _formData['company_state_id'] = data['id'];
                                  },
                                  selectedItem: selectedState,
                                  validator: (item) {
                                    if (item == null) {
                                      return "Please select state";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 14, left: 20, right: 20),
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 0, bottom: 0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        Get.theme.focusColor.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5)),
                              ],
                              border: Border.all(
                                  color:
                                      Get.theme.focusColor.withOpacity(0.05))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Country",
                                style: Get.textTheme.bodyText1,
                                textAlign: TextAlign.start,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownSearch<String>(
                                  mode: Mode.BOTTOM_SHEET,
                                  showSelectedItems: true,
                                  items: nationality,
                                  label: "Country",
                                  onChanged: (item) {
                                    _formData['company_country_id'] = '';
                                    final data = nationalityList
                                        .firstWhere((e) => e['name'] == item);
                                    _formData['company_country_id'] =
                                        data['id'];
                                  },
                                  onSaved: (item) {
                                    final data = nationalityList
                                        .firstWhere((e) => e['name'] == item);
                                    _formData['company_country_id'] =
                                        data['id'];
                                  },
                                  selectedItem: selectedCountry,
                                  validator: (item) {
                                    if (item == null) {
                                      return "Please select country";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextFieldWidget(
                          // labelText: "Remark / Reason",
                          // hintText: "Remark / Reason",
                          labelText: "Referral Passing Details",
                          hintText: "Referral Passing Details",

                          keyboardType: TextInputType.multiline,
                          iconData: Icons.textsms,
                          // keyboardType: TextInputType.phone,
                          setValue: _setInputValue,
                          field: 'remark',
                          validator: RequiredValidator(
                              errorText:
                                  'Referral Passing Details is required'),
                        ),
                        BlockButtonWidget(
                          onPressed: () async {
                            _validateInputs();
                          },
                          color: kPrimaryColor,
                          text: const Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20)
                      ],
                    ),
                  )
                ],
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "My Profile",
                    style: TextStyle(
                      color: kSecondaryColor,
                    ),
                  ),
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  backgroundColor: kPrimaryColor,
                  elevation: 0,
                ),
                body: const LoadingWidget(),
              );
            }
          }),
        ));
  }

  void _setInputValue(String field, String value) {
    setState(() => _formData[field] = value.trim());
  }

  void _showSuccessMessage(BuildContext context, String key) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(key), backgroundColor: Colors.red));
  }

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Please enter an valid email')
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(6, errorText: 'Password must be at least 6 digits long'),
  ]);

  final phoneNumberValidator = MultiValidator([
    RequiredValidator(errorText: 'Phone Number is required'),
    MinLengthValidator(10, errorText: 'Phone Number must follow the format'),
    MaxLengthValidator(11, errorText: 'Phone Number must follow the format'),
    PatternValidator(r'(01[0-9]{8,9})',
        errorText: 'Phone Number must follow the format'),
  ]);

  void _validateInputs() {
    final form = _formKey.currentState;
    final formData = {};
    formData['request_user_id'] = userId;
    formData['user_id'] = widget.data['id'];
    formData['name'] = _formData['name'];
    formData['contact'] = "+6${_formData['phone_number']}";
    formData['email'] = _formData['email'];
    formData['remark'] = _formData['remark'];
    formData['company_name'] = _formData['company_name'];
    formData['company_address'] = _formData['company_address'];
    formData['company_postcode'] = _formData['company_postcode'];
    formData['company_city'] = _formData['company_city'];
    formData['company_state_id'] = _formData['company_state_id'];
    formData['company_country_id'] = 8;

    print("formData${formData}");
    if (form!.validate()) {
      form.save();
      Timer(const Duration(milliseconds: 600), () {
        showProgress(context);
        context
            .read<EntrepreneursBloc>()
            .add(UpdateToRequestRefferal(formData));
      });
    }
  }

  Future getFuture() {
    return Future(() async {
      await Future.delayed(const Duration(seconds: 2));
      return 'Submit Successfully!';
    });
  }

  Future<void> showProgress(
    BuildContext context,
  ) async {
    var result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(getFuture(),
          message:
              Text('Refferal Request to \n' + widget.data['name'] + ' ...')),
    );
    showResultDialog(context, result);
    // return result;
  }

  void showResultDialog(
    BuildContext context,
    String result,
  ) {
    showDialog<String>(
        // barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Send Request Successful'),
              content: Text(
                  'You have send request to ${widget.data['name']} successful.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(
                        context, '/entrepreneur_details_view_page',
                        arguments: {'data': widget.data});
                    // Navigator.pop(context);
                  },
                  child: const Text('OK'),
                  style: TextButton.styleFrom(primary: Colors.black),
                ),
              ],
            ));
    // Navigator.pop(context);
    // getDetails(widget.data['id']);

    // Navigator.pushReplacementNamed(context, '/entrepreneur_details_view_page',
    //     arguments: {'data': widget.data});
  }
}
