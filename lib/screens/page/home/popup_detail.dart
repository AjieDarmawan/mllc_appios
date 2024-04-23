import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:html/parser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';
import 'package:mlcc_app_ios/screens/page/home/home_swiper_event.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class Popup_detail extends StatefulWidget {
  final int? id;

  Popup_detail({Key? key, this.id}) : super(key: key);

  @override
  State<Popup_detail> createState() => _Popup_detailState();
}

class _Popup_detailState extends State<Popup_detail> {
  var advdetail = [];
  var loading = true;
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  final SwiperController _swiperControllernews = SwiperController();
  Future<void> share(id) async {
    await FlutterShare.share(
        title: advdetail[0]['title'].toString(),
        text: '',
        linkUrl: apireal + 'shared/ads/' + id.toString(),
        chooserTitle: 'Share');
  }

  void detail(id) async {
    final _formData = {};
    _formData['ads_id'] = id;
    var advdetailapi =
        await httpProvider.postHttp("advertisement/detail", _formData);
    setState(() {
      advdetail.add(advdetailapi);
      loading = false;
    });
  }

  @override
  void initState() {
    detail(widget.id);
    //print(widget.data!['description']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print("advdetail${advdetail[0]['id']}");

    Size size = MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          // bottomOpacity: 4.0,
          leading: IconButton(
            onPressed: () {
              // Navigator.of(context).popUntil((route) => route.isFirst);
              // Navigator.pushReplacement(
              //   context,
              //   PageTransition(
              //     type: PageTransitionType.fade,
              //     child: const MainScreen(
              //       page: HomePage(),
              //       index: 0,
              //     ),
              //   ),
              // );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.keyboard_arrow_left, size: 30),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                onPressed: () {
                  share(widget.id);
                })
          ],
          elevation: 0.0,
          title: Text(loading == true ? "" : "Advertisement",
              style: const TextStyle(
                color: kSecondaryColor,
              )),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
        ),
        body: loading == true
            ? Center(child: CircularProgressIndicator())
            : CustomScrollView(
                primary: true,
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 300,
                    elevation: 0,
                    // floating: true,
                    iconTheme:
                        IconThemeData(color: Theme.of(context).primaryColor),
                    centerTitle: true,
                    pinned: true,
                    automaticallyImplyLeading: false,
                    // bottom: entrepreneurTitleBarWidget(voucherData['name']),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.pushNamed(
                          //         context, '/photo_webview_page', arguments: {
                          //       'url': advdetail[0]!['thumbnail'],
                          //       'title': advdetail[0]!['title']
                          //     });
                          //   },
                          //   child: Image.network(
                          //     advdetail[0]!['thumbnail'],
                          //     height: MediaQuery.of(context).size.height * 0.80,
                          //     width: MediaQuery.of(context).size.width,
                          //     fit: BoxFit.cover,
                          //     // size.width * 0.18 means it use 18% of total width
                          //   ),
                          // ),
                          (advdetail[0]['multi_images'].length > 0 &&
                                  advdetail[0]['multi_images'].length > 0)
                              ? HomeSwipeEvent(
                                  images: advdetail[0]['multi_images'],
                                  title: advdetail[0]['title'],
                                  swiperControllerbanner_:
                                      _swiperControllernews,
                                  height:
                                      MediaQuery.of(context).size.height * 0.30,
                                )
                              : (advdetail[0]['thumbnail'] != null &&
                                      advdetail[0]['thumbnail'] != "")
                                  ? GestureDetector(
                                      child: CachedNetworkImage(
                                        height: 350,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        imageUrl: advdetail[0]['thumbnail'],
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          'assets/loading.gif',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 350,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error_outline),
                                      ),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/photo_webview_page',
                                            arguments: {
                                              'url': advdetail[0]['thumbnail'],
                                              'title': advdetail[0]['title']
                                            });
                                      },
                                    )
                                  : Image.asset(
                                      'assets/mlcc_logo.jpg',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 350,
                                    ),
                        ],
                      ),
                    ).marginOnly(bottom: 0),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0, bottom: 5.0),
                          child: Text(
                            advdetail[0]!['title'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Row(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.calendar_today,
                                color: kThirdColor,
                                size: 20,
                              ),
                            ),
                            Text(
                              advdetail[0]!['publish_at'],
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w300),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10, right: 5.0),
                              child: Icon(
                                Icons.person,
                                color: kThirdColor,
                                size: 20,
                              ),
                            ),
                            Text(
                              "By ${advdetail[0]!['created_by']}",
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w300),
                            )
                          ]),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(advdetail[0]!['caption'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 10, right: 10, left: 10),
                          child: const Text("Description :",
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w700)),
                        ),
                        //Text("tes"),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          // child: Text(_parseHtmlString(advdetail[0]!['description']),
                          //     style: const TextStyle(
                          //         fontSize: 11, fontWeight: FontWeight.w700)),
                          child: Html(
                            data: advdetail[0]!['description'],
                            onLinkTap: (url, _, __, ___) {
                              launch(url!);
                            },
                          ),
                        ),
                        // Align(
                        //   alignment: Alignment.bottomLeft,
                        //   child: Container(
                        //     padding: const EdgeInsets.all(10.0),
                        //     child: TextButton(
                        //       onPressed: () {
                        //         launch(widget.data!['url_link'].length == 0
                        //             ? ""
                        //             : widget.data!['url_link'][0]);
                        //       },
                        //       child: Text(
                        //           widget.data!['url_link'].length == 0
                        //               ? ""
                        //               : widget.data!['url_link'][0],
                        //           textAlign: TextAlign.left,
                        //           style: const TextStyle(
                        //             fontWeight: FontWeight.w500,
                        //             decoration: TextDecoration.underline,
                        //           )),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
