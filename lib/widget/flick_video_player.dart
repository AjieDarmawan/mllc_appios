import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FlickVideo extends StatefulWidget {
  final dynamic videoUrl;
  const FlickVideo({required this.videoUrl});
  @override
  _FlickVideoState createState() => _FlickVideoState();
}

class _FlickVideoState extends State<FlickVideo> {
//  String videoURL = "https://www.youtube.com/watch?v=oxsBSCf5-B8&list=RDoxsBSCf5-B8&start_radio=1";

 // late YoutubePlayerController _controller;

  @override
  void initState() {
    // _controller = YoutubePlayerController(
    //     flags: const YoutubePlayerFlags(
    //       autoPlay: false,
    //       mute: true,
    //       disableDragSeek: false,
    //       loop: false,
    //       isLive: false,
    //       forceHD: false,
    //       hideControls: true,
    //     ),
    //     initialVideoId:
    //         YoutubePlayer.convertUrlToId(widget.videoUrl['video_link'])
    //             as String);
    super.initState();
  }

  youtubeHierarchy() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.fill,
          child: 
          Container(child: Text("tss"),),
          // YoutubePlayer(
          //   controller: _controller,
          // ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      if (orientation == Orientation.landscape) {
        return youtubeHierarchy();
      } else {
        return youtubeHierarchy();
      }
    });
  }
}
