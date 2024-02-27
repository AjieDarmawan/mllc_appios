import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';
import 'package:mlcc_app_ios/widget/block_button_widget.dart';
import 'package:page_transition/page_transition.dart';

class RegisterSuccessfulPage extends StatefulWidget {
  const RegisterSuccessfulPage({Key? key, required Map arguments}) : super(key: key);

  // const LoginPage({Key key}) : super(key: key);
  @override
  _RegisterSuccessfulPageState createState() => _RegisterSuccessfulPageState();
}

class _RegisterSuccessfulPageState extends State<RegisterSuccessfulPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Colors.green.withOpacity(1),
                            Colors.green.withOpacity(0.2),
                          ])),
                  child: Icon(
                    Icons.check,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    size: 90,
                  ),
                ),
                Positioned(
                  right: -30,
                  bottom: -50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  top: -50,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              "Thank you!",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Opacity(
              opacity: 0.5,
              child: Text(
                "Your account has been successfully submitted, you will receive an email once admin approved your account",
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBlockButtonWidget(),
    );
  }

  Widget buildBlockButtonWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Get.theme.focusColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5)),
        ],
      ),
      child: BlockButtonWidget(
          text: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: const [
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Back to Home Page",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20)
            ],
          ),
          color: kPrimaryColor,
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: const MainScreen(page: HomePage(), index: 0),
              ),
            );
          }).paddingOnly(bottom: 20, right: 20, left: 20),
    );
  }
}
