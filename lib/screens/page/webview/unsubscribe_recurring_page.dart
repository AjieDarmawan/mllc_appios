import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';

class UnsubscribeRecurring extends StatefulWidget {
  final int userId;

  const UnsubscribeRecurring({Key? key, required this.userId})
      : super(key: key);

  @override
  _UnsubscribeRecurringState createState() => _UnsubscribeRecurringState();
}

class _UnsubscribeRecurringState extends State<UnsubscribeRecurring> {
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
          Navigator.pop(context);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("isLoggedIn", true);
          prefs.setInt("userId", widget.userId);
          prefs.setBool("isExpired", false);
        } else if (status == false) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
    );
    if (status == true) {
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("Unsubscribe"),
        content: const Text("You have successfully unsubscribe auto renewal."),
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
        title: const Text("Unsubscribe"),
        content:
            const Text("An error seems to have occured while unsubscribing."),
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
            ),
          ),
        ));
  }

  String get initialUrl => api + 'ipay88/unsubscribe/${widget.userId}}';

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
