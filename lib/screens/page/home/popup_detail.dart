import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:html/parser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class Popup_detail extends StatefulWidget {
  final String? title, descriptions, text, caption, type;
  final String? img;

  var tel_number = [];
  var email_address = [];
  var url_link = [];

  Popup_detail(
      {Key? key,
      this.title,
      this.descriptions,
      this.text,
      this.img,
      this.caption,
      required this.tel_number,
      required this.url_link,
      required this.email_address,
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
        // backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
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
      body: CustomScrollView(
        primary: true,
        shrinkWrap: true,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            expandedHeight: 400,
            elevation: 0,
            // floating: true,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            centerTitle: true,
            pinned: true,
            automaticallyImplyLeading: false,
            // bottom: entrepreneurTitleBarWidget(voucherData['name']),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/photo_webview_page',
                          arguments: {
                            'url': widget.img,
                            'title': widget.title.toString(),
                          });
                    },
                    child: Image.network(
                      widget.img.toString(),
                      height: MediaQuery.of(context).size.height * 0.80,
                      width: MediaQuery.of(context).size.width,
                      // fit: BoxFit.cover,
                      fit: BoxFit.cover,
                      // size.width * 0.18 means it use 18% of total width
                    ),
                  ),
                ],
              ),
            ).marginOnly(bottom: 0),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 10.0, right: 10.0, bottom: 5.0),
                  child: Text(
                    widget.title.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                  child: Text(
                    widget.caption.toString(),
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
                // Container(
                //   padding: const EdgeInsets.all(10.0),
                //   child: Html(
                //     data: widget.descriptions, style: {
                //     'html': Style(textAlign: TextAlign.right),
                //   }
                //   ),
                // ),

                Container(
                  padding: const EdgeInsets.all(10.0),
                  // child: Text(_parseHtmlString(widget.data!['description']),
                  //     style: const TextStyle(
                  //         fontSize: 11, fontWeight: FontWeight.w700)),
                  child: Html(
                    data: widget.descriptions,
                    onLinkTap: (url, _, __, ___) {
                      launch(url!);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 15, top: 0, right: 0, bottom: 0),
                    child: Column(
                      children: [
                        Container(
                          child: TextButton(
                            onPressed: () {
                              launch(widget.url_link.length == 0
                                  ? ""
                                  : widget.url_link[0]);
                            },
                            child: Text(
                                widget.url_link.length == 0
                                    ? ""
                                    : widget.url_link[0],
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                )),
                          ),
                        ),
                        // Container(
                        //   child: Row(
                        //     children: [
                        //       Text("Contact Person"),
                        //       TextButton(
                        //         onPressed: () {
                        //           launch(widget.tel_number.length == 0
                        //               ? ""
                        //               :
                        //               //"https://wa.me/" +
                        //               "tel:" + widget.tel_number[0]);
                        //         },
                        //         child: Text(
                        //             widget.tel_number.length == 0
                        //                 ? ""
                        //                 : widget.tel_number[0],
                        //             textAlign: TextAlign.left,
                        //             style: const TextStyle(
                        //               fontWeight: FontWeight.w500,
                        //               decoration: TextDecoration.underline,
                        //             )),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Container(
                        //   child: Row(
                        //     children: [
                        //       Text("Email"),
                        //       TextButton(
                        //         onPressed: () {
                        //           launch(widget.email_address.length == 0
                        //               ? ""
                        //               : "mailto:" + widget.email_address[0]);
                        //         },
                        //         child: Text(
                        //             widget.email_address.length == 0
                        //                 ? ""
                        //                 : widget.email_address[0],
                        //             textAlign: TextAlign.left,
                        //             style: const TextStyle(
                        //               fontWeight: FontWeight.w500,
                        //               decoration: TextDecoration.underline,
                        //             )),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
