import 'package:flutter/material.dart';

//Live
const link = "https://lcpsolution.com/mlcc/img/banners/";

//Staging
// const link = "http://188.166.188.224/img/banners/";

//Live
// const api = "https://mlcc.lcpsolution.com/mlcc/api/";
// const api2 = "https://mlcc.lcpsolution.com/mlcc_memberAPI/api/";
// const api3 = "https://mlcc.lcpsolution.com/mlcc_adsAPI/api/";

//Staging

const api = "https://staging-mlcc.lcpsolution.com/mlcc/api/";
const api2 = "https://staging-mlcc.lcpsolution.com/mlcc_memberAPI/api/";
const api3 = "https://staging-mlcc.lcpsolution.com/mlcc_adsAPI/api/";

//X Project Live
const apiTest = "https://adsAPI.xclubmy.com/api/";

//X Project Staging
// const apiTest = "http://188.166.188.224:82/api/";
//

int announcement = 0;
int notices = 0;
const font = {
  "headline6":
      TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, height: 1.3),
  "headline5":
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, height: 1.3),
  "headline4":
      TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, height: 1.3),
  "headline3":
      TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, height: 1.3),
  "headline2":
      TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, height: 1.4),
  "headline1":
      TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300, height: 1.4),
  "subtitle2":
      TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, height: 1.2),
  "subtitle1":
      TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, height: 1.2),
  "bodyText2":
      TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, height: 1.2),
  "bodyText1":
      TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, height: 1.2),
  "caption":
      TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300, height: 1.2),
};

const kPrimaryColor = Color.fromARGB(255, 128, 105, 47);
const kSecondaryColor = Color(0xFFFFFFFF);
const kThirdColor = Color(0xFFa28450);
const kFourthColor = Color.fromARGB(255, 106, 85, 14);
const kTextColor = Color(0xFF000000);
const kGreyColor = Color(0xFF6A656C);
const kblueColor = Color(0xFF2D8BD3);
const kredColor = Color(0xFFFF0000);
const kGreenColor = Color(0xFF038439);
const korangeColor = Color(0xFFFF8C00);

const kTextLightColor = Color(0xFFEEEEF6);
// const kText2Color = Color(0xFF010103);
// const kTextLight2Color = Color(0xFFEEEEF6);

class EduButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String? buttonText;
  final int? textSize;
  final Color? buttonColor, textColor;
  EduButton(
      {required this.onPressed,
      this.buttonText,
      this.textSize,
      this.buttonColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: buttonColor ?? kPrimaryColor,
        shape: StadiumBorder(),
      ),
      child: Center(
        child: Text(
          buttonText ?? 'Click',
          maxLines: 1,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: textColor ?? kSecondaryColor),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class EduButtonSecond extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String? buttonText;
  final int? textSize;

  EduButtonSecond({
    required this.onPressed,
    this.buttonText,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        side: BorderSide(width: 2.0, color: kPrimaryColor),
        shape: StadiumBorder(),
      ),
      child: Center(
        child: Text(
          buttonText ?? 'Click',
          maxLines: 1,
          style: TextStyle(
              color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
