import 'package:flutter/material.dart';
import 'package:mlcc_app_ios/widget/youtube_link.dart';

class MediaDetailPage extends StatefulWidget {
  final String mediaUrl;
  const MediaDetailPage({Key? key, required this.mediaUrl}) : super(key: key);
  @override
  _MediaDetailPageState createState() => _MediaDetailPageState();
}

class _MediaDetailPageState extends State<MediaDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubeVideo(
      videoUrl: widget.mediaUrl,
    );
  }
}
