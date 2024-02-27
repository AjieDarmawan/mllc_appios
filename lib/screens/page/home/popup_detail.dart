import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:html/parser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';

class Popup_detail extends StatefulWidget {
  final String? title, descriptions, text, caption, type;
  final String? img;

  const Popup_detail(
      {Key? key,
      this.title,
      this.descriptions,
      this.text,
      this.img,
      this.caption,
      this.type})
      : super(key: key);

  @override
  State<Popup_detail> createState() => _Popup_detailState();
}

class _Popup_detailState extends State<Popup_detail> {
  String deviceID = '';
  int userId = 0;
  bool follow = false;

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Navigator.pop(context);
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: MainScreen(
                  page: HomePage(),
                  index: 0,
                ),
              ),
            );
          },
          icon: const Icon(Icons.keyboard_arrow_left, size: 30),
        ),
        elevation: 0.0,
        title: Text(widget.type.toString(),
            style: TextStyle(
              color: kSecondaryColor,
            )),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
          child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.black,
              child: Image.network(
                widget.img.toString(),
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.values[0],
                // size.width * 0.18 means it use 18% of total width
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 10.0, left: 10.0, right: 10.0, bottom: 5.0),
              child: Text(
                widget.title.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Text(
                widget.caption.toString(),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Html(
                data: widget.descriptions,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
