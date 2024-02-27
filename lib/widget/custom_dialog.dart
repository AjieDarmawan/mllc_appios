import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/page/auth/login_page.dart';
import 'package:mlcc_app_ios/screens/page/home/popup_detail.dart';
import 'package:page_transition/page_transition.dart';

class CustomDialogBox extends StatefulWidget {
  final String? title, descriptions, text, caption, type;
  final String? img;

  const CustomDialogBox(
      {Key? key,
      this.title,
      this.descriptions,
      this.text,
      this.img,
      this.caption,
      this.type})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: Popup_detail(
                  title: widget.title,
                  descriptions: widget.descriptions,
                  img: widget.img,
                  caption: widget.caption,
                  type: widget.type,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.only(
                left: Constants.padding,
                top: Constants.avatarRadius + Constants.padding,
                right: Constants.padding,
                bottom: Constants.padding),
            margin: const EdgeInsets.only(top: Constants.avatarRadius),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(Constants.padding),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 10),
                      blurRadius: 10),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(widget.img ?? "assets/mlcc_logo.jpg"),
                ),
                Center(
                  child: Text(
                    widget.title ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.caption ?? "",
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 22,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        widget.text ?? "",
                        style: const TextStyle(fontSize: 18),
                      )),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: kPrimaryColor,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Icon(
                  Icons.campaign,
                  color: kSecondaryColor,
                  size: 50,
                )),
          ),
        ),
        Positioned(
            top: 30,
            right: 0,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: const Icon(Icons.close)),
            )),
      ],
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 10;
  static const double avatarRadius = 40;
}
