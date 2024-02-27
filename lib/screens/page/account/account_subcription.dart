import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:html/parser.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';
import 'package:mlcc_app_ios/screens/page/auth/login_page.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';

import '../../../widget/block_button_widget.dart';

class SubsciptionPlanPage extends StatefulWidget {
  final dynamic data;
  final List planList;

  const SubsciptionPlanPage(
      {Key? key, required this.data, required this.planList})
      : super(key: key);

  @override
  _SubsciptionPlanPageState createState() => _SubsciptionPlanPageState();
}

class _SubsciptionPlanPageState extends State<SubsciptionPlanPage> {
  @override
  void initState() {
    super.initState();
    print(widget.data['package_name']);
  }

  var _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Subscription",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(bottom: 20.0),
                    decoration: const BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(45.0),
                          bottomRight: Radius.circular(45.0)),
                    ),
                    child: Column(children: [
                      Card(
                        elevation: 10,
                        color: kThirdColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.20,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${widget.data['package_name']} Member',
                                            style: const TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontFamily: 'Times New Roman',
                                              fontSize: 16,
                                              color: kPrimaryColor,
                                            )),
                                        const Text("MLCC member",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontFamily: 'Times New Roman',
                                              fontSize: 16,
                                              color: kSecondaryColor,
                                            )),
                                      ],
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 5,
                                              color: kSecondaryColor,
                                              spreadRadius: 2)
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: kPrimaryColor,
                                        radius: 25,
                                        child: ClipOval(
                                          child: Image.asset(
                                              "assets/mlcc_logo.jpg",
                                              height: 45,
                                              width: 45,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  color: kSecondaryColor,
                                                  spreadRadius: 2)
                                            ],
                                          ),
                                          child: CircleAvatar(
                                            backgroundColor: kPrimaryColor,
                                            radius: 15,
                                            child: ClipOval(
                                              child: Image.network(
                                                  widget.data['thumbnail'],
                                                  height: 45,
                                                  width: 45,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(widget.data['member_number'],
                                                  style: const TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontFamily:
                                                        'Times New Roman',
                                                    fontSize: 11,
                                                    color: kPrimaryColor,
                                                  )),
                                              Text(widget.data['name'],
                                                  style: const TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontFamily:
                                                        'Times New Roman',
                                                    fontSize: 11,
                                                    color: kSecondaryColor,
                                                  )),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                        "Expired Date : \n" +
                                            widget.data['expired_date'],
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontFamily: 'Times New Roman',
                                          fontSize: 11,
                                          color: kPrimaryColor,
                                        )),
                                  ],
                                )
                              ]),
                        ),
                      )
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CarouselSlider(
                        options: CarouselOptions(
                            initialPage: 0,
                            onPageChanged: (index, reason) {
                              setState(() => _current = index);
                            },
                            autoPlay: false,
                            enlargeCenterPage: true,
                            aspectRatio: 9 / 12,
                            height: MediaQuery.of(context).size.height * 0.6),
                        items: widget.planList
                            .map((item) => planCard(context, item))
                            .toList()),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  ClipRRect planCard(BuildContext context, item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: GestureDetector(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.amber[200],
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  color: kPrimaryColor,
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: FittedBox(
                    child: Text(item['plan'],
                        style: const TextStyle(color: Colors.white)),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text(item['price']),
                      // const SizedBox(height: 15.0),
                      // Text('${item['storage'] / 1000} GB Storage'),
                      const SizedBox(height: 15.0),
                      Text(_parseHtmlString(item['desc'])),
                      Html(
                        data: item['desc'],
                        onLinkTap: (url, _, __, ___) {
                          launch(url!);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // child: Text(item['name']),
          ),
        ),
      ),
    );
  }
}
