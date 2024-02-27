import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/page/adv/xproject_details.dart';

class XProjectListWidget extends StatefulWidget {
  final dynamic list;
  // final int id;

  const XProjectListWidget({Key? key, this.list}) : super(key: key);

  @override
  _XProjectListWidgetState createState() => _XProjectListWidgetState();
}

class _XProjectListWidgetState extends State<XProjectListWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: XProjectDetails(projectId: widget.list['id'])),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 35,
                backgroundImage:
                    CachedNetworkImageProvider(widget.list['thumbnail'])),
            const SizedBox(height: 10),
            Text(
              widget.list['title'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
            Flexible(
              child: Text(
                widget.list['caption'],
                maxLines: 2,
                softWrap: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ));
  }
}
