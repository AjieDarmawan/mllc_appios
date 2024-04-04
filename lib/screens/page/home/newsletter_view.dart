import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:html/parser.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/screens/page/home/home_swiper_event.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';

class NewsLetterViewPage extends StatefulWidget {
  final dynamic data;
  final int? news_id;
  final String? type;
  const NewsLetterViewPage({Key? key, this.data, this.news_id, this.type})
      : super(key: key);
  @override
  _NewsLetterViewPageState createState() => _NewsLetterViewPageState();
}

class _NewsLetterViewPageState extends State<NewsLetterViewPage> {
  final SwiperController _swiperControllernews = SwiperController();
  var newsdetail = [];
  var loading = true;
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  void detail(news_id) async {
    final _formData = {};
    _formData['news_id'] = news_id;
    var newsdetailapi =
        await httpProvider.postHttp("newsletter/info", _formData);
    setState(() {
      newsdetail.add(newsdetailapi);
      loading = false;
    });
  }

  @override
  void initState() {
    detail(widget.news_id == null ? widget.data!['id'] : widget.news_id);

    // detail(53);
    //print(widget.data!['description']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print("newsdetail${newsdetail[0]['id']}");

    Size size = MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          // bottomOpacity: 4.0,
          leading: IconButton(
            onPressed: () {
              if (widget.news_id.toString() != null) {
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
                Navigator.pushReplacementNamed(context, '/home_main');
              } else {}

              Navigator.pop(context);
            },
            icon: const Icon(Icons.keyboard_arrow_left, size: 30),
          ),

          elevation: 0.0,
          title: Text(loading == true ? "" : newsdetail[0]['title'],
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
                          //       'url': newsdetail[0]!['thumbnail'],
                          //       'title': newsdetail[0]!['title']
                          //     });
                          //   },
                          //   child: Image.network(
                          //     newsdetail[0]!['thumbnail'],
                          //     height: MediaQuery.of(context).size.height * 0.80,
                          //     width: MediaQuery.of(context).size.width,
                          //     fit: BoxFit.cover,
                          //     // size.width * 0.18 means it use 18% of total width
                          //   ),
                          // ),
                          (newsdetail[0]['multi_images'].length > 0 &&
                                  newsdetail[0]['multi_images'].length > 0)
                              ? HomeSwipeEvent(
                                  images: newsdetail[0]['multi_images'],
                                  title: newsdetail[0]['title'],
                                  swiperControllerbanner_:
                                      _swiperControllernews,
                                  height:
                                      MediaQuery.of(context).size.height * 0.30,
                                )
                              : (newsdetail[0]['thumbnail'] != null &&
                                      newsdetail[0]['thumbnail'] != "")
                                  ? GestureDetector(
                                      child: CachedNetworkImage(
                                        height: 350,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        imageUrl: newsdetail[0]['thumbnail'],
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
                                              'url': newsdetail[0]['thumbnail'],
                                              'title': newsdetail[0]['title']
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
                            newsdetail[0]!['title'],
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
                              newsdetail[0]!['publish_at'],
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
                              "By ${newsdetail[0]!['created_by']}",
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w300),
                            )
                          ]),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(newsdetail[0]!['caption'],
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
                          // child: Text(_parseHtmlString(newsdetail[0]!['description']),
                          //     style: const TextStyle(
                          //         fontSize: 11, fontWeight: FontWeight.w700)),
                          child: Html(
                            data: newsdetail[0]!['description'],
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
