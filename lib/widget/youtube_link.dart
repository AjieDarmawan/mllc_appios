import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mlcc_app_ios/constant.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideo extends StatefulWidget {
  final String videoUrl;
  const YoutubeVideo({required this.videoUrl});
  @override
  _YoutubeVideoState createState() => _YoutubeVideoState();
}

class _YoutubeVideoState extends State<YoutubeVideo> {
//  String videoURL = "https://www.youtube.com/watch?v=oxsBSCf5-B8&list=RDoxsBSCf5-B8&start_radio=1";

  // late YoutubePlayerController _controller;

  @override
  void initState() {
    // _controller = YoutubePlayerController(
    //     flags: const YoutubePlayerFlags(
    //       autoPlay: true,
    //       mute: false,
    //       disableDragSeek: false,
    //       // loop: false,
    //       // isLive: false,
    //       forceHD: true,
    //       // hideControls: true,
    //     ),
    //     initialVideoId:
    //         YoutubePlayer.convertUrlToId(widget.videoUrl) as String);
    super.initState();
  }

  youtubeHierarchy() {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: kPrimaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.close, size: 30, color: kSecondaryColor),
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF000000).withOpacity(0.8),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Align(
          alignment: Alignment.center,
          child: FittedBox(fit: BoxFit.cover, child: Text("ts")
              // YoutubePlayer(
              //   controller: _controller,
              // ),
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      if (orientation == Orientation.landscape) {
        return WillPopScope(
            onWillPop: () {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
              Navigator.of(context).pop();
              //we need to return a future
              return Future.value(false);
            },
            child: youtubeHierarchy());
      } else {
        return WillPopScope(
            onWillPop: () {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
              Navigator.of(context).pop();
              //we need to return a future
              return Future.value(false);
            },
            child: youtubeHierarchy());
      }
    });
  }
}
