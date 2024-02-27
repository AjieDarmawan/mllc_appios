import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../constant.dart';

class PolicynTNCPage extends StatefulWidget {
  const PolicynTNCPage({Key? key}) : super(key: key);

  @override
  State<PolicynTNCPage> createState() => _PolicynTNCPageState();
}

class _PolicynTNCPageState extends State<PolicynTNCPage> {
  // final Completer<WebViewController> _controller =
  //     Completer<WebViewController>();
  late WebViewController controller;
  bool isLoading = true;
  String pdfPath =
      'https://www.xclubmy.com/X%20Club%20Website%20Refund%20Policy,%20Privacy%20Policy%20and%20TnC%20220114.pdf';

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 4,
          title: const Text("Refund Policy and Terms & Conditions"),
          backgroundColor: kPrimaryColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: Stack(
          children: [
            WebView(
              initialUrl:
                  ('https://docs.google.com/gview?embedded=true&url=$pdfPath'),
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(),
          ],
        ));
  }
}
