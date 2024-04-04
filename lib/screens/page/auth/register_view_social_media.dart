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
import 'package:mlcc_app_ios/screens/page/auth/register_four_education.dart';
import 'package:mlcc_app_ios/screens/page/auth/register_tree_social_media.dart';
import 'package:mlcc_app_ios/screens/page/auth/register_two_company.dart';
import 'package:mlcc_app_ios/widget/account_list_widget.dart';
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

class RegisterviewSocialMedia extends StatefulWidget {
  //final List data;
  // final Map arguments;

  const RegisterviewSocialMedia({Key? key}) : super(key: key);

  @override
  _RegisterviewSocialMediaState createState() =>
      _RegisterviewSocialMediaState();
}

class _RegisterviewSocialMediaState extends State<RegisterviewSocialMedia> {
  final bool showEdit = true;
  final bool disableEdit = false;
  Map<String, dynamic> userData = {};
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
    // final dynamic args = ModalRoute.of(context)!.settings.arguments;

    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
      if (state is GetUserDetailsSuccessful) {
        Map<String, dynamic> userData = state.userData[0];

        return _buildContent(context, userData);
      } else {
        return WillPopScope(
          onWillPop: () async {
            return backtoPrevious();
          },
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                Register_two_company()));
                  },
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
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  Register_four_education()));
                    },
                    child: Text("Skip",
                        style: TextStyle(
                          color: kSecondaryColor,
                        )),
                  )
                ],
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

  Widget _buildContent(context, userDetailInfo) {
    if (userDetailInfo['social_medias'].length > 0) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Register_two_company()));
            },
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
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildSocialMedia(context, userDetailInfo)),
        bottomNavigationBar: SizedBox(
          height: 90,
          child: Column(
            children: [
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Register_four_education()));
                              },
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: kPrimaryColor,
                              child: const Text("Skip",
                                  style: TextStyle(color: kSecondaryColor)),
                              elevation: 0,
                              highlightElevation: 0,
                              hoverElevation: 0,
                              focusElevation: 0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      Register_tree_social_media()));
                            },
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: kPrimaryColor,
                            child: const Text("+ Social Media",
                                style: TextStyle(color: kSecondaryColor)),
                            elevation: 0,
                            highlightElevation: 0,
                            hoverElevation: 0,
                            focusElevation: 0,
                          ),
                        ),
                      ],
                    ).paddingSymmetric(vertical: 10, horizontal: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          Register_two_company()));
            },
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
        body: Center(
          child: SizedBox(
            height: 600.0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("No records found!",
                          style:
                              TextStyle(color: kThirdColor.withOpacity(0.7))),
                    ],
                  )
                ]),
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 90,
          child: Column(
            children: [
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Register_four_education()));
                              },
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: kPrimaryColor,
                              child: const Text("Skip",
                                  style: TextStyle(color: kSecondaryColor)),
                              elevation: 0,
                              highlightElevation: 0,
                              hoverElevation: 0,
                              focusElevation: 0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      Register_tree_social_media()));
                            },
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: kPrimaryColor,
                            child: const Text("+ Social Media",
                                style: TextStyle(color: kSecondaryColor)),
                            elevation: 0,
                            highlightElevation: 0,
                            hoverElevation: 0,
                            focusElevation: 0,
                          ),
                        ),
                      ],
                    ).paddingSymmetric(vertical: 10, horizontal: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: kPrimaryColor,
        //   onPressed: () {
        //     Navigator.of(context).push(MaterialPageRoute(
        //         builder: (context) => Register_tree_social_media()));
        //   },
        //   tooltip: 'add',
        //   child: const Icon(Icons.add),
        // )
      );
    }
  }

  List<Widget> _buildSocialMedia(
      BuildContext context, Map<String, dynamic> userDetailInfo) {
    List<Widget> widgetList = [];
    Text("tes");
    if (userDetailInfo['social_medias'] != null) {
      userDetailInfo['social_medias'].forEach((item) {
        widgetList.add(
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
                Widget>[
          Expanded(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item['platform'],
                      style: Theme.of(context).textTheme.bodyText2),
                  Text('${item['url']}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.grey)),
                ]),
          )),
          Row(
            children: [
              // if (disableEdit == false)

              IconButton(
                  icon: const Icon(Icons.edit, color: kPrimaryColor),
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/account_social_media_view_page',
                        arguments: {'data': item});
                  }),
              // if (disableEdit == false)
              IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text('Notices'),
                              content: const Text(
                                  'Are you sure you want to delete ?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                  style: TextButton.styleFrom(
                                      primary: Colors.black),
                                ),
                                TextButton(
                                  onPressed: () {
                                    var _formData = {
                                      "user_id": userDetailInfo['user_id'],
                                      "social_media_id": item['id'],
                                      "type": "Social Media"
                                    };
                                    context.read<AuthBloc>().add(
                                        DeleteUpdateSocialMedia(_formData));
                                    Timer(const Duration(milliseconds: 600),
                                        () {
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  RegisterviewSocialMedia()));

                                      // Navigator.pushReplacement(
                                      //     context,
                                      //     PageTransition(
                                      //       type: PageTransitionType.fade,
                                      //       child: const MainScreen(
                                      //         page: AccountViewPage(),
                                      //         index: 4,
                                      //       ),
                                      //     ));
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             AccountListWidgetPage(
                                      //                 disableEdit:
                                      //                     disableEdit,
                                      //                 navigateToEditPageRoute:
                                      //                     "/account_social_media_view_page",
                                      //                 label:
                                      //                     "Social Media")));
                                    });
                                  },
                                  child: const Text('OK'),
                                  style: TextButton.styleFrom(
                                      primary: Colors.blue),
                                ),
                              ],
                            ));
                  }),
            ],
          )
        ]));
        widgetList.add(const SizedBox(height: 10.0));
      });
      if (widgetList.isNotEmpty) {
        widgetList.removeLast();
      }
    }
    return widgetList;
  }

  void _showSuccessMessage(BuildContext context, String key) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(key), backgroundColor: Colors.green));
  }
}
