import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/account/account_view.dart';
import 'package:mlcc_app_ios/widget/account_list_widget.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';

class AccountSocialMediaListViewPage extends StatelessWidget {
  final bool showEdit;
  final bool disableEdit;

  const AccountSocialMediaListViewPage(
      {Key? key, this.showEdit = false, required this.disableEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (BuildContext context, AuthState state) async {
      if (state is UpdateDataSuccessful) {
        _showSuccessMessage(context, 'Update Social Media Successful');
      } else if (state is CreateDataSuccessful) {
        _showSuccessMessage(context, 'Create Social Media Successful');
      } else if (state is ErrorOccured) {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Social Media Error'),
                  content: const Text('Error occured! Please try again!'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                      style: TextButton.styleFrom(primary: Colors.black),
                    ),
                  ],
                ));
      }
    }, child: BlocBuilder<AuthBloc, AuthState>(
            builder: (BuildContext context, AuthState state) {
      if (state is GetUserDetailsSuccessful) {
        Map<String, dynamic> userData = state.userData[0];
        return _buildContent(context, userData);
      } else {
        return const LoadingWidget();
      }
    }));
  }

  Widget _buildContent(context, userDetailInfo) {
    if (userDetailInfo['social_medias'].length > 0) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildSocialMedia(context, userDetailInfo));
    } else {
      return SizedBox(
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
                      style: TextStyle(color: kThirdColor.withOpacity(0.7))),
                ],
              )
            ]),
      );
    }
  }

  List<Widget> _buildSocialMedia(
      BuildContext context, Map<String, dynamic> userDetailInfo) {
    List<Widget> widgetList = [];
    if (userDetailInfo['social_medias'] != null) {
      userDetailInfo['social_medias'].forEach((item) {
        widgetList.add(
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
                Widget>[
          Expanded(
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
              ])),
          showEdit
              ? Row(
                  children: [
                    if (disableEdit == false)
                      IconButton(
                          icon: const Icon(Icons.edit, color: kPrimaryColor),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, '/account_social_media_view_page',
                                arguments: {'data': item});
                          }),
                    if (disableEdit == false)
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
                                              "user_id":
                                                  userDetailInfo['user_id'],
                                              "social_media_id": item['id'],
                                              "type": "Social Media"
                                            };
                                            context.read<AuthBloc>().add(
                                                DeleteUpdateSocialMedia(
                                                    _formData));
                                            Timer(
                                                const Duration(
                                                    milliseconds: 600), () {
                                              Navigator.of(context).popUntil(
                                                  (route) => route.isFirst);
                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    child: const MainScreen(
                                                      page: AccountViewPage(),
                                                      index: 2,
                                                    ),
                                                  ));
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AccountListWidgetPage(
                                                              disableEdit:
                                                                  disableEdit,
                                                              navigateToEditPageRoute:
                                                                  "/account_social_media_view_page",
                                                              label:
                                                                  "Social Media")));
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
              : Container()
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
