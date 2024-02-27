import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/account/account_subcription.dart';
import 'package:mlcc_app_ios/screens/page/account/order_history_view.dart';
import 'package:mlcc_app_ios/screens/page/account/referral_view.dart';
import 'package:mlcc_app_ios/screens/page/home/connect_list.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';
import 'package:mlcc_app_ios/screens/page/notification/notification_list.dart';
import 'package:mlcc_app_ios/screens/page/webview/unsubscribe_recurring_page.dart';
import 'package:mlcc_app_ios/screens/page/zoom_meeting.dart';
import 'package:mlcc_app_ios/widget/account_link_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mlcc_app_ios/widget/account_list_widget.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';
import 'package:package_info/package_info.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountViewPage extends StatefulWidget {
  const AccountViewPage({Key? key}) : super(key: key);

  @override
  _AccountViewPageState createState() => _AccountViewPageState();
}

class _AccountViewPageState extends State<AccountViewPage> {
  Map<String, dynamic> userData = {};
  final Map<String, dynamic> _formData = {};
  final ImagePicker _picker = ImagePicker();
  File? selectImage;

  var email = "";
  var username = "";
  int userId = 0;
  var image;
  var thumbnail = "";
  late String versionName = '';
  dynamic notificationList = [];
  dynamic notificationItem = [];
  dynamic notification = [];
  int total = 0;
  int totalRequest = 0;
  int totalRefferal = 0;
  dynamic contactUs = [];
  Future<void> info() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() => versionName = packageInfo.version);
  }

  var connectList = [];
  dynamic refferalList = [];

  getContactUsInfo() async {
    contactUs = await httpProvider.getHttp("aboutUs");
  }

  List planList = [];
  late bool showExpired = false;
  Future<void> getPlan() async {
    planList = await httpProvider.getHttp("member_package");
  }

  Future<void> _showLoading(
    BuildContext context,
  ) async {
    var result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(getFuture(),
          message: const Text('Please Waiting...')),
    );
    showResultDialogLoading(context, result);
    // return result;
  }

  void showResultDialogLoading(
    BuildContext context,
    String result,
  ) {
    // Navigator.pop(context);
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: const MainScreen(page: HomePage(), index: 0),
      ),
    );
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString("email")!;
      username = prefs.getString("username")!;
      showExpired = prefs.getBool("isExpired")!;
      userId = prefs.getInt("userId")!;
      if (showExpired == true) {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Notices'),
                  content: const Text(
                      'Membership period is expired. \nPlease make a payment to renew.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                      style: TextButton.styleFrom(primary: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/payment_webview_page',
                            arguments: {
                              'userId': userId,
                              'training': 0,
                              'event': 0,
                              'product': 0,
                            });
                      },
                      child: const Text('Pay'),
                      style: TextButton.styleFrom(primary: Colors.blue),
                    ),
                  ],
                ));
      }
    });
    dynamic formData = {'user_id': prefs.getInt("userId")!};
    getNotificationList(prefs.getInt("userId"));
    // Timer(const Duration(milliseconds: 600), () {
    context.read<AuthBloc>().add(GetUserDetails(formData));
    // });
  }

  void getNotificationList(id) async {
    final _formData = {};
    _formData['user_id'] = id;
    refferalList = await httpProvider.postHttp2(
        "entrepreneur/referral/listing", _formData);
    if (refferalList.isNotEmpty) {
      setState(() {
        totalRefferal = refferalList['pending_count'];
      });
    }

    connectList = await httpProvider
        .postHttp2("entrepreneur/connect/listing", {'user_id': id});
    if (connectList.isNotEmpty) {
      setState(() {
        totalRequest = connectList[0]['pending_request'];
      });
    }

    notification =
        await httpProvider.postHttp("notification/listing", _formData);
    if (notification.isNotEmpty) {
      setState(() {
        for (var item in notification) {
          if (item['type'] != 'Entrepreneurs') {
            if (item['status'] == 0) {
              notificationItem.add(item);
              total++;
            }
            notificationList.add(item);
          }
        }
      });
    }
  }

  @override
  void initState() {
    info();
    getUser();
    getPlan();
    getContactUsInfo();
    super.initState();
  }

  // @override
  // void dispose() {
  //   context.read<AuthBloc>().add(const UnloadAuthState());
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) async {
        if (state is UpdatePersonalBasicInfoDataSuccessful) {
          _showSuccessMessage(context, 'Update Personal Basic Info Successful');
        } else if (state is ErrorOccured) {
          // showDialog<String>(
          //     context: context,
          //     builder: (BuildContext context) => AlertDialog(
          //           title: const Text('Personal Basic Info Error'),
          //           content: const Text('Error occured! Please try again!'),
          //           actions: <Widget>[
          //             TextButton(
          //               onPressed: () => Navigator.pop(context, 'OK'),
          //               child: const Text('OK'),
          //               style: TextButton.styleFrom(primary: Colors.black),
          //             ),
          //           ],
          //         ));
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
          builder: (BuildContext context, AuthState state) {
        if (state is GetUserDetailsSuccessful) {
          userData = state.userData[0];
          _formData['user_id'] = userData['id'];
          _formData['title_id'] = userData['title_id'];
          _formData['nationality_id'] = userData['nationality_id'];
          _formData['state_id'] = userData['state_id'];
          _formData['name'] = userData['name'];
          _formData['preferred_name'] = userData['preferred_name'];
          _formData['chinese_name'] = userData['chinese_name'];
          _formData['identity_card'] = userData['identity_card'];
          _formData['phone_number'] = userData['phone_number'];
          _formData['passport_number'] = userData['passport_number'];
          _formData['others_nationality'] = userData['others_nationality'];
          _formData['others_state'] = userData['others_state'];
          _formData['gender'] = userData['gender'];
          _formData['introduction'] = userData['introduction'];

          if (userData['thumbnail'] != null) {
            thumbnail = userData['thumbnail'];
          }

          return _buildContent(context, userData);
        } else {
          print("gender123view${userData['name']}");
          print("gender123viewgender${userData['gender']}");
          print("gender123viewgender_id${userData['gender_id']}");
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
    );

    // return BlocBuilder<AuthBloc, AuthState>(
    //     builder: (BuildContext context, AuthState state) {
    //   if (state is GetUserDetailsSuccessful) {
    //     userData = state.userData[0];
    //     return _buildContent(context, userData);
    //   } else {
    //     // return const LoadingWidget();
    //     // return _buildContent(context, userData);
    //     return Scaffold(
    //       appBar: AppBar(
    //         title: const Text(
    //           "My Profile",
    //           style: TextStyle(
    //             color: kSecondaryColor,
    //           ),
    //         ),
    //         centerTitle: true,
    //         backgroundColor: kPrimaryColor,
    //         elevation: 0,
    //       ),
    //       body: const LoadingWidget(),
    //     );
    //   }
    // });
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> userData) {
    bool _disableEdit = false;
    if (userData['member_type_string'] == 'Ambassador') {
      _disableEdit = true;
    }

    if (showExpired == true) {
      _disableEdit = true;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Profile",
            style: TextStyle(
              color: kSecondaryColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          primary: true,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(10)),
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
                          userData['name'],
                          style: const TextStyle(color: kSecondaryColor),
                        ),
                        const SizedBox(height: 10),
                        Text(userData['email'],
                            style: const TextStyle(color: kSecondaryColor)),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: GestureDetector(
                        onTap: () {
                          if (_disableEdit == true) {
                            showDialog<String>(
                                // barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Notices'),
                                      content: const Text(
                                          'You are not allowed to change profile picture.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('OK'),
                                          style: TextButton.styleFrom(
                                              primary: Colors.black),
                                        ),
                                      ],
                                    ));
                          } else {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                      height: 170.0,
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            const Text("Profile Image"),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            const Divider(),
                                            FlatButton(
                                                child: const Text(
                                                    "Select Image From Gallery"),
                                                onPressed: () async {
                                                  image =
                                                      await _picker.pickImage(
                                                          source: ImageSource
                                                              .gallery,
                                                          imageQuality: 50);
                                                  print(image);
                                                  _formData['thumbnail'] =
                                                      image;
                                                  setState(() {
                                                    if (image != null) {
                                                      selectImage =
                                                          File(image.path);
                                                      Navigator.pop(context);

                                                      context
                                                          .read<AuthBloc>()
                                                          .add(UpdateUserDetail(
                                                              _formData));
                                                      Timer(
                                                          const Duration(
                                                              milliseconds:
                                                                  1000), () {
                                                        context
                                                            .read<AuthBloc>()
                                                            .add(
                                                                const UnloadAuthState());
                                                      });
                                                    }
                                                  });
                                                }),
                                            FlatButton(
                                                child: const Text(
                                                    "Take Image From Camera"),
                                                onPressed: () async {
                                                  image =
                                                      await _picker.pickImage(
                                                          source: ImageSource
                                                              .camera,
                                                          imageQuality: 50);
                                                  _formData['thumbnail'] =
                                                      image;
                                                  setState(() {
                                                    if (image != null) {
                                                      selectImage =
                                                          File(image.path);
                                                      Navigator.pop(context);

                                                      context
                                                          .read<AuthBloc>()
                                                          .add(UpdateUserDetail(
                                                              _formData));
                                                      Timer(
                                                          const Duration(
                                                              milliseconds:
                                                                  1000), () {
                                                        context
                                                            .read<AuthBloc>()
                                                            .add(
                                                                const UnloadAuthState());
                                                      });
                                                    }
                                                  });
                                                }),
                                          ]));
                                });
                          }
                        },
                        child: (thumbnail == "" && selectImage == null)
                            ? Image.asset(
                                'assets/mlcc_logo.jpg',
                                fit: BoxFit.contain,
                                width: 100,
                                height: 100,
                              )
                            : (selectImage != null)
                                ? Image.file(
                                    selectImage!,
                                    fit: BoxFit.contain,
                                    width: 100,
                                    height: 100,
                                  )
                                : Image.network(
                                    thumbnail,
                                    fit: BoxFit.contain,
                                    width: 100,
                                    height: 100,
                                  ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: kThirdColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5)),
                ],
                border: Border.all(color: kThirdColor.withOpacity(0.05)),
                // gradient: gradient,
              ),
              child: Column(
                children: [
                  // AccountLinkWidget(
                  //   icon: const Icon(Icons.savings, color: kPrimaryColor),
                  //   text: const Text("My Subscription"),
                  //   onTap: (e) async {
                  //     Navigator.push(
                  //       context,
                  //       PageTransition(
                  //           type: PageTransitionType.fade,
                  //           child: SubsciptionPlanPage(
                  //               data: userData, planList: planList)),
                  //     );
                  //   },
                  // ),
                  // AccountLinkWidget(
                  //   icon: const Icon(Icons.shopping_bag, color: kPrimaryColor),
                  //   text: const Text("Order History"),
                  //   onTap: (e) async {
                  //     Navigator.push(
                  //       context,
                  //       PageTransition(
                  //           type: PageTransitionType.fade,
                  //           child: OrderHistoryListPage(
                  //               userID: userData['id'], orderID: 0)),
                  //     );
                  //   },
                  // ),
                  AccountLinkWidget(
                    icon: const Icon(Icons.supervised_user_circle,
                        color: kPrimaryColor),
                    text: Row(
                      children: [
                        const Text("Pending Request"),
                        if (totalRequest != 0)
                          Container(
                              margin: const EdgeInsets.only(left: 10),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '$totalRequest',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )),
                      ],
                    ),
                    onTap: (e) async {
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: RequestListPage(
                                userId: userData['id'], resquestID: 0)),
                      );
                    },
                  ),
                  AccountLinkWidget(
                    icon: const Icon(Icons.people, color: kPrimaryColor),
                    text: Row(
                      children: [
                        const Text("Referral List"),
                        if (totalRefferal != 0)
                          Container(
                              margin: const EdgeInsets.only(left: 10),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '$totalRefferal',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )),
                      ],
                    ),
                    onTap: (e) async {
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: ReferralRequestListPage(
                              userID: userData['id'],
                              referralID: 0,
                            )),
                      );
                    },
                  ),
                  AccountLinkWidget(
                    icon: const Icon(Icons.notifications, color: kPrimaryColor),
                    text: Row(
                      children: [
                        const Text("Notification"),
                        if (total != 0)
                          Container(
                              margin: const EdgeInsets.only(left: 10),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '$total',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )),
                      ],
                    ),
                    onTap: (e) async {
                      showProgress(context);
                    },
                  ),
                  // AccountLinkWidget(
                  //   icon: const Icon(Icons.video_call, color: kPrimaryColor),
                  //   text: const Text("Join Meeting"),
                  //   onTap: (e) async {
                  //     Navigator.push(
                  //       context,
                  //       PageTransition(
                  //           type: PageTransitionType.fade, child: JoinWidget()),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: kThirdColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5)),
                ],
                border: Border.all(color: kThirdColor.withOpacity(0.05)),
                // gradient: gradient,
              ),
              child: Column(
                children: [
                  AccountLinkWidget(
                    //icon: const Icon(Icons.ac_unit,
                    icon: const Icon(FontAwesomeIcons.userEdit,
                        color: kPrimaryColor),
                    text: const Text("Personal Basic Info"),
                    onTap: (e) {
                      Navigator.pushNamed(
                          context, '/account_personal_basic_info_view_page',
                          arguments: {
                            'data': userData,
                            'disableEdit': _disableEdit
                          });
                    },
                  ),
                  AccountLinkWidget(
                    // icon: const Icon(Icons.ac_unit,
                    icon: const Icon(FontAwesomeIcons.hashtag,
                        color: kPrimaryColor),
                    text: const Text("Social Media"),
                    onTap: (e) {
                      // Navigator.pushNamed(
                      //     context, '/account_social_media_view_page');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountListWidgetPage(
                                  disableEdit: _disableEdit,
                                  navigateToEditPageRoute:
                                      "/account_social_media_view_page",
                                  label: "Social Media")));
                    },
                  ),
                  AccountLinkWidget(
                    // icon: const Icon(Icons.ac_unit,
                    icon: const Icon(FontAwesomeIcons.university,
                        color: kPrimaryColor),
                    text: const Text("Education"),
                    onTap: (e) {
                      // Navigator.pushNamed(
                      //     context, '/account_education_view_page');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountListWidgetPage(
                                  disableEdit: _disableEdit,
                                  navigateToEditPageRoute:
                                      "/account_education_view_page",
                                  label: "Education")));
                    },
                  ),
                  AccountLinkWidget(
                    // icon: const Icon(Icons.ac_unit,
                    icon: const Icon(FontAwesomeIcons.users,
                        color: kPrimaryColor),
                    text: const Text("Societies"),
                    onTap: (e) {
                      // Navigator.pushNamed(
                      //     context, '/account_societies_view_page');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountListWidgetPage(
                                  disableEdit: _disableEdit,
                                  navigateToEditPageRoute:
                                      "/account_societies_view_page",
                                  label: "Societies")));
                    },
                  ),
                  AccountLinkWidget(
                    icon: const Icon(FontAwesomeIcons.certificate,
                        //icon: const Icon(Icons.ac_unit,
                        color: kPrimaryColor),
                    text: const Text("Professional Cert & Rewards"),
                    onTap: (e) {
                      // Navigator.pushNamed(
                      //     context, '/account_professional_cert_view_page');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountListWidgetPage(
                                  disableEdit: _disableEdit,
                                  navigateToEditPageRoute:
                                      "/account_professional_cert_view_page",
                                  label: "Professional Cert & Rewards")));
                    },
                  ),
                  AccountLinkWidget(
                    //icon: const Icon(Icons.ac_unit,
                    icon: const Icon(FontAwesomeIcons.briefcase,
                        color: kPrimaryColor),
                    text: const Text("Work Experienced"),
                    onTap: (e) {
                      // Navigator.pushNamed(
                      //     context, '/account_work_experienced_view_page');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountListWidgetPage(
                                  disableEdit: _disableEdit,
                                  navigateToEditPageRoute:
                                      "/account_work_experienced_view_page",
                                  label: "Work Experienced")));
                    },
                  ),
                  AccountLinkWidget(
                    icon: const Icon(Icons.business, color: kPrimaryColor),
                    text: const Text("Company Information"),
                    onTap: (e) {
                      // Navigator.pushNamed(
                      //     context, '/account_work_experienced_view_page');
                      Navigator.pushNamed(
                          context, '/account_company_info_view_page',
                          arguments: {
                            'data': userData['company_details'],
                            'disable': _disableEdit
                          });
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: kThirdColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5)),
                ],
                border: Border.all(color: kThirdColor.withOpacity(0.05)),
                // gradient: gradient,
              ),
              child: Column(
                children: [
                  AccountLinkWidget(
                    //  icon: const Icon(Icons.ac_unit,
                    icon: const Icon(FontAwesomeIcons.infoCircle,
                        color: kPrimaryColor),
                    text: const Text("About Us"),
                    onTap: (e) async {
                      Navigator.pushNamed(context, '/contact_us_view_page',
                          arguments: {'data': contactUs});
                    },
                  ),
                  // AccountLinkWidget(
                  //   icon: const Icon(FontAwesomeIcons.times,
                  //       color: kPrimaryColor),
                  //   text: const Text("Unsubscribe"),
                  //   onTap: (e) async {
                  //     showDialog<String>(
                  //         context: context,
                  //         builder: (BuildContext context) => AlertDialog(
                  //               title: const Text('Unsubscribe'),
                  //               content: const Text(
                  //                   'Are you sure you want to unsubscribe to automatic renewal?'),
                  //               actions: <Widget>[
                  //                 TextButton(
                  //                   onPressed: () {
                  //                     Navigator.pop(context);
                  //                   },
                  //                   child: const Text('Cancel'),
                  //                   style: TextButton.styleFrom(
                  //                       primary: Colors.black),
                  //                 ),
                  //                 TextButton(
                  //                   onPressed: () async {
                  //                     Navigator.pop(context);
                  //                     var unsubscribe =
                  //                         await httpProvider.getHttp(
                  //                             "ipay88/unsubscribe/$userId");
                  //                     if (unsubscribe['description'] ==
                  //                         'This member not unsubscribe') {
                  //                       //Live
                  //                       // await httpProvider.postHttp(
                  //                       // "ipay88/member/unsubscribe",
                  //                       // {
                  //                       //   'merchant_code':
                  //                       //       unsubscribe['merchant_code'],
                  //                       //   'reference_no':
                  //                       //       unsubscribe['reference_no'],
                  //                       //   'user_id': userId,
                  //                       //   'signature': unsubscribe['signature']
                  //                       // });

                  //                       //Staging
                  //                       await httpProvider.postHttp(
                  //                           "ipay88/member/unsubscribe/simulate",
                  //                           {
                  //                             'merchant_code':
                  //                                 unsubscribe['merchant_code'],
                  //                             'reference_no':
                  //                                 unsubscribe['reference_no'],
                  //                             'user_id': userId,
                  //                             'status': unsubscribe['status'],
                  //                             'errdesc': unsubscribe['errdesc']
                  //                           });

                  //                       showDialog<String>(
                  //                           context: context,
                  //                           builder: (BuildContext context) =>
                  //                               AlertDialog(
                  //                                 title: const Text(
                  //                                     'Delete Account'),
                  //                                 content: const Text(
                  //                                     'Successfuly unsubscribe to this plan.'),
                  //                                 actions: <Widget>[
                  //                                   TextButton(
                  //                                     onPressed: () {
                  //                                       Navigator.pop(context);
                  //                                     },
                  //                                     child:
                  //                                         const Text('Close'),
                  //                                     style:
                  //                                         TextButton.styleFrom(
                  //                                             primary:
                  //                                                 Colors.black),
                  //                                   ),
                  //                                 ],
                  //                               ));
                  //                     } else {
                  //                       showDialog<String>(
                  //                           context: context,
                  //                           builder: (BuildContext context) =>
                  //                               AlertDialog(
                  //                                 title:
                  //                                     const Text('Unsubscribe'),
                  //                                 content: const Text(
                  //                                     'You have already unsubscribed to this plan'),
                  //                                 actions: <Widget>[
                  //                                   TextButton(
                  //                                     onPressed: () {
                  //                                       Navigator.pop(context);
                  //                                     },
                  //                                     child:
                  //                                         const Text('Close'),
                  //                                     style:
                  //                                         TextButton.styleFrom(
                  //                                             primary:
                  //                                                 Colors.black),
                  //                                   ),
                  //                                 ],
                  //                               ));
                  //                     }
                  //                     // Navigator.push(
                  //                     //     context,
                  //                     //     MaterialPageRoute(
                  //                     //         builder: (context) =>
                  //                     //             UnsubscribeRecurring(
                  //                     //               userId: userId,
                  //                     //             )));
                  //                     // Navigator.pop(context);
                  //                     // showDialog<String>(
                  //                     //     context: context,
                  //                     //     builder: (BuildContext context) =>
                  //                     //         AlertDialog(
                  //                     //           title: const Text(
                  //                     //               'You\'ve been unsubscribed.'),
                  //                     //           content: const Text(
                  //                     //               'You will not be charged automatically when your membership expired.'),
                  //                     //           actions: <Widget>[
                  //                     //             TextButton(
                  //                     //               onPressed: () {
                  //                     //                 Navigator.pop(context);
                  //                     //               },
                  //                     //               child: const Text('Close'),
                  //                     //               style: TextButton.styleFrom(
                  //                     //                   primary: Colors.black),
                  //                     //             ),
                  //                     //           ],
                  //                     //         ));
                  //                   },
                  //                   child: const Text('OK'),
                  //                   style: TextButton.styleFrom(
                  //                       primary: Colors.black),
                  //                 ),
                  //               ],
                  //             ));
                  //   },
                  // ),
                  // AccountLinkWidget(
                  //   icon: const Icon(FontAwesomeIcons.userTimes,
                  //       color: kPrimaryColor),
                  //   text: const Text("Delete Account"),
                  //   onTap: (e) async {
                  //     showDialog<String>(
                  //         context: context,
                  //         builder: (BuildContext context) => AlertDialog(
                  //               title: const Text('Delete Account'),
                  //               content: const Text(
                  //                   'Are you sure want to delete this account? You won\'t be able to undo this. You will also be automatically unsubscribe to MLCC payment.'),
                  //               actions: <Widget>[
                  //                 TextButton(
                  //                   onPressed: () {
                  //                     Navigator.pop(context);
                  //                   },
                  //                   child: const Text('Cancel'),
                  //                   style: TextButton.styleFrom(
                  //                       primary: Colors.black),
                  //                 ),
                  //                 TextButton(
                  //                   onPressed: () async {
                  //                     SharedPreferences prefs =
                  //                         await SharedPreferences.getInstance();
                  //                     var unsubscribe =
                  //                         await httpProvider.getHttp(
                  //                             "ipay88/unsubscribe/$userId");
                  //                     if (unsubscribe['description'] ==
                  //                         'This member not unsubscribe') {
                  //                       await httpProvider.postHttp(
                  //                           "ipay88/member/unsubscribe/simulate",
                  //                           {
                  //                             'merchant_code':
                  //                                 unsubscribe['merchant_code'],
                  //                             'reference_no':
                  //                                 unsubscribe['reference_no'],
                  //                             'user_id': userId,
                  //                             'status': unsubscribe['status'],
                  //                             'errdesc': unsubscribe['errdesc']
                  //                           });
                  //                     }

                  //                     await httpProvider.postHttp(
                  //                         "last_access", {
                  //                       'user_id': prefs.getInt("userId"),
                  //                       'push_token': "",
                  //                       'push_token_status': '0'
                  //                     });
                  //                     var delete_account = await httpProvider
                  //                         .postHttp("member/account/delete", {
                  //                       'user_id': prefs.getInt("userId"),
                  //                     });
                  //                     print(delete_account);
                  //                     prefs.setInt("userId", 0);
                  //                     prefs.setBool("isLoggedIn", false);
                  //                     prefs.setString("email", '');
                  //                     prefs.setString("username", '');
                  //                     prefs.setBool("isExpired", false);
                  //                     Navigator.of(context)
                  //                         .popUntil((route) => route.isFirst);
                  //                     Navigator.pushReplacement(
                  //                       context,
                  //                       PageTransition(
                  //                         type: PageTransitionType.fade,
                  //                         child: const MainScreen(
                  //                             page: HomePage(), index: 0),
                  //                       ),
                  //                     );
                  //                     showDialog<String>(
                  //                         context: context,
                  //                         builder: (BuildContext context) =>
                  //                             AlertDialog(
                  //                               title: const Text(
                  //                                   'Delete Account'),
                  //                               content: Text(
                  //                                   'We have temporarily deactivate your account.\nYou are still entitled to member access until expiry date.\n'),
                  //                               actions: <Widget>[
                  //                                 TextButton(
                  //                                   onPressed: () {
                  //                                     Navigator.pop(context);
                  //                                   },
                  //                                   child: const Text('Close'),
                  //                                   style: TextButton.styleFrom(
                  //                                       primary: Colors.black),
                  //                                 ),
                  //                               ],
                  //                             ));
                  //                   },
                  //                   child: const Text('OK'),
                  //                   style: TextButton.styleFrom(
                  //                       primary: Colors.black),
                  //                 ),
                  //               ],
                  //             ));
                  //   },
                  // ),
                  AccountLinkWidget(
                    // icon: const Icon(Icons.logout, color: kPrimaryColor),
                    icon: const Icon(Icons.logout, color: kPrimaryColor),
                    text: const Text("Logout"),
                    onTap: (e) async {
                      _showLoading(context);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await httpProvider.postHttp("last_access", {
                        'user_id': prefs.getInt("userId"),
                        'push_token': "",
                        'push_token_status': '0'
                      });
                      prefs.setInt("userId", 0);
                      prefs.setBool("isLoggedIn", false);
                      prefs.setString("email", '');
                      prefs.setString("username", '');
                      prefs.setBool("isExpired", false);
                      // context.read<AuthBloc>().add(const Logout());
                      _showSuccessMessage(context, 'Logout Successful');
                      // Navigator.of(context).popUntil((route) => route.isFirst);
                      // Navigator.pushReplacement(
                      //   context,
                      //   PageTransition(
                      //     type: PageTransitionType.fade,
                      //     child: const MainScreen(page: HomePage(), index: 0),
                      //   ),
                      // );
                    },
                  ),
                ],
              ),
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Center(
                  child: Text(versionName),
                ))
          ],
        ));
  }

  void _showSuccessMessage(BuildContext context, String key) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(key), backgroundColor: Colors.green));
    Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
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
          message: const Text('Please Waiting...')),
    );
    showResultDialog(context, result);
    // return result;
  }

  void showResultDialog(
    BuildContext context,
    String result,
  ) {
    // Navigator.pop(context);

    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.fade,
          child: NotificationPage(
            data: notificationList,
            unread: notificationItem,
            notificationID: 0,
          )),
    );
  }
}
