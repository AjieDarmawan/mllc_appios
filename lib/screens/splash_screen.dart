import 'dart:async';
import 'dart:io';
import 'package:page_transition/page_transition.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/constant.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // AudioPlayer advancedPlayer = AudioPlayer();
  // AudioCache audioCache = AudioCache();

  @override
  void initState() {
    // rememberLogin();
    startTime();
    super.initState();
  }

  playLocal() async {}

  startTime() async {
    var _duration = const Duration(seconds: 3);
    // await audioCache.play('eagle.mp3');
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    String pagechooser = '';

    if (pagechooser == '') {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: const MainScreen(page: HomePage(), index: 0),
        ),
      );
      // Navigator.of(context).pushReplacementNamed('/home_page');
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: const MainScreen(page: HomePage(), index: 0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      decoration: const BoxDecoration(
        color: kFourthColor,
        //image: DecorationImage(
        //image: AssetImage(
        // 'assets/gif1.gif',
        //),
        //fit: BoxFit.contain,
        //),
      ),
      child: Center(
        child: SizedBox(child: Image.asset('assets/mlcc_logo.png')),
      ),
    );
  }

  // void rememberLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var status = prefs.getBool('loginStatus') ?? false;
  //   if (status) {
  //     Navigator.pushReplacementNamed(context, '/home');
  //   } else {
  //     Navigator.pushReplacementNamed(context, '/login');
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }
}
