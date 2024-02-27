import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:mlcc_app_ios/constant.dart';

class WebviewContainerPhoto extends StatefulWidget {
  final String title;
  final dynamic url;

  const WebviewContainerPhoto(
      {Key? key, required this.title, required this.url})
      : super(key: key);

  @override
  _WebviewContainerState createState() => _WebviewContainerState();
}

class _WebviewContainerState extends State<WebviewContainerPhoto> {
  late PhotoViewController controller;
  late double scaleCopy;

  @override
  void initState() {
    super.initState();
    controller = PhotoViewController()..outputStateStream.listen(listener);
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  void listener(PhotoViewControllerValue value) {
    setState(() {
      scaleCopy = value.scale!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text(widget.title)),
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(
              color: kSecondaryColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        body: PhotoView(
          imageProvider: NetworkImage(widget.url),
          controller: controller,
        ));
  }
}
