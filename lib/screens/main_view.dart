import 'dart:async';
import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mlcc_app_ios/screens/page/adv/adv_view.dart';
import 'package:mlcc_app_ios/screens/page/entrepreneurs/entrepreneurs_view.dart';
import 'package:mlcc_app_ios/screens/page/events/events_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/screens/page/account/account_view.dart';
import 'package:mlcc_app_ios/screens/page/auth/login_page.dart';
import 'package:mlcc_app_ios/screens/page/favorite/favorite_view.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';

class MainScreen extends StatefulWidget {
  final Widget? page;
  final int? index;
  const MainScreen({Key? key, this.page, this.index}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int pageIndex = widget.index!;
  late int users_id = 0;
  late Timer _timer;
  late StreamController<int> _events;
  String deviceToken = '';
  int _start = 10;
  @override
  void initState() {
    getUser();
    _showPage = widget.page!;

    super.initState();
  }

  void startTimer() {
    _events = StreamController<int>();
    _events.add(10);
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() async {
            timer.cancel();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            // await httpProvider.postHttp("last_access", {
            //   'user_id': prefs.getInt("userId"),
            //   'push_token': "",
            //   'push_token_status': '0'
            // });
            prefs.setInt("userId", 0);
            prefs.setBool("isLoggedIn", false);
            prefs.setString("email", '');
            prefs.setString("username", '');
            prefs.setBool("isExpired", false);
            _showSuccessMessage(context, 'Logout Successful');
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: const MainScreen(page: HomePage(), index: 0),
              ),
            );
          });
        } else {
          setState(() {
            _start--;
          });
        }
        _events.add(_start);
      },
    );
  }

  void _showSuccessMessage(BuildContext context, String key) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(key), backgroundColor: Colors.green));
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    users_id = prefs.getInt("userId")!;
    print(users_id);

    deviceToken = prefs.getString("OneSignalPlayerID") as String;
    // context.read<DashboardBloc>().add(const GetBannerNewsletter());
    Timer(const Duration(milliseconds: 1000), () async {
      if (users_id != 0) {
        var _formData = {"user_id": users_id};
        var getUserDetails =
            await httpProvider.postHttp2("entrepreneur/info", _formData);

        if (getUserDetails != null) {
          var token = getUserDetails[0]['device_token'];
          if (token != deviceToken) {
            // if (announcement == 1) {
            //   Navigator.pop(context);
            // }
            startTimer();
            setState(() {
              showDialog<String>(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                      title: const Text(
                          'Detected other device using this account'),
                      content: StreamBuilder<int>(
                          stream: _events.stream,
                          builder: (BuildContext context,
                              AsyncSnapshot<int> snapshot) {
                            return RichText(
                                text: TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Automatic logout within '),
                                TextSpan(
                                    text: snapshot.data.toString(),
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold)),
                                const TextSpan(text: ' seconds'),
                              ],
                            ));
                            // Text(
                            //                               'Please proceed to logout in this device. Automatic logout within ${snapshot.data.toString()} sec.');
                            // actions: <Widget>[
                            //   TextButton(
                            //     onPressed: () async {},
                            //     child: const Text('OK'),
                            //     style: TextButton.styleFrom(primary: Colors.blue),
                            //   ),
                            // ],
                          })));
            });
          }
        }
      }
    });
  }

  late Widget _showPage;
  // final ProfileScreen _profilepage = new ProfileScreen();
  _pageChoose(int pages) {
    getUser();
    switch (pages) {
      case 0:
        return const HomePage();

      case 1:
        return const EntrepreneursViewPage();

      //case 2:
      //if (users_id == 0 || users_id == null) {
      //return Navigator.push(
      //context,
      //PageTransition(
      //type: PageTransitionType.fade,
      //child: const LoginPage(),
      //),
      //);
      //} else {
      //return const AccountViewPage();
      //}

      //case 2:
      //return const  FavoritePage();

      case 2:
        return const EventsViewPage();

      case 3:
        return AdvPage();

      case 4:
        if (users_id == 0 || users_id == null) {
          return Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: const LoginPage(),
            ),
          );
        } else {
          return const AccountViewPage();
        }
    }
  }

  late DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Warning !'),
        content: const Text('Are you sure you want to leave the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => exit(0),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    return Future.value(true);
  }

  //Future<bool> onWillPop2() {
  // DateTime now = DateTime.now();
  // currentBackPressTime = now;

  // if (currentBackPressTime == null ||
  //     now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
  //   currentBackPressTime = now;

  //   return Future.value(false);
  // }
  // return Future.value(true);

  //}

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: _showPage,
        bottomNavigationBar: CurvedNavigationBar(
          color: kPrimaryColor,
          height: 70.0,
          index: pageIndex,
          backgroundColor: Colors.white,
          items: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home, size: 30, color: kSecondaryColor),
                //SizedBox(height: 4),
                Text(
                  'Home',
                  style: TextStyle(color: kSecondaryColor, fontSize: 9),
                ),
              ],
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.groups, size: 30, color: kSecondaryColor),
                //SizedBox(height: 4), // Optional: Add some space between the icon and text

                Text(
                  'Members',
                  style: TextStyle(color: kSecondaryColor, fontSize: 9),
                ),
              ],
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Icon(Icons.favorite, size: 30, color: kSecondaryColor),
            //     //SizedBox(height: 4),
            //     Text(
            //       'Favorites',
            //       style: TextStyle(color: kSecondaryColor, fontSize: 9),
            //     ),
            //   ],
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 30, color: kSecondaryColor),
                //SizedBox(height: 4),
                Text(
                  'Events',
                  style: TextStyle(color: kSecondaryColor, fontSize: 9),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.card_giftcard, size: 30, color: kSecondaryColor),
                //SizedBox(height: 4),
                Text(
                  'Vouchers',
                  style: TextStyle(color: kSecondaryColor, fontSize: 9),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 30, color: kSecondaryColor),
                //SizedBox(height: 4),
                Text(
                  'User',
                  style: TextStyle(color: kSecondaryColor, fontSize: 9),
                ),
              ],
            ),
          ],
//),
          onTap: (int tapIndex) {
            setState(() {
              _showPage = _pageChoose(tapIndex);
            });
          },
        ),
      ),
    );
  }
}
