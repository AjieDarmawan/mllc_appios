import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:intl/intl.dart';
import 'package:mlcc_app_ios/Bloc/timer/timer_bloc.dart';
import 'package:mlcc_app_ios/screens/page/account/account_personal_basic_info_view.dart';
import 'package:mlcc_app_ios/screens/page/home/popup_detail.dart';
import 'package:mlcc_app_ios/widget/account_list_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:mlcc_app_ios/Bloc/dashboard/dashboard_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/account/account_subcription.dart';
import 'package:mlcc_app_ios/screens/page/account/account_view.dart';
import 'package:mlcc_app_ios/screens/page/account/order_history_view.dart';
import 'package:mlcc_app_ios/screens/page/account/referral_view.dart';
import 'package:mlcc_app_ios/screens/page/adv/adv_view.dart';
import 'package:mlcc_app_ios/screens/page/adv/product.dart';
import 'package:mlcc_app_ios/screens/page/adv/xproject_page.dart';
import 'package:mlcc_app_ios/screens/page/entrepreneurs/entrepreneurs_view.dart';
import 'package:mlcc_app_ios/screens/page/home/connect_list.dart';
import 'package:mlcc_app_ios/screens/page/home/newsletter_list.dart';
import 'package:mlcc_app_ios/screens/page/home/newsletter_view.dart';
import 'package:mlcc_app_ios/screens/page/home/widget/app_category_item.dart';
import 'package:mlcc_app_ios/screens/page/home/widget/app_placeholder.dart';
import 'package:mlcc_app_ios/screens/page/model/model_category.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/screens/page/notification/notification_list.dart';
import 'package:mlcc_app_ios/screens/page/zoom_meeting.dart';
import 'package:mlcc_app_ios/widget/custom_dialog.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';

import 'home_category_item.dart';
import 'home_silver_app_bar.dart';
import 'home_swiper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool isAutoPlayEnabled = true;

  int currentIndex = 0;
  final SwiperController _swiperController = SwiperController();
  final SwiperController _swiperControllerbanner = SwiperController();

  late AnimationController _resizableController;
  bool isLoggedIn = false;
  int userId = 0;
  List<String> banners = [];
  dynamic entrepreneurData = [];
  int count = 0;
  int show = 0;
  int _counter = 0;
  late StreamController<int> _events;
  String deviceToken = '';
  late Widget popup;
  List<Widget> images = [];
  late Timer _timer1;
  int _start = 10;
  var connectList = [];
  dynamic notificationList = [];
  dynamic notificationItem = [];
  int total = 0;
  dynamic notification = [];
  dynamic contactUs = [];
  dynamic refferalList = [];
  dynamic userInfo = [];
  List planList = [];
  Map<String, dynamic> userData = {};

  int slider = 0;
  int slider_tap = 0;

  late StreamSubscription<Map> streamSubscription;
  StreamController<String> controllerData = StreamController<String>();
  StreamController<String> controllerInitSession = StreamController<String>();

  final _maxSeconds = 5;
  int _currentSecond = 0;
  Timer? _timer;

  var slide = false;

  String get _timerText {
    final secondsPerMinute = 60;
    final secondsLeft = _maxSeconds - _currentSecond;

    final formattedMinutesLeft =
        (secondsLeft ~/ secondsPerMinute).toString().padLeft(2, '0');
    final formattedSecondsLeft =
        (secondsLeft % secondsPerMinute).toString().padLeft(1, '0');

    print('$formattedMinutesLeft : $formattedSecondsLeft');
    // return '$formattedMinutesLeft : $formattedSecondsLeft';
    return '$formattedSecondsLeft';
  }

  void _startTimer() {
    final duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        _currentSecond = timer.tick;
        if (timer.tick >= _maxSeconds) timer.cancel();
      });
    });
  }

  // void startTimer() {
  //   _events = StreamController<int>();
  //   _events.add(10);
  //   const oneSec = Duration(seconds: 1);
  //   _timer = Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (_start == 0) {
  //         setState(() async {
  //           timer.cancel();
  //           SharedPreferences prefs = await SharedPreferences.getInstance();
  //           await httpProvider.postHttp("last_access", {
  //             'user_id': prefs.getInt("userId"),
  //             'push_token': "",
  //             'push_token_status': '0'
  //           });
  //           prefs.setInt("userId", 0);
  //           prefs.setBool("isLoggedIn", false);
  //           prefs.setString("email", '');
  //           prefs.setString("username", '');
  //           prefs.setBool("isExpired", false);
  //           _showSuccessMessage(context, 'Logout Successful');
  //           Navigator.of(context).popUntil((route) => route.isFirst);
  //           Navigator.pushReplacement(
  //             context,
  //             PageTransition(
  //               type: PageTransitionType.fade,
  //               child: const MainScreen(page: HomePage(), index: 0),
  //             ),
  //           );
  //         });
  //       } else {
  //         setState(() {
  //           _start--;
  //         });
  //       }
  //       _events.add(_start);
  //     },
  //   );
  // }

  Future<void> getPlan() async {
    planList = await httpProvider.getHttp("member_package");
  }

  void getUser() async {
    print("userIDGetUser");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() async {
      userId = prefs.getInt("userId")!;
      if (userId != 0) {
        print("userID${userId}");
        print(userId);
        getRequestConnect(userId);
        context.read<DashboardBloc>().add(GetBannerNewsletter(userId));
      } else {}
      isLoggedIn = prefs.getBool("isLoggedIn")!;
      deviceToken = prefs.getString("OneSignalPlayerID") as String;
      // context.read<DashboardBloc>().add(const GetBannerNewsletter());
      // if (userId != 0) {
      //   var getUserDetails =
      //       await httpProvider.postHttp("member/info", {'user_id': userId});
      //   if (getUserDetails != null) {
      //     var token = getUserDetails[0]['device_token'];
      //     if (token != deviceToken) {
      //       // if (announcement == 1) {
      //       //   Navigator.pop(context);
      //       // }
      //       startTimer();
      //       setState(() {
      //         showDialog<String>(
      //             barrierDismissible: false,
      //             context: context,
      //             builder: (BuildContext context) => AlertDialog(
      //                 title: const Text(
      //                     'Detected other device using this account'),
      //                 content: StreamBuilder<int>(
      //                     stream: _events.stream,
      //                     builder: (BuildContext context,
      //                         AsyncSnapshot<int> snapshot) {
      //                       return RichText(
      //                           text: TextSpan(
      //                         // Note: Styles for TextSpans must be explicitly defined.
      //                         // Child text spans will inherit styles from parent
      //                         style: const TextStyle(
      //                           fontSize: 12.0,
      //                           color: Colors.black,
      //                         ),
      //                         children: <TextSpan>[
      //                           const TextSpan(
      //                               text: 'Automatic logout within '),
      //                           TextSpan(
      //                               text: snapshot.data.toString(),
      //                               style: const TextStyle(
      //                                   fontSize: 15.0,
      //                                   fontWeight: FontWeight.bold)),
      //                           const TextSpan(text: ' seconds'),
      //                         ],
      //                       ));
      //                       // Text(
      //                       //                               'Please proceed to logout in this device. Automatic logout within ${snapshot.data.toString()} sec.');
      //                       // actions: <Widget>[
      //                       //   TextButton(
      //                       //     onPressed: () async {},
      //                       //     child: const Text('OK'),
      //                       //     style: TextButton.styleFrom(primary: Colors.blue),
      //                       //   ),
      //                       // ],
      //                     })));
      //       });
      //     }
      //   }
      // }
    });
  }

  void _showSuccessMessage(BuildContext context, String key) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(key), backgroundColor: Colors.green));
  }

  void getBanner() async {
    HttpProvider httpProvider = HttpProvider();
    List bannerDataReturn = await httpProvider.getHttp('banner');
    print(bannerDataReturn);
    for (var element in bannerDataReturn) {
      print("Banner");
      print(element);
      setState(() {
        banners.add(link + element);
      });
    }
  }

  // void getEntrepreneursList() async {
  //   setState(() async {
  //     entrepreneurData = await httpProvider
  //         .getHttp2('https://memberAPI.xclubmy.com/api/entrepreneur/listing');
  //   });
  // }

  void getRequestConnect(id) async {
    final _formData = {};
    _formData['user_id'] = userId;
    int total_referral = 0;
    int total_request = 0;
    total = 0;
    notification =
        await httpProvider.postHttp("notification/listing", _formData);
    setState(() {
      if (notification.isNotEmpty) {
        for (var item in notification) {
          if (item['type'] != 'Entrepreneurs') {
            if (item['status'] == 0) {
              notificationItem.add(item);
              total++;
            }
            notificationList.add(item);
          }
        }
        handleClickNotification(context);
      }
    });
    var userdatadetail =
        await httpProvider.postHttp2("entrepreneur/info", _formData);

    print("cehckuseruserData${userdatadetail}");
    refferalList = await httpProvider.postHttp2(
        "entrepreneur/referral/listing", _formData);
    if (refferalList.isNotEmpty) {
      setState(() {
        total_referral = refferalList['pending_count'];
      });
    }
    connectList =
        await httpProvider.postHttp2("entrepreneur/connect/listing", _formData);
    setState(() {
      if (connectList.isNotEmpty) {
        total_request = connectList[0]['pending_request'];
      }
    });

    total = total + total_request + total_referral;

    // var profile =
    //     await httpProvider.postHttp2("entrepreneur/check_profile", _formData);

    var profile = await httpProvider.postHttp2(
        "entrepreneur/check_profile/incomplete", _formData);

    // print("profile-profile${profile['status']}");
    // if (profile.isNotEmpty) {
    //   if (profile['status'] == 'False') {
    //     // if (notices == 0) {
    //     setState(() {
    //       showDialog<String>(
    //           context: context,
    //           builder: (BuildContext context) => AlertDialog(
    //                 title: const Text('Notices'),
    //                 content: SizedBox(
    //                   width: double.maxFinite,
    //                   child: ListView(
    //                     shrinkWrap: true, // <-- Set this to true
    //                     children: [
    //                       Text('Update Your Profile'),
    //                       SizedBox(height: 12),
    //                       Text(
    //                           'Hi there! We ve noticed some important details are missing from your profile:'),
    //                       if (profile['introduction'] == 'Incomplete')
    //                         TextButton(
    //                           onPressed: () {
    //                             Navigator.pushNamed(context,
    //                                 '/account_personal_basic_info_view_page',
    //                                 arguments: {
    //                                   'data': userdatadetail[0],
    //                                   'disableEdit': false
    //                                 });
    //                           },
    //                           child: const Text('Introduction Incomplete'),
    //                           style: TextButton.styleFrom(primary: Colors.red),
    //                         ),
    //                       if (profile['profile_image'] == 'Incomplete')
    //                         TextButton(
    //                           onPressed: () {
    //                             Navigator.pushNamed(context,
    //                                 '/account_personal_basic_info_view_page',
    //                                 arguments: {
    //                                   'data': userdatadetail[0],
    //                                   'disableEdit': false
    //                                 });
    //                           },
    //                           child: const Text('Profile image Incomplete'),
    //                           style: TextButton.styleFrom(primary: Colors.red),
    //                         ),
    //                       if (profile['social_media'] == 'Incomplete')
    //                         TextButton(
    //                           onPressed: () {
    //                             Navigator.push(
    //                                 context,
    //                                 MaterialPageRoute(
    //                                     builder: (context) => AccountListWidgetPage(
    //                                         disableEdit: false,
    //                                         navigateToEditPageRoute:
    //                                             "/account_social_media_view_page",
    //                                         label: "Social Media")));
    //                           },
    //                           child: const Text('Social media  Incomplete'),
    //                           style: TextButton.styleFrom(primary: Colors.red),
    //                         ),
    //                       if (profile['education'] == 'Incomplete')
    //                         TextButton(
    //                           onPressed: () {
    //                             Navigator.push(
    //                                 context,
    //                                 MaterialPageRoute(
    //                                     builder: (context) =>
    //                                         AccountListWidgetPage(
    //                                             disableEdit: false,
    //                                             navigateToEditPageRoute:
    //                                                 "/account_education_view_page",
    //                                             label: "Education")));
    //                           },
    //                           child: const Text('Education  Incomplete'),
    //                           style: TextButton.styleFrom(primary: Colors.red),
    //                         ),
    //                       if (profile['society'] == 'Incomplete')
    //                         TextButton(
    //                           onPressed: () {
    //                             Navigator.push(
    //                                 context,
    //                                 MaterialPageRoute(
    //                                     builder: (context) =>
    //                                         AccountListWidgetPage(
    //                                             disableEdit: false,
    //                                             navigateToEditPageRoute:
    //                                                 "/account_societies_view_page",
    //                                             label: "Social Media")));
    //                           },
    //                           child: const Text('Society  Incomplete'),
    //                           style: TextButton.styleFrom(primary: Colors.red),
    //                         ),
    //                       if (profile['certificate'] == 'Incomplete')
    //                         TextButton(
    //                           onPressed: () {
    //                             Navigator.push(
    //                                 context,
    //                                 MaterialPageRoute(
    //                                     builder: (context) => AccountListWidgetPage(
    //                                         disableEdit: false,
    //                                         navigateToEditPageRoute:
    //                                             "/account_professional_cert_view_page",
    //                                         label:
    //                                             "Professional Cert & Rewards")));
    //                           },
    //                           child: const Text('Certificate Incomplete'),
    //                           style: TextButton.styleFrom(primary: Colors.red),
    //                         ),
    //                       if (profile['company'] == 'Incomplete')
    //                         TextButton(
    //                           onPressed: () {
    //                             Navigator.pushNamed(
    //                                 context, '/account_company_info_view_page',
    //                                 arguments: {
    //                                   'data': userdatadetail[0]
    //                                       ['company_details'],
    //                                   'disable': false
    //                                 });
    //                           },
    //                           child: const Text('company Incomplete'),
    //                           style: TextButton.styleFrom(primary: Colors.red),
    //                         ),
    //                       if (profile['company_establish_year'] == 'Incomplete')
    //                         TextButton(
    //                           onPressed: () {
    //                             Navigator.pushNamed(
    //                                 context, '/account_company_info_view_page',
    //                                 arguments: {
    //                                   'data': userdatadetail[0]
    //                                       ['company_details'],
    //                                   'disable': false
    //                                 });
    //                           },
    //                           child: const Text(
    //                               'Company establish year Incomplete'),
    //                           style: TextButton.styleFrom(primary: Colors.red),
    //                         ),
    //                       if (profile['company_state'] == 'Incomplete')
    //                         TextButton(
    //                           onPressed: () {
    //                             Navigator.pushNamed(
    //                                 context, '/account_company_info_view_page',
    //                                 arguments: {
    //                                   'data': userdatadetail[0]
    //                                       ['company_details'],
    //                                   'disable': false
    //                                 });
    //                           },
    //                           child: const Text('Company state Incomplete'),
    //                           style: TextButton.styleFrom(primary: Colors.red),
    //                         ),
    //                       if (profile['company_address'] == 'Incomplete')
    //                         TextButton(
    //                           onPressed: () {
    //                             Navigator.pushNamed(
    //                                 context, '/account_company_info_view_page',
    //                                 arguments: {
    //                                   'data': userdatadetail[0]
    //                                       ['company_details'],
    //                                   'disable': false
    //                                 });
    //                           },
    //                           child: const Text('Company address Incomplete'),
    //                           style: TextButton.styleFrom(primary: Colors.red),
    //                         ),
    //                       if (profile['company_postcode'] == 'Incomplete')
    //                         TextButton(
    //                           onPressed: () {
    //                             Navigator.pushNamed(
    //                                 context, '/account_company_info_view_page',
    //                                 arguments: {
    //                                   'data': userdatadetail[0]
    //                                       ['company_details'],
    //                                   'disable': false
    //                                 });
    //                           },
    //                           child: const Text('Company postcode Incomplete'),
    //                           style: TextButton.styleFrom(primary: Colors.red),
    //                         ),
    //                       if (profile['company_city'] == 'Incomplete')
    //                         TextButton(
    //                           onPressed: () {
    //                             Navigator.pushNamed(
    //                                 context, '/account_company_info_view_page',
    //                                 arguments: {
    //                                   'data': userdatadetail[0]
    //                                       ['company_details'],
    //                                   'disable': false
    //                                 });
    //                           },
    //                           child: const Text('Company city Incomplete'),
    //                           style: TextButton.styleFrom(primary: Colors.red),
    //                         ),
    //                       if (profile['company_country'] == 'Incomplete')
    //                         TextButton(
    //                           onPressed: () {
    //                             Navigator.pushNamed(
    //                                 context, '/account_company_info_view_page',
    //                                 arguments: {
    //                                   'data': userdatadetail[0]
    //                                       ['company_details'],
    //                                   'disable': false
    //                                 });
    //                           },
    //                           child: const Text('Company country Incomplete'),
    //                           style: TextButton.styleFrom(primary: Colors.red),
    //                         ),
    //                       if (profile['change_password'] == 'Incomplete')
    //                         TextButton(
    //                           onPressed: () {
    //                             Navigator.pushNamed(context,
    //                                 '/account_personal_basic_info_view_page',
    //                                 arguments: {
    //                                   'data': userdatadetail[0],
    //                                   'disableEdit': false
    //                                 });
    //                           },
    //                           child: const Text('Change Password Incomplete'),
    //                           style: TextButton.styleFrom(primary: Colors.red),
    //                         ),
    //                     ],
    //                   ),
    //                 ),
    //               ));
    //     });

    //     notices++;
    //     // }
    //   }
    // }
    userInfo = await httpProvider.postHttp2("entrepreneur/info", _formData);
    if (userInfo.isNotEmpty) {
      setState(() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("memberNo", userInfo[0]['member_number']);
        var now = DateTime.now();
        var formatter = DateFormat('yyyy-MM-dd');
        var currentDate = formatter.format(now);
        late bool valDate;
        DateTime parseDate =
            DateFormat("yyyy-MM-dd").parse(userInfo[0]['expired_date']);
        var endDate = formatter.format(parseDate);

        valDate = now.isBefore(parseDate);
        if (currentDate == endDate) {
          valDate = true;
        }
        if (valDate == false) {
          // need hide because now not used
          // prefs.setBool("isExpired", true);
          // showDialog<String>(
          //     context: context,
          //     builder: (BuildContext context) => AlertDialog(
          //           title: const Text('Notices'),
          //           content: const Text(
          //               'Membership period is expired. \nPlease make a payment to renew.'),
          //           actions: <Widget>[
          //             TextButton(
          //               onPressed: () {
          //                 Navigator.pop(context);
          //               },
          //               child: const Text('Cancel'),
          //               style: TextButton.styleFrom(primary: Colors.black),
          //             ),
          //             TextButton(
          //               onPressed: () {
          //                 Navigator.pop(context);
          //                 Navigator.pushNamed(context, '/payment_webview_page',
          //                     arguments: {
          //                       'userId': userId,
          //                       'training': 0,
          //                       'event': 0,
          //                       'product': 0,
          //                     });
          //               },
          //               child: const Text('Pay'),
          //               style: TextButton.styleFrom(primary: Colors.blue),
          //             ),
          //           ],
          //         ));
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("isExpired", false);
        }
      });
    }
  }

  getContactUsInfo() async {
    setState(() async {
      contactUs = await httpProvider.getHttp("aboutUs");
    });
  }

  _getCloseButton(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          alignment: FractionalOffset.topRight,
          child: GestureDetector(
            child: Icon(
              Icons.clear,
              color: Colors.red,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  // @override
  // void didChangeDependencies() {
  //   print('didChangeDependencies');
  //   print(Theme.of(context)); // OK
  //   super.didChangeDependencies();

  //   WidgetsBinding.instance?.addPostFrameCallback((_) async {
  //     await showDialog<String>(
  //         context: context,
  //         builder: (BuildContext builderContext) {
  //           // _timer = Timer(Duration(seconds: 5), () {
  //           //   Navigator.of(context).pop();
  //           // });

  //           return AlertDialog(
  //               backgroundColor: Colors.white,
  //               //shape: _defaultShape(),
  //               insetPadding: EdgeInsets.all(8),
  //               elevation: 10,
  //               titlePadding: const EdgeInsets.all(0.0),
  //               title: Container(
  //                   child: Center(
  //                       child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: <Widget>[
  //                     _getCloseButton(context),
  //                     Padding(
  //                       padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
  //                       child: Column(
  //                         children: <Widget>[
  //                           Icon(
  //                             Icons.warning_amber_sharp,
  //                             size: 48,
  //                           ),
  //                           SizedBox(
  //                             height: 15,
  //                           ),
  //                           Text(
  //                             "Alert with Close Button",
  //                             style: TextStyle(
  //                                 color: Colors.black,
  //                                 fontWeight: FontWeight.w500,
  //                                 fontStyle: FontStyle.normal),
  //                             textAlign: TextAlign.center,
  //                           ),
  //                           SizedBox(
  //                             height: 10,
  //                           ),
  //                           Text(
  //                             "Your Subscription Plan Expiered",
  //                             style: TextStyle(
  //                                 color: Colors.black,
  //                                 fontWeight: FontWeight.w400,
  //                                 fontStyle: FontStyle.normal),
  //                             textAlign: TextAlign.center,
  //                           ),
  //                           SizedBox(
  //                             height: 20,
  //                           ),
  //                         ],
  //                       ),
  //                     )
  //                   ]))));
  //           ;
  //         }).then((val) {
  //       if (_timer.isActive) {
  //         _timer.cancel();
  //       }
  //     });
  //   });
  // }

  @override
  void initState() {
    // _getLink();
    getUser();
    getBanner();
    context.read<DashboardBloc>().add(GetBannerNewsletter(userId));
    getContactUsInfo();
    // getEntrepreneursList();
    getPopUpAnnouncement();
    // _showAnnouncement();
    getPlan();

    // _showAnnouncement_slider();

    _resizableController = AnimationController(
      duration: const Duration(
        milliseconds: 500,
      ),
      vsync: this,
    );
    _resizableController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _resizableController.forward();
    var state = context.read<AuthBloc>().state;
    if (state is GetUserDetailsSuccessful) userData = state.userData[0];
    listenDynamicLinks();
    super.initState();
  }

  getPopUpAnnouncement() async {
    var getPopUpAnnouncementReturn = await httpProvider.getHttp("popup");

    print("getPopUpAnnouncementReturn${getPopUpAnnouncementReturn.length}");
    if (getPopUpAnnouncementReturn != null) {
      int n = 0;
      for (int i = 0; i < getPopUpAnnouncementReturn.length; i++) {
        popup = getPopUpAnnouncementReturn[i]['title'];

        setState(() {
          images.add(popup);
        });
      }
    }
  }

  _showAnnouncement() async {
    var getPopUpAnnouncementReturn = await httpProvider.getHttp("popup");

    context.read<TimerBloc>().add(const TimerStarted(5));

    if (getPopUpAnnouncementReturn.isNotEmpty) {
      // print("getPopUpAnnouncementReturn${getPopUpAnnouncementReturn.length}");
      // var a = '1';
      int images_length = 1;
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          //a = '2';
          images_length = 2;
        });
        print("yayates${images_length}");
      });
      print("yaya${images_length}");

      await showAnimatedDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return GestureDetector(
            onLongPress: () {
              _swiperController.stopAutoplay();
              print("testes Loong");
              // var snackBar = SnackBar(content: Text('testes Loong'));
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            onLongPressEnd: (_) => setState(() {
              // var snackBar = SnackBar(content: Text('testes Loong finish'));
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
              _swiperController.startAutoplay();
            }),
            onTapDown: (details) {
              _swiperController.stopAutoplay();
              print("testes Someone is touchin' me !!");
              //  var snackBar = SnackBar(content: Text('testes Loong'));
              //ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            onTapUp: (details) {
              print("testes I relaxed, oh.");
            },
            child: Swiper(
              controller: _swiperController,

              onTap: (int i) {
                print("testes_tap${i}");
                _swiperController.stopAutoplay();

                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: Popup_detail(
                      img: getPopUpAnnouncementReturn[i]['thumbnail'],
                      title: getPopUpAnnouncementReturn[i]['title'],
                      caption: getPopUpAnnouncementReturn[i]['caption'],
                      descriptions: getPopUpAnnouncementReturn[i]
                          ['description'],
                      type: getPopUpAnnouncementReturn[i]['type'],
                      url_link: getPopUpAnnouncementReturn[i]['url_link'],
                      tel_number: getPopUpAnnouncementReturn[i]['tel_number'],
                      email_address: getPopUpAnnouncementReturn[i]
                          ['email_address'],
                    ),
                  ),
                );
              },
              onIndexChanged: (int index) {
                setState(() {
                  slider += slider + 1;
                  //_swiperController.stopAutoplay();
                  if (images_length == 1) {
                    _swiperController.move(0);
                  }
                  // _swiperController.move(0);
                });
                print("testes${slider}");
              },

              //loop: getPopUpAnnouncementReturn.length == 1 ? false : true,

              loop: false,
              itemBuilder: (BuildContext context, int i) {
                return CustomDialogBox(
                    title: getPopUpAnnouncementReturn[i]['title'],
                    caption: getPopUpAnnouncementReturn[i]['caption'],
                    descriptions: getPopUpAnnouncementReturn[i]['description'],
                    type: getPopUpAnnouncementReturn[i]['type'],
                    sub_background_color: getPopUpAnnouncementReturn[i]
                        ['sub_background_color'],
                    background_color: getPopUpAnnouncementReturn[i]
                        ['background_color'],
                    sub_title: getPopUpAnnouncementReturn[i]['sub_title'],
                    color_title: getPopUpAnnouncementReturn[i]['color_title'],
                    color_subtitle: getPopUpAnnouncementReturn[i]
                        ['color_subtitle'],
                    color_caption: getPopUpAnnouncementReturn[i]
                        ['color_caption'],
                    gradient_background_color: getPopUpAnnouncementReturn[i]
                        ['gradient_background_color'],
                    no: i,
                    total_no: images_length,
                    total_no_: slider,
                    slider: false,
                    slide_close: false,
                    url_link: getPopUpAnnouncementReturn[i]['url_link'],
                    tel_number: getPopUpAnnouncementReturn[i]['tel_number'],
                    email_address: getPopUpAnnouncementReturn[i]
                        ['email_address'],
                    img: getPopUpAnnouncementReturn[i]['thumbnail']);

                //return Text(_timerText);

                // return Text('${context.select((TimerBloc bloc) => bloc.state)}',
                //     textAlign: TextAlign.center,
                //     style: const TextStyle(
                //         color: Colors.white,
                //         fontSize: 22,
                //         fontWeight: FontWeight.w600));
              },

              // autoplayDelay: 8000,
              // autoplay: isAutoPlayEnabled,
              autoplayDisableOnInteraction: true,
              // itemCount: getPopUpAnnouncementReturn.length,
              itemCount: 1,

              pagination: const SwiperPagination(
                alignment: Alignment(0.0, 0.85),
                // alignment: Alignment.bottomCenter,
                builder: DotSwiperPaginationBuilder(
                    color: Colors.grey, activeColor: kThirdColor),
              ),
            ),
          );
        },
        // animationType: DialogTransitionType.scaleRotate,
        curve: Curves.fastOutSlowIn,
        duration: const Duration(seconds: 3),
      );

      var disable = false;
      // _startTimer();

    }
  }

  @override
  void dispose() {
    _resizableController.dispose();
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Timer(const Duration(milliseconds: 600), () {

    // });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0), // Set the desired height here
        child: AppBar(
          leading: Container(),
          title: SizedBox(
            height: 60,
            child: Image.asset('assets/mlcc_logo.png'),
          ),
          centerTitle: true,
          backgroundColor: kSecondaryColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/contact_us_view_page',
                      arguments: {'data': contactUs});
                },
                icon: Icon(Icons.ac_unit)),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.0), // Adjust the height as needed
            child: Divider(
              color: Color.fromARGB(
                  255, 113, 98, 4), // Set the color of the line here
              thickness: 5.0, // Adjust the thickness of the line as needed
            ),
          ),
        ),
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (BuildContext context, DashboardState state) {
        if (state is GetBannerNewsletterSuccessful) {
          return _buildContent(state.bannerNewsletters);
        } else {
          return const LoadingWidget();
        }
      }),
    );
  }

  _showPicker(context) {
    final size = MediaQuery.of(context).size;
    showBarModalBottomSheet(
      // expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Wrap(
        children: <Widget>[
          if (connectList.isNotEmpty)
            if (connectList[0]['pending_request'] > 0)
              ListTile(
                  leading: const Icon(
                    Icons.people,
                    color: kPrimaryColor,
                    size: 30,
                  ),
                  title: Text(
                      'Pending Requests ( ${connectList[0]['pending_request']} )'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child:
                              RequestListPage(userId: userId, resquestID: 0)),
                    );
                  }),
          if (refferalList.isNotEmpty)
            if (refferalList['pending_count'] > 0)
              ListTile(
                  leading: const Icon(
                    Icons.people,
                    color: kPrimaryColor,
                    size: 30,
                  ),
                  title: Text(
                      'Referral Requests ( ${refferalList['pending_count']} )'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: ReferralRequestListPage(
                            userID: userId,
                            referralID: 0,
                          )),
                    );
                  }),
          if (notificationItem.isNotEmpty)
            if (notificationItem.length as int > 0)
              ListTile(
                leading: const Icon(
                  Icons.notifications,
                  color: kPrimaryColor,
                  size: 30,
                ),
                title: Text('Notifications ( ${notificationItem.length} )'),
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: NotificationPage(
                            data: notificationList,
                            unread: notificationItem,
                            notificationID: 0)),
                  );
                },
              ),
        ],
      ),
    );
  }

  handleClickNotification(BuildContext context) {
    OneSignal.Notifications.addClickListener((openedResult) async {
      print(openedResult);

      Map<String, dynamic> result =
          openedResult.notification.additionalData as Map<String, dynamic>;
      var id = result.values.first;
      var type = result.values.last;
      if (type == 'request') {
        Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: RequestListPage(userId: userId, resquestID: id)),
        );
      } else if (type == 'referral') {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: ReferralRequestListPage(
                  userID: userId,
                  referralID: id,
                )));
      } else if (type == 'order') {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: OrderHistoryListPage(
                  userID: userId,
                  orderID: id,
                )));
      } else if (type == 'Training') {
        Navigator.pushNamed(context, '/training_details_view_page',
            arguments: {'data': id, 'type': 'Notification'});
      } else if (type == 'Event') {
        Navigator.pushNamed(context, '/event_details_view_page',
            arguments: {'data': id, 'type': 'Notification'});
      } else if (type == 'Voucher') {
        Navigator.pushNamed(context, '/voucher_details_view_page',
            arguments: {'data': id, 'type': 'Notification'});
      } else if (type == 'Rewards') {
        Navigator.pushNamed(context, '/reward_details_view_page',
            arguments: {'data': id, 'type': 'Notification'});
      } else if (type == 'Product') {
        Navigator.pushNamed(context, '/product_details_view_page',
            arguments: {'data': id, 'type': 'Notification'});
      } else if (type == 'Profile') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.getBool("isLoggedIn")! == true) {
          userInfo = await httpProvider.postHttp2(
              "entrepreneur/info", {'user_id': prefs.getInt("userId")!});
          Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child:
                    SubsciptionPlanPage(data: userInfo[0], planList: planList)),
          );
        }
      } else {
        // Navigator.push(
        //   context,
        //   PageTransition(
        //       type: PageTransitionType.fade,
        //       child: NotificationPage(
        //           data: notificationList,
        //           unread: notificationItem,
        //           notificationID: id)),
        // );
        getNewsLetterInfo(id);
      }
    });
  }

  void listenDynamicLinks() {
    streamSubscription = FlutterBranchSdk.initSession().listen((data) async {
      print('listenDynamicLinks - DeepLink Data: $data');
      controllerData.sink.add((data.toString()));
      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        print(data);

        if (data['type'] == 'Training') {
          Navigator.pushNamed(context, '/training_details_view_page',
              arguments: {'data': data['dataID'], 'type': 'Notification'});
        } else if (data['type'] == 'Event') {
          Navigator.pushNamed(context, '/event_details_view_page',
              arguments: {'data': data['dataID'], 'type': 'Notification'});
        } else if (data['type'] == 'Product') {
          Navigator.pushNamed(context, '/product_details_view_page',
              arguments: {'data': data['dataID'], 'type': 'Notification'});
        }
        // else if (data['type'] == 'Advertisement' ||
        //     data['type'] == 'Newsletter') {
        //   getNewsLetterInfo(data['dataID']);
        // }
        else if (data['type'] == 'Newsletter') {
          getNewsLetterInfo(data['dataID']);
        } else if (data['type'] == 'Advertisement') {
          if (data['sub_type'] == 'Voucher') {
            Navigator.pushNamed(context, '/voucher_details_view_page',
                arguments: {'data': data['dataID'], 'type': 'Notification'});
          } else {
            Navigator.pushNamed(context, '/reward_details_view_page',
                arguments: {'data': data['dataID'], 'type': 'Notification'});
          }
        } else if (data['type'] == 'Profile') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (prefs.getBool("isLoggedIn")! == true) {
            userInfo = await httpProvider.postHttp2(
                "entrepreneur/info", {'user_id': prefs.getInt("userId")!});
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: SubsciptionPlanPage(
                      data: userInfo[0], planList: planList)),
            );
          }
        }
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      print(
          'InitSession error: ${platformException.code} - ${platformException.message}');
      controllerInitSession.add(
          'InitSession error: ${platformException.code} - ${platformException.message}');
    });
  }

  var newLetter;
  getNewsLetterInfo(id) async {
    var _formData = {'news_id': id};
    newLetter = await httpProvider.postHttp("newsletter/info", _formData);
    if (newLetter != null) {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: NewsLetterViewPage(data: newLetter),
        ),
      );
    }
  }

  Widget _buildContent(bannerNewsletters) {
    dynamic banners = bannerNewsletters['banner'];
    dynamic newsletters = bannerNewsletters['newsletter'];

    if (newsletters.length > 3) {
      count = 10;
    } else {
      count = newsletters.length;
    }

    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
          height: 300,
          child: GestureDetector(
            onLongPress: () {
              _swiperControllerbanner.stopAutoplay();
              print("Banner testes Loong");
              // var snackBar = SnackBar(content: Text('Banner Loong'));
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            onLongPressEnd: (_) => setState(() {
              // var snackBar = SnackBar(content: Text('Banner Loong finish'));
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
              _swiperControllerbanner.startAutoplay();
            }),
            onTapDown: (details) {
              _swiperControllerbanner.stopAutoplay();
              print("Banner Someone is touchin' me !!");
              //  var snackBar = SnackBar(content: Text('testes Loong'));
              //ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            onTapUp: (details) {
              print("Banner I relaxed, oh.");
            },
            child: HomeSwipe(
              images: banners,
              swiperControllerbanner_: _swiperControllerbanner,
              height: MediaQuery.of(context).size.height * 0.30,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Newsletter",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      height: 1.4)),
              InkWell(
                onTap: () {
                  // Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: NewsLetterListPage(data: newsletters),
                    ),
                  );
                },
                child: Text("View More >>",
                    style: TextStyle(
                        fontSize: 10.0, height: 1.4, color: kThirdColor)),
              )
            ],
          ),
        ),
        Container(
          //live
          //height: MediaQuery.of(context).size.height * 3.27,
          height: MediaQuery.of(context).size.height * 3.49,
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: count,
              itemBuilder: (BuildContext context, int index) {
                return _buildNewslettersList(newsletters[index]);
              }),
        ),
      ],
    ));
  }

  ///Build category UI
  //Widget _buildCategory() {
  ///Loading
  //Widget content = Wrap(
  //runSpacing: 8,
  //alignment: WrapAlignment.center,
  //children: List.generate(4, (index) => index).map(
  //(item) {
  //return const HomeCategoryItem();
  // },
  //).toList(),
  //);

  // if (category != null) {
  // List<CategoryModel> listBuild = category;
//    List<CategoryModel> listBuild = [];
//    final entrepreneur = CategoryModel.fromJson({
//      "term_id": 1,
//      "name": "Members",
//      "icon": "fas fa-users",
//      "color": "#14275f",
//    });
//    final sharing = CategoryModel.fromJson({
//    "term_id": 2,
//      "name": "Sharing",
//      "name": "Trainings",
//      "icon": "fas fa-book-open",
//      "color": "#14275f",
//    });
//    final activities = CategoryModel.fromJson({
//      "term_id": 3,
  // "name": "Activities",
//      "name": "Events",
//      "icon": "far fa-calendar-alt",
//      "color": "#14275f",
//    });
//    final advZone = CategoryModel.fromJson({
//      "term_id": 4,
//      "name": "Adv Zone",
//      "icon": "fas fa-bullhorn",
//      "color": "#14275f",
//    });
  // final xbuy = CategoryModel.fromJson({
  //   "term_id": 5,
  //   "name": "X Buy",
  //   "icon": "fas fa-shopping-cart",
  //   "color": "#14275f",
  // });
  //final xbuy = CategoryModel.fromJson({
  //"term_id": 5,
  //"name": "X Project",
  //"icon": "fas fa-shopping-cart",
  //"color": "#14275f",
  //});
//    listBuild.add(entrepreneur);
  //listBuild.add(sharing);
//    listBuild.add(activities);
//    listBuild.add(advZone);
  //listBuild.add(xbuy);

  //content = Wrap(
  //runSpacing: 8,
  //alignment: WrapAlignment.center,
  //children: listBuild.map(
  //(item) {
  //return HomeCategoryItem(
  //item: item,
  //onPressed: (item) {
  //if (item.id == 1) {
  // Navigator.pushNamed(context, '/entrepreneurs_view_page');
  //} else if (item.id == 2) {
  //Navigator.pushNamed(context, '/trainers_view_page');
  //} else if (item.id == 3) {
  //Navigator.pushNamed(context, '/events_view_page');
  //} else if (item.id == 4) {
  // Navigator.pushNamed(context, '/adv_view_page');
  //Navigator.push(
  //context,
  //PageTransition(
  //  type: PageTransitionType.fade, child: AdvPage()),
  //);
  // } else if (item.id == 5) {
  // Navigator.pushNamed(context, '/adv_view_page');
  // Navigator.push(
  //   context,
  //   PageTransition(
  //       type: PageTransitionType.fade, child: XBuyPage()),
  // );
  //Navigator.push(
  //context,
  // PageTransition(
  //   type: PageTransitionType.fade, child: const XProjectPage()),
  // );
  //}
  //},
  //);
  // },
  //).toList(),
  //);
  // }

  //return Container(
  //padding: const EdgeInsets.all(8),
  //child: content,
  //);
  //}

  Widget _buildNewletter(newsletters) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Newsletter",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      height: 1.4)),
              InkWell(
                onTap: () {
                  // Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: NewsLetterListPage(data: newsletters),
                    ),
                  );
                },
                child: const Text("View More >>",
                    style: TextStyle(
                        fontSize: 10.0, height: 1.4, color: kThirdColor)),
              )
            ],
          ),
        ),
        Container(
          // margin: const EdgeInsets.symmetric(vertical: 20.0),
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          // height: MediaQuery.of(context).size.height * 0.45,
          child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(), //
              //physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: count,
              itemBuilder: (BuildContext context, int index) {
                return _buildNewslettersList(newsletters[index]);
              }),
        ),
      ],
    );
  }

  Widget _buildNewslettersList(dynamic newsletter) {
    print('newsannouncement${announcement}');
    show++;
    print('newsshow${show}');
    print('newsimages${images}');
    print('newsnewsletter${newsletter.length}');
    // if (images.isNotEmpty) {
    if (show == 1) {
      if (announcement == 0) {
        WidgetsBinding.instance!
            .addPostFrameCallback((_) => _showAnnouncement());
        announcement++;
      }
      // }
    }
    return InkWell(
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 180.0,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Center(
            //     child: Image.network(
            //   newsletter['thumbnail'],
            //   fit: BoxFit.values[0],
            //   height: MediaQuery.of(context).size.height * 0.27,
            //   width: MediaQuery.of(context).size.width * 0.90,
            // )),
            Container(
              height: MediaQuery.of(context).size.height * 0.27,
              width: MediaQuery.of(context).size.width * 0.90,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(newsletter['thumbnail']),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Text(
                newsletter['title'],
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: Divider(color: Colors.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Column(children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 10, right: 10.0, top: 5, bottom: 5),
                          child: Icon(
                            Icons.calendar_today,
                            color: kThirdColor,
                            size: 11,
                          ),
                        ),
                        Text(
                          newsletter['publish_at'],
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ]),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Column(children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 10, right: 10.0, top: 5, bottom: 5),
                          child: Icon(
                            Icons.person,
                            color: kThirdColor,
                            size: 11,
                          ),
                        ),
                        Text(
                          "By ${newsletter['created_by']}",
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: NewsLetterViewPage(data: newsletter),
          ),
        );
      },
    );
  }

  Future getFuture() {
    return Future(() async {
      await Future.delayed(const Duration(seconds: 5));
      return 'Submit Successfully!';
    });
  }

  Future<void> showProgress(BuildContext context, id) async {
    var result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(getFuture(),
          message: const Text('Please Waiting...')),
    );
    showResultDialog(context, result, id);
    // return result;
  }

  void showResultDialog(
    BuildContext context,
    String result,
    int id,
  ) {
    // Navigator.pop(context)

    Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.fade,
          child: NotificationPage(
              data: notificationList,
              unread: notificationItem,
              notificationID: id)),
    );
  }
}
