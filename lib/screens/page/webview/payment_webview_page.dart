import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/account/order_history_view.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';

class PaymentWebViewPage extends StatefulWidget {
  final int userId;
  final int training;
  final int event;
  final dynamic trainingData;
  final dynamic trainingList;
  final dynamic eventData;
  final int productID;
  final dynamic productData;

  const PaymentWebViewPage(
      {Key? key,
      required this.userId,
      required this.training,
      required this.event,
      this.trainingData,
      this.trainingList,
      this.eventData,
      required this.productID,
      this.productData})
      : super(key: key);

  @override
  _PaymentWebViewPageState createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late WebViewController _webViewController;
  HttpProvider httpProvider = HttpProvider();
  late DateTime calendarStartAt;
  late DateTime calendarEndAt;
  String calendarVenue = "";
  String calendarTitle = "";
  String calendarDescription = "";
  bool isScroll = false;
  @override
  void initState() {
    // TODO: implement initState
    if (Platform.isAndroid) {
      isScroll = true;
    } else if (Platform.isIOS) {
      isScroll = false;
    }
    super.initState();
  }

  showAlertDialog(BuildContext context, bool status) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () async {
        if (status == true) {
          if (widget.userId != 0 &&
              widget.training == 0 &&
              widget.event == 0 &&
              widget.productID == 0) {
            Navigator.pop(context);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool("isLoggedIn", true);
            prefs.setInt("userId", widget.userId);
            prefs.setBool("isExpired", false);
            var updateAccessDataReturn =
                await httpProvider.postHttp("last_access", {
              'user_id': widget.userId,
              'push_token': prefs.getString("OneSignalPlayerID"),
              'push_token_status': '1'
            });
            if (updateAccessDataReturn == "Success") {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: const MainScreen(
                    page: HomePage(),
                    index: 0,
                  ),
                ),
              );
            }
          } else if (widget.userId != 0 &&
              widget.training != 0 &&
              widget.event == 0 &&
              widget.productID == 0) {
            calendarStartAt = DateTime.parse(widget.trainingData['start_at']);
            calendarEndAt = DateTime.parse(widget.trainingData['end_at']);
            calendarTitle = "XClub - Training\n" + widget.trainingData['title'];
            calendarDescription =
                _parseHtmlString(widget.trainingData['description']);
            // Add2Calendar.addEvent2Cal(
            //   buildEvent(),
            // );

            Navigator.pop(context);
            Navigator.pushReplacementNamed(
                context, '/training_details_view_page', arguments: {
              'data': widget.trainingData,
              'trainingList': widget.trainingList
            });
          } else if (widget.userId != 0 &&
              widget.training == 0 &&
              widget.event != 0 &&
              widget.productID == 0) {
            calendarStartAt = DateTime.parse(widget.eventData['start_at']);
            calendarEndAt = DateTime.parse(widget.eventData['end_at']);
            calendarVenue = widget.eventData['venue'];
            calendarTitle = "MLCC - Event\n" + widget.eventData['title'];
            calendarDescription =
                _parseHtmlString(widget.eventData['description']);
            // Add2Calendar.addEvent2Cal(
            //   buildEvent(),
            // );

            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/event_details_view_page',
                arguments: {'data': widget.eventData});
          } else if (widget.userId == 0 &&
              widget.training != 0 &&
              widget.event == 0 &&
              widget.productID == 0) {
            calendarStartAt = DateTime.parse(widget.trainingData['start_at']);
            calendarEndAt = DateTime.parse(widget.trainingData['end_at']);
            calendarTitle = "XClub - Training\n" + widget.trainingData['title'];
            calendarDescription =
                _parseHtmlString(widget.trainingData['description']);
            // Add2Calendar.addEvent2Cal(
            //   buildEvent(),
            // );

            Navigator.pop(context);
            Navigator.pushReplacementNamed(
                context, '/training_details_view_page', arguments: {
              'data': widget.trainingData,
              'trainingList': widget.trainingList
            });
          } else if (widget.userId == 0 &&
              widget.training == 0 &&
              widget.event != 0 &&
              widget.productID == 0) {
            calendarStartAt = DateTime.parse(widget.eventData['start_at']);
            calendarEndAt = DateTime.parse(widget.eventData['end_at']);
            calendarVenue = widget.eventData['venue'];
            calendarTitle = "XClub - Event\n" + widget.eventData['title'];
            calendarDescription =
                _parseHtmlString(widget.eventData['description']);
            // Add2Calendar.addEvent2Cal(
            //   buildEvent(),
            // );

            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/event_details_view_page',
                arguments: {'data': widget.eventData});
          } else if (widget.userId != 0 &&
              widget.training == 0 &&
              widget.event == 0 &&
              widget.productID != 0) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child:
                      OrderHistoryListPage(userID: widget.userId, orderID: 0)),
            );
          } else if (widget.userId == 0 &&
              widget.training == 0 &&
              widget.event == 0 &&
              widget.productID != 0) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pushReplacementNamed(
                context, '/product_details_view_page',
                arguments: {
                  'data': widget.productData,
                });
          }
        } else if (status == false) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
    );
    if (status == true) {
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("Payment"),
        content: const Text("Payment Successful"),
        actions: [
          okButton,
        ],
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else {
      AlertDialog alert = AlertDialog(
        title: const Text("Payment"),
        content: const Text("Payment Failed"),
        actions: [
          okButton,
        ],
      );
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    // show the dialog
  }

  Future<void> _onDoPostRequest(
      WebViewController controller, BuildContext context) async {
    final WebViewRequest request = WebViewRequest(
      uri: Uri.parse('https://lcpsolution.com/xclub/api/ipay88/payment'),
      method: WebViewRequestMethod.post,
      headers: <String, String>{
        'user_id': '' + widget.userId.toString() + '',
        'training_id': '' + widget.training.toString() + '',
        'event_id': '' + widget.event.toString() + '',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      // body: Uint8List.fromList('Test Body'.codeUnits),
    );
    await controller.loadRequest(request);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: kPrimaryColor,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: isScroll,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back),
              backgroundColor: kThirdColor,
            ),
            body: WebView(
              initialUrl: initialUrl,

              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: <JavascriptChannel>[
                _scanBarcode(context),
              ].toSet(),
              gestureRecognizers: Set()
                ..add(
                  Factory<DragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer(),
                  ),
                ),
              // onWebViewCreated: (webViewController) {}
              //     _webViewController = webViewController,
              // // onPageFinished: (String url) {
              // //   if (url == initialUrl) _redirectToStripe(widget.sessionId);
              // // },
              // navigationDelegate: (NavigationRequest request) {
              //   if (request.url.startsWith('http://localhost:8080/#/success')) {
              //     // if (payData['mode'] == 'pay') {
              //     //   context
              //     //       .read<UserCommunitiesBloc>()
              //     //       .add(AddPaidUserCommunity(payData));
              //     // } else if (payData['mode'] == "upgrade community") {
              //     //   FirestoreWriteProvider().update("communities/${payData['cid']}", {'paidStatus': 'MEMBERSHIP-PAID'});
              //     //   // Navigator.pop(context);
              //     // } else {
              //     //   context
              //     //       .read<JoinCommunityBloc>()
              //     //       .add(JoinPaidCommunityStripe(payData));
              //     // }
              //     Navigator.pop(context);
              //   } else if (request.url
              //       .startsWith('http://localhost:8080/#/cancel')) {
              //     Navigator.pop(context);
              //   }
              //   return NavigationDecision.navigate;
              // },
            ),
          ),
        ));
    //   return Scaffold(
    //     floatingActionButton: FloatingActionButton(
    //       onPressed: () async {
    //         Navigator.pop(context);
    //       },
    //       child: const Icon(Icons.arrow_back),
    //       backgroundColor: kThirdColor,
    //     ),
    //     body: InAppWebView(
    //       initialUrlRequest: URLRequest(
    //           url: Uri.parse("https://lcpsolution.com/xclub/api/ipay88/payment"),
    //           method: 'POST',
    //           body: Uint8List.fromList(utf8.encode(
    //               "user_id=${widget.userId}&training_id=${widget.training}&event_id=${widget.event}")),
    //           headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
    //       // onWebViewCreated: (controller) {},
    //       onWebViewCreated: (InAppWebViewController controller) {
    //         var webView = controller;
    //         controller.addJavaScriptHandler(
    //             handlerName: "Barcode",
    //             callback: (value) {
    //               print("value ===" + value.toString());
    //             });
    //         // Add a Flutter JavaScript Handler that will return data to the JavaScript that called it
    //         webView.addJavaScriptHandler(
    //             handlerName: 'Barcode',
    //             callback: (List<dynamic> arguments) {
    //               print(arguments);
    //               return '${arguments[0]}, Text from Flutter';
    //             });
    //       },
    //     ),
    //   );
  }

  // String get initialUrl =>
  //     'https://admin.xclubmy.com/api/ipay88/payment/${widget.userId}/${widget.training}/${widget.event}/${widget.productID}';

  String get initialUrl =>
      api +
      'ipay88/payment/${widget.userId}/${widget.training}/${widget.event}/${widget.productID}';

  JavascriptChannel _scanBarcode(BuildContext context) {
    return JavascriptChannel(
        name: 'Barcode',
        onMessageReceived: (JavascriptMessage message) async {
          Map<String, dynamic> map = jsonDecode(message.message);
          print(map['status']);
          showAlertDialog(context, map['status']);
        });
  }

  // Event buildEvent({Recurrence? recurrence}) {
  //   return Event(
  //     title: calendarTitle,
  //     description: calendarDescription,
  //     location: calendarVenue,
  //     startDate: calendarStartAt,
  //     endDate: calendarEndAt,
  //     allDay: false,
  //     recurrence: recurrence,
  //   );
  // }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }
}
