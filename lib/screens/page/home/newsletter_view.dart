import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:html/parser.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';

class NewsLetterViewPage extends StatefulWidget {
  final dynamic data;
  const NewsLetterViewPage({Key? key, this.data}) : super(key: key);
  @override
  _NewsLetterViewPageState createState() => _NewsLetterViewPageState();
}

class _NewsLetterViewPageState extends State<NewsLetterViewPage> {
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  @override
  void initState() {
    print(widget.data!['description']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

          elevation: 0.0,
          title: Text(widget.data!['type'],
              style: const TextStyle(
                color: kSecondaryColor,
              )),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
        ),
        body: CustomScrollView(
          primary: true,
          shrinkWrap: true,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              expandedHeight: 300,
              elevation: 0,
              // floating: true,
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              centerTitle: true,
              pinned: true,
              automaticallyImplyLeading: false,
              // bottom: entrepreneurTitleBarWidget(voucherData['name']),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/photo_webview_page',
                            arguments: {
                              'url': widget.data!['thumbnail'],
                              'title': widget.data!['title']
                            });
                      },
                      child: Image.network(
                        widget.data!['thumbnail'],
                        height: MediaQuery.of(context).size.height * 0.80,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        // size.width * 0.18 means it use 18% of total width
                      ),
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
                      widget.data!['title'],
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
                        widget.data!['publish_at'],
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
                        "By ${widget.data!['created_by']}",
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w300),
                      )
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(widget.data!['caption'],
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(top: 10, right: 10, left: 10),
                    child: const Text("Description :",
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                  //Text("tes"),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    // child: Text(_parseHtmlString(widget.data!['description']),
                    //     style: const TextStyle(
                    //         fontSize: 11, fontWeight: FontWeight.w700)),
                    child: Html(
                      data: widget.data!['description'],
                      onLinkTap: (url, _, __, ___) {
                        launch(url!);
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: TextButton(
                        onPressed: () {
                          launch(widget.data!['url_link'].length == 0
                              ? ""
                              : widget.data!['url_link'][0]);
                        },
                        child: Text(
                            widget.data!['url_link'].length == 0
                                ? ""
                                : widget.data!['url_link'][0],
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
