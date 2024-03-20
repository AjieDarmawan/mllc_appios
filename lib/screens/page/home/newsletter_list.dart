import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';
import 'package:mlcc_app_ios/screens/page/home/newsletter_all.dart';
import 'package:mlcc_app_ios/screens/page/home/newsletter_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsLetterListPage extends StatefulWidget {
  final dynamic data;
  const NewsLetterListPage({Key? key, this.data}) : super(key: key);
  @override
  _NewsLetterListPageState createState() => _NewsLetterListPageState();
}

class _NewsLetterListPageState extends State<NewsLetterListPage> {
  dynamic alllNewsLetterList = [];
  dynamic announcementList = [];
  dynamic newsLetterList = [];
  int userId = 0;
  dynamic log = [];

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  final List<Tab> myTabs = <Tab>[
    // const Tab(text: 'Trainings'),
    const Tab(text: 'All'),
    const Tab(text: 'Announcements'),
    const Tab(text: 'News'),
  ];

  void getUser() async {
    //  print("newslettergetUser");
    final _formData = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
      //print("newslettergetUser${userId}");
      if (userId != 0) {
        //print("newslettergetUser-masuk");
        _formData['log_user_id'] = userId;
        _formData['page'] = "News";
      }
    });

    if (userId != 0) {
      print("newsletter${_formData}");
      log = await httpProvider.postHttp("log/create", _formData);
    }
  }

  @override
  void initState() {
    getUser();
    alllNewsLetterList = widget.data;
    for (int i = 0; i < widget.data.length; i++) {
      if (widget.data[i]['type'] == 'Announcements') {
        setState(() {
          announcementList.add(widget.data[i]);
        });
      } else if (widget.data[i]['type'] == 'News') {
        newsLetterList.add(widget.data[i]);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          appBar: AppBar(
            // bottomOpacity: 4.0,
            elevation: 0.0,
            title: const Text("All Newsletter",
                style: TextStyle(
                  color: kSecondaryColor,
                )),
            centerTitle: true,
            backgroundColor: kPrimaryColor,
            bottom: TabBar(
                // controller: _tabController,
                // onTap: (index) =>
                //     setState(() => _activeTabIndex = widget.tabIndex),
                indicatorColor: kThirdColor,
                tabs: myTabs),
          ),
          body: TabBarView(
            // controller: _tabController,
            children: <Widget>[
              // TrainingsListPage(data: listData['trainings']),
              // EventsListPage(data: listData['events']),
              AllNewsLetterListPage(data: alllNewsLetterList),
              AllNewsLetterListPage(data: announcementList),
              AllNewsLetterListPage(data: newsLetterList),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildNewslettersList(dynamic newsletter) {
  //   return InkWell(
  //     child: Container(
  //       margin: const EdgeInsets.all(10),
  //       width: MediaQuery.of(context).size.width,
  //       decoration: BoxDecoration(
  //         color: Colors.grey.shade200,
  //         // color: kPrimaryColor,
  //         borderRadius: const BorderRadius.all(Radius.circular(10)),
  //       ),
  //       // child: Padding(
  //       //   padding: const EdgeInsets.all(8.0),
  //       //   child: Center(
  //       //       child:
  //       //           Image.network(newsletter['thumbnail'], fit: BoxFit.fitHeight)),
  //       // ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Center(
  //               child: Image.network(
  //             newsletter['thumbnail'],
  //             fit: BoxFit.fill,
  //             height: MediaQuery.of(context).size.height * 0.30,
  //             width: MediaQuery.of(context).size.width * 0.90,
  //           )),
  //           Padding(
  //             padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
  //             child: Text(
  //               newsletter['title'],
  //               style:
  //                   const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
  //             ),
  //           ),
  //           Container(
  //             padding: const EdgeInsets.only(right: 10.0),
  //             child: Row(children: [
  //               const Padding(
  //                 padding: EdgeInsets.all(8.0),
  //                 child: Icon(
  //                   Icons.calendar_today,
  //                   color: kThirdColor,
  //                   size: 13,
  //                 ),
  //               ),
  //               Text(
  //                 newsletter['publish_at'],
  //                 style: const TextStyle(
  //                     fontSize: 11, fontWeight: FontWeight.w300),
  //               ),
  //               const Padding(
  //                 padding: EdgeInsets.only(left: 10, right: 5.0),
  //                 child: Icon(
  //                   Icons.person,
  //                   color: kThirdColor,
  //                   size: 13,
  //                 ),
  //               ),
  //               Text(
  //                 "By ${newsletter['created_by']}",
  //                 style: const TextStyle(
  //                     fontSize: 11, fontWeight: FontWeight.w300),
  //               )
  //             ]),
  //           ),
  //           // Container(
  //           //   padding: const EdgeInsets.only(right: 10.0),
  //           //   child: Row(children: [
  //           //     const Padding(
  //           //       padding: EdgeInsets.all(8.0),
  //           //       child: Icon(
  //           //         Icons.calendar_today,
  //           //         color: kThirdColor,
  //           //         size: 11,
  //           //       ),
  //           //     ),
  //           //     Text(
  //           //       newsletter['posted_date'],
  //           //       style:
  //           //           const TextStyle(fontSize: 7, fontWeight: FontWeight.w300),
  //           //     ),
  //           //     const Padding(
  //           //       padding: EdgeInsets.only(left: 10, right: 5.0),
  //           //       child: Icon(
  //           //         Icons.person,
  //           //         color: kThirdColor,
  //           //         size: 11,
  //           //       ),
  //           //     ),
  //           //     Text(
  //           //       "By ${newsletter['created_by']}",
  //           //       style:
  //           //           const TextStyle(fontSize: 7, fontWeight: FontWeight.w300),
  //           //     )
  //           //   ]),
  //           // ),
  //         ],
  //       ),
  //     ),
  //     onTap: () {
  //       // Navigator.of(context).popUntil((route) => route.isFirst);
  //       Navigator.push(
  //         context,
  //         PageTransition(
  //           type: PageTransitionType.fade,
  //           child: NewsLetterViewPage(data: newsletter),
  //         ),
  //       );
  //     },
  //   );
  // }
}
