import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/parser.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/account/account_view.dart';
import 'package:mlcc_app_ios/widget/til_widget.dart';

import '../webview/policy_and_tnc_webview_page.dart';

class ContactUsViewPage extends StatefulWidget {
  final dynamic contactUs;
  const ContactUsViewPage({Key? key, this.contactUs}) : super(key: key);

  @override
  _ContactUsViewPageState createState() => _ContactUsViewPageState();
}

class _ContactUsViewPageState extends State<ContactUsViewPage> {
  @override
  void initState() {
    // getContactUsInfo();
    super.initState();
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  backtoPrevious() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Navigator.of(context).popUntil((route) => route.isFirst);
    if (prefs.getBool('isLoggedIn') == true) {
      Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: const MainScreen(
              page: AccountViewPage(),
              index: 4,
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return backtoPrevious();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "About Us",
              style: TextStyle(
                color: kSecondaryColor,
              ),
            ),
            centerTitle: true,
            backgroundColor: kPrimaryColor,
            elevation: 0,
          ),
          body: CustomScrollView(
            primary: true,
            shrinkWrap: true,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Image.asset(
                        //widget.contactUs['company_logo'],
                        'assets/mlcc_logo.png',
                        fit: BoxFit.contain,
                        width: 200,
                        height: 200,
                      ),
                    ),
                    TilWidget(
                        actions: [],
                        title: const Text("Assosiation Name",
                            style:
                                TextStyle(fontSize: 16, color: kPrimaryColor)),
                        content: Text(
                          //widget.contactUs['company_name'],
                          "Malaysia Lin Chamber of Commerce",
                          textAlign: TextAlign.left,
                          // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                        )),
                    // TilWidget(
                    //     actions: [],
                    //     title: const Text("Registration No",
                    //         style: TextStyle(fontSize: 16, color: kPrimaryColor)),
                    //     content: Text(
                    //       //widget.contactUs['registration_no'],
                    //       '',
                    //       textAlign: TextAlign.left,
                    //       // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                    //     )),
                    TilWidget(
                        actions: [],
                        title: const Text("Address",
                            style:
                                TextStyle(fontSize: 16, color: kPrimaryColor)),
                        content: Text(
                          //_parseHtmlString(widget.contactUs['address']),
                          "Kuala Lumpur",
                          textAlign: TextAlign.left,
                          // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                        )),
                    TilWidget(
                        actions: const [],
                        title: const Text("Website",
                            style:
                                TextStyle(fontSize: 16, color: kPrimaryColor)),
                        content: GestureDetector(
                          onTap: () {
                            launch("http://worldlincc.com/");
                          },
                          child: Text(
                            //widget.contactUs['website'],
                            "http://worldlincc.com/",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                        )),
                    TilWidget(
                        actions: const [],
                        title: const Text("Contact No",
                            style:
                                TextStyle(fontSize: 16, color: kPrimaryColor)),
                        content: GestureDetector(
                          onTap: () {
                            launch("https://wa.me/60173612345");
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.whatsapp,
                                    // additional properties like size, color, etc.
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      //widget.contactUs['03 - 2267 1200'],
                                      "017-361 2345",
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                    TilWidget(
                      actions: const [],
                      title: const Text("Email",
                          style: TextStyle(fontSize: 16, color: kPrimaryColor)),
                      content: Wrap(
                        direction: Axis.horizontal,
                        runSpacing: 20,
                        children: <Widget>[
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: <Widget>[
                          //     Expanded(
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: <Widget>[
                          //           Column(
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.start,
                          //             children: [
                          //               Text(
                          //                 "Payment",
                          //                 overflow: TextOverflow.ellipsis,
                          //                 softWrap: false,
                          //                 maxLines: 2,
                          //                 style: Theme.of(context)
                          //                     .textTheme
                          //                     .bodyText2!
                          //                     .merge(const TextStyle(
                          //                         color: Colors.black)),
                          //               ),
                          //               const SizedBox(height: 5),
                          //               GestureDetector(
                          //                 onTap: () {
                          //                   launch("mailto:" +
                          //                       widget.contactUs['email']
                          //                           ['Payment']);
                          //                 },
                          //                 child: Text(
                          //                   widget.contactUs['email']
                          //                       ['Payment'],
                          //                   overflow: TextOverflow.ellipsis,
                          //                   softWrap: false,
                          //                   maxLines: 2,
                          //                   style: const TextStyle(
                          //                       color: Colors.blue,
                          //                       decoration:
                          //                           TextDecoration.underline),
                          //                 ),
                          //               ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  "Admin",
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .merge(
                                          const TextStyle(color: Colors.black)),
                                ),
                                const SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () {
                                    launch("mailto:" +
                                        "malaysialinchamber@gmail.com");
                                    //widget.contactUs['callcenter@ktmb.com.my']['Admin'][1]);
                                  },
                                  child: Text(
                                    //widget.contactUs['callcenter@ktmb.com.my']['Admin'][1],
                                    "malaysialinchamber@gmail.com",
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                                // const SizedBox(height: 10),
                                // GestureDetector(
                                //   onTap: () {
                                //     launch("mailto:" +
                                //         widget.contactUs['email']
                                //             ['Admin'][0]);
                                //   },
                                //   child: Text(
                                //     widget.contactUs['email']['Admin']
                                //         [0],
                                //     overflow: TextOverflow.ellipsis,
                                //     softWrap: false,
                                //     maxLines: 2,
                                //     style: const TextStyle(
                                //         color: Colors.blue,
                                //         decoration:
                                //             TextDecoration.underline),
                                //   ),
                                // ),
                                const SizedBox(height: 20),
                                Text(
                                  "IT Support",
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .merge(
                                          const TextStyle(color: Colors.black)),
                                ),
                                const SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () {
                                    launch("mailto:" +
                                        "support@lcpbuildsofttechnology.com");
                                    //widget.contactUs['support@lcpbuildsofttechnology.com']['IT']);
                                  },
                                  child: Text(
                                    //widget.contactUs['support@lcpbuildsofttechnology.com']['IT'],
                                    "support@lcpbuildsofttechnology.com",
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ]),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));

    // TilWidget(
    //     actions: const [],
    //     title: const Text("Refund Policy & Terms & Conditions",
    //         style: TextStyle(fontSize: 16, color: kPrimaryColor)),
    //     content: GestureDetector(
    //       onTap: () {
    //         Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PolicynTNCPage()));
    //       },
    //       child: Text(
    //         'View Here',
    //         textAlign: TextAlign.left,
    //         style: const TextStyle(
    //             color: Colors.blue,
    //             decoration: TextDecoration.underline),
    //       ),
    //     ));
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //  // );
  }
}
