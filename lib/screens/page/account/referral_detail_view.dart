// ignore_for_file: prefer_is_empty
import 'dart:async';

import 'package:delayed_display/delayed_display.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/entrepreneurs/entrepreneurs_bloc.dart';

import 'package:mlcc_app_ios/constant.dart';

import 'package:form_field_validator/form_field_validator.dart';
import 'package:mlcc_app_ios/screens/page/account/referral_view.dart';

import '../../../widget/block_button_widget.dart';
import '../../../widget/text_field_widget.dart';

class ReferralDetailViewPage extends StatefulWidget {
  final dynamic data;
  const ReferralDetailViewPage({Key? key, this.data}) : super(key: key);

  @override
  _ReferralDetailViewPageState createState() => _ReferralDetailViewPageState();
}

class _ReferralDetailViewPageState extends State<ReferralDetailViewPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  int userId = 0;
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;

      // if (widget.data['connect_user_id'].isNotEmpty &&
      //     widget.data['connect_user_id'].contains(userId) == true) {
      //   _connect = "Approve";
      // }
      // if (widget.data['pending_user_id'].isNotEmpty &&
      //     widget.data['pending_user_id'].contains(userId) == true) {
      //   _connect = "Pending";
      // }
      // if (widget.data['reject_user_id'].isNotEmpty &&
      //     widget.data['reject_user_id'].contains(userId) == true) {
      //   _connect = "Reject";
      // }
    });
  }

  @override
  void initState() {
    getUser();
    _formData['name'] = widget.data['name'];
    _formData['contact'] = widget.data['contact'];
    _formData['email'] = widget.data['email'];
    _formData['remark'] = widget.data['remark'];
    _formData['company_name'] = widget.data['company_name'];
    _formData['company_address'] = widget.data['company_address'];
    _formData['status'] = widget.data['status'];

    bool rejected = false;
    var _color;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  backtoPrevious() {
    Navigator.pushReplacement(
      context,
      PageTransition(
          type: PageTransitionType.fade,
          child: ReferralRequestListPage(
            userID: userId,
            referralID: 0,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return backtoPrevious();
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: ReferralRequestListPage(
                        userID: userId,
                        referralID: 0,
                      )),
                );
              },
              icon: const Icon(Icons.keyboard_arrow_left, size: 30),
            ),
            title: const Text(
              "Referee to Referral",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: kPrimaryColor,
            elevation: 0,
          ),
          body: ListView(
            primary: true,
            children: [
              if (widget.data['referral_name'] != null)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child:
                      Text('Send Request to : ' + widget.data['referral_name']),
                ),
              if (widget.data['referree_name'] != null)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child:
                      Text('Send Request to : ' + widget.data['referree_name']),
                ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        widget.data['status'].toString(),
                        style:
                            const TextStyle(color: kThirdColor, fontSize: 18),
                      ),
                    ),

                    TextFieldWidget(
                        labelText: "Email Address",
                        hintText: "johndoe@gmail.com",
                        iconData: Icons.alternate_email,
                        keyboardType: TextInputType.emailAddress,
                        isFirst: true,
                        isLast: false,
                        setValue: _setInputValue,
                        field: 'email',
                        readOnly: true,
                        initialValue: _formData['email'],
                        validator: emailValidator),
                    TextFieldWidget(
                      labelText: "Name",
                      hintText: "Lee Wei Wei",
                      iconData: Icons.person_outline,
                      isFirst: false,
                      isLast: false,
                      setValue: _setInputValue,
                      field: 'name',
                      readOnly: true,
                      initialValue: _formData['name'],
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
                      readOnly: true,
                      initialValue: _formData['contact'],
                      validator: phoneNumberValidator,
                    ),
                    TextFieldWidget(
                      labelText: "Company Name",
                      hintText: "Company Address",
                      iconData: Icons.business,
                      isFirst: false,
                      isLast: true,
                      setValue: _setInputValue,
                      field: 'company_name',
                      readOnly: true,
                      initialValue: _formData['company_name'],
                    ),
                    TextFieldWidget(
                      labelText: "Company Address",
                      hintText: "Company Address",
                      keyboardType: TextInputType.multiline,
                      iconData: Icons.home,
                      // keyboardType: TextInputType.phone,
                      isFirst: false,
                      isLast: true,
                      setValue: _setInputValue,
                      field: 'company_address',
                      readOnly: true,
                      initialValue: _formData['company_address'],
                    ),
                    TextFieldWidget(
                      labelText: "Remark / Reason",
                      hintText: "Remark / Reason",
                      keyboardType: TextInputType.multiline,
                      iconData: Icons.textsms,
                      // keyboardType: TextInputType.phone,
                      isFirst: false,
                      isLast: true,
                      setValue: _setInputValue,
                      field: 'remark',
                      readOnly: true,
                      initialValue: _formData['remark'],
                      validator: RequiredValidator(
                          errorText: 'Remark / Reason is required'),
                    ),
                    // BlockButtonWidget(
                    //   onPressed: () async {
                    //     _validateInputs();
                    //   },
                    //   color: kPrimaryColor,
                    //   text: const Text(
                    //     "Submit",
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    // ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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
    formData['contact'] = _formData['contact'];
    formData['email'] = _formData['email'];
    formData['remark'] = _formData['remark'];
    formData['company_name'] = _formData['company_name'];
    formData['company_address'] = _formData['company_address'];
    if (form!.validate()) {
      form.save();
      Timer(const Duration(milliseconds: 600), () {
        showProgress(context);
        context
            .read<EntrepreneursBloc>()
            .add(UpdateToRequestRefferal(formData));
        // Navigator.pop(context);
        // Navigator.pushReplacementNamed(context, '/training_details_view_page',
        //     arguments: {
        //       'data': widget.data,
        //       'trainingList': widget.trainingList
        //     });
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
              content: Text('You have send request to' +
                  widget.data['name'] +
                  'successful.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
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
