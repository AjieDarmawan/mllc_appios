// ignore_for_file: prefer_is_empty
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';
import 'package:mlcc_app_ios/screens/page/account/account_view.dart';
import 'package:mlcc_app_ios/widget/checkbox_field_widget.dart';
import 'package:mlcc_app_ios/widget/date_field_widget.dart';
import 'package:mlcc_app_ios/widget/text_field_widget.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../main_view.dart';

class Register_tree_social_media extends StatefulWidget {
  //final List data;
  // final Map arguments;

  const Register_tree_social_media({Key? key}) : super(key: key);

  @override
  _Register_tree_social_mediaState createState() =>
      _Register_tree_social_mediaState();
}

class _Register_tree_social_mediaState
    extends State<Register_tree_social_media> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> userData = {};

  final Map<String, dynamic> _formData = {
    'social_media_id': null,
    'platform': null,
    'url': null,
  };

  // @override
  // void didChangeDependencies(userData) {
  //   if (args != null) {
  //     _formData['social_media_id'] = args['data']['id'];
  //     _formData['platform'] = args['data']['platform'];
  //     _formData['url'] = args['data']['url'];
  //   }
  //   super.didChangeDependencies();
  // }

  int userId = 0;
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
      final _formData_post = {};
      _formData_post['user_id'] = userId;

      // userdata();

      print("_formData_post${_formData_post}");

      if (userId != 0) {
        context.read<AuthBloc>().add(GetUserDetails(_formData_post));
      }
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
      if (state is GetUserDetailsSuccessful) {
        userData = state.userData[0];
        //_formData['social_media_id'] = userData['id'];
        _formData['platform'] = userData['platform'];
        _formData['url'] = userData['url'];

        return _buildContent(context, userData);
      } else {
        return WillPopScope(
          onWillPop: () async {
            return backtoPrevious();
          },
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.keyboard_arrow_left, size: 30),
                ),
                title: const Text(
                  "Social Media",
                  style: TextStyle(
                    color: kSecondaryColor,
                  ),
                ),
                centerTitle: true,
                backgroundColor: kPrimaryColor,
                elevation: 0,
              ),
              body: const LoadingWidget()),
        );
        // return const LoadingWidget();
      }
    });
  }

  backtoPrevious() {
    Navigator.pop(context);
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> userData) {
    bool _disableEdit = false;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            "Social Media",
            style: TextStyle(
              color: kSecondaryColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        //bottomNavigationBar:

        body: Form(
          key: _formKey,
          child: ListView(primary: true, children: [
            // const Text("Profile details")
            //     .paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
            // const Text("Change the following details and save them")
            //     .paddingSymmetric(horizontal: 22, vertical: 5),
            TextFieldWidget(
              labelText: "Social Media Platform",
              mandatory: "*",
              // iconData: Icons.ac_unit,
              iconData: FontAwesomeIcons.hashtag,
              setValue: _setInputValue,
              field: 'platform',
              validator: RequiredValidator(
                  errorText: 'Social Media Platform is required'),
              initialValue: _formData['platform'],
            ),
            TextFieldWidget(
              mandatory: "*",
              labelText: "Social Media URL",
              //iconData: Icons.ac_unit,
              iconData: FontAwesomeIcons.link,
              setValue: _setInputValue,
              field: 'url',
              validator:
                  RequiredValidator(errorText: 'Social Media URL is required'),
              initialValue: _formData['url'],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: kThirdColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (BuildContext context, AuthState state) {
                    if (state is AuthLoading) {
                      return const LoadingWidget();
                    } else {
                      return MaterialButton(
                        onPressed: () {
                          final form = _formKey.currentState;
                          if (form!.validate()) {
                            form.save();
                            print("_formDatasocialmedia${_formData}");
                            context
                                .read<AuthBloc>()
                                .add(CreateUpdateSocialMedia(_formData));
                            Navigator.pop(context);
                          }
                        },
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: kPrimaryColor,
                        child: const Text("Save",
                            style: TextStyle(color: kSecondaryColor)),
                        elevation: 0,
                        highlightElevation: 0,
                        hoverElevation: 0,
                        focusElevation: 0,
                      );
                    }
                  })),
                ],
              ).paddingSymmetric(vertical: 10, horizontal: 20),
            ),
          ]),
        ));
  }

  void _setInputValue(String field, String value) {
    setState(() => _formData[field] = value.trim());
  }

  void _showSuccessMessage(BuildContext context, String key) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(key), backgroundColor: Colors.green));
  }
}
