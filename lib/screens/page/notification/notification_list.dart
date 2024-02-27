import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/account/account_view.dart';
import 'package:mlcc_app_ios/screens/page/notification/notification.dart';

class NotificationPage extends StatefulWidget {
  final dynamic data;
  final dynamic unread;
  final int notificationID;
  const NotificationPage(
      {Key? key, this.data, this.unread, required this.notificationID})
      : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with SingleTickerProviderStateMixin {
  List<dynamic> notificationsList = [];
  List<dynamic> notificationsLists = [];
  var userId = 0;
  List<dynamic> items = [];
  List<dynamic> itemList = [];
  List<dynamic> connectList = [];
  int count_unread = 0;
  late List<Tab> myTabs = <Tab>[];
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
    });
  }

  @override
  void initState() {
    getUser();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController!.addListener(_setActiveTabIndex);
    // items = notificationsList;
    myTabs = <Tab>[
      Tab(text: 'Unread(${widget.unread.length})'),
      Tab(text: 'All (${widget.data.length})'),
    ];
    super.initState();
  }

  dynamic entrepreneurData = [];

  @override
  void dispose() {
    super.dispose();
  }

  TabController? _tabController;
  var _activeTabIndex;

  @override
  Widget build(BuildContext context) {
    return _buildContent(context, widget.data);

    // return BlocBuilder<notificationsBloc, notificationsState>(
    //     builder: (BuildContext context, notificationsState state) {
    //   if (state is GetnotificationsListSuccessful) {
    //     notificationsList = state.notificationsList;
    //     notificationsList.removeWhere((item) => item['id'] == userId);
    //     // items = notificationsList;
    //     // notificationsLists =state.notificationsList;
    //     connectList = [];
    //     for (var item in notificationsList) {
    //       if (item['connect_user_id'].contains(userId) == true) {
    //         connectList.add(item);
    //       }
    //     }
    //     return _buildContent(context, notificationsList);
    //   } else {
    //     return Scaffold(
    //         appBar: AppBar(
    //           // leading: IconButton(
    //           //   onPressed: () {
    //           //     Navigator.pushReplacementNamed(context, '/home_page');
    //           //   },
    //           //   icon: const Icon(Icons.keyboard_arrow_left,size:25),
    //           // ),
    //           title: const Text(
    //             "notifications",
    //             style: TextStyle(
    //               color: kSecondaryColor,
    //             ),
    //           ),
    //           centerTitle: true,
    //           backgroundColor: kPrimaryColor,
    //           elevation: 0,
    //         ),
    //         body: const LoadingWidget());
    //   }
    // });
  }

  backtoPrevious() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: const MainScreen(
            page: AccountViewPage(),
            index: 4,
          ),
        ));
  }

  @override
  Widget _buildContent(BuildContext context, List<dynamic> notificationsList) {
    // ignore: unused_local_variable
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return WillPopScope(
      onWillPop: () async {
        return backtoPrevious();
      },
      child: Scaffold(
          body: DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                // Navigator.pop(context);
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: const MainScreen(
                      page: AccountViewPage(),
                      index: 4,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.keyboard_arrow_left, size: 30),
            ),
            title: const Text('Notifications'),
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40.0),
              child: TabBar(
                  // controller: _tabController,
                  // onTap: (index) =>
                  //     setState(() => _activeTabIndex = widget.tabIndex),
                  indicatorColor: Colors.white,
                  tabs: myTabs),
            ),
          ),
          body: Stack(
            children: [
              TabBarView(
                // controller: _tabController,
                children: <Widget>[
                  NotificationListPage(
                    data: widget.unread,
                    notificationID: widget.notificationID,
                  ),
                  NotificationListPage(
                    data: widget.data,
                    notificationID: 0,
                  ),

                  // TrainingsListPage(data: listData['trainings']),
                  // EventsListPage(data: listData['events']),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }

  // Widget _buildContent(BuildContext context, List<dynamic> notificationsList) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       // leading: IconButton(
  //       //   onPressed: () {
  //       //     Navigator.pushReplacementNamed(context, '/home_page');
  //       //   },
  //       //   icon: const Icon(Icons.keyboard_arrow_left,size:25),
  //       // ),
  //       title: const Text(
  //         "notifications",
  //         style: TextStyle(
  //           color: kSecondaryColor,
  //         ),
  //       ),
  //       centerTitle: true,
  //       backgroundColor: kPrimaryColor,
  //       elevation: 0,
  //       bottom: PreferredSize(
  //         preferredSize: const Size.fromHeight(40.0),
  //         child: Container(
  //           padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
  //           height: 50,
  //           child: TextField(
  //             autofocus: true,
  //             onChanged: (value) {
  //               filterSearchResults(value);
  //             },
  //             decoration: const InputDecoration(
  //               prefixIcon: Icon(
  //                 Icons.search,
  //                 color: kSecondaryColor,
  //               ),
  //               contentPadding: EdgeInsets.all(10.0),
  //               hintText: 'Search',
  //               hintStyle: TextStyle(color: kSecondaryColor),
  //               enabledBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(40.0)),
  //                 borderSide: BorderSide(color: kSecondaryColor, width: 1),
  //               ),
  //               focusedBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(40.0)),
  //                 borderSide: BorderSide(color: kSecondaryColor),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //     body: items.isNotEmpty
  //         ? ListView.builder(
  //             padding: const EdgeInsets.only(top: 8, bottom: 8),
  //             itemCount: items.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               return _buildnotificationsList(notificationsList[index]);
  //             })
  //         : Center(
  //             child: SizedBox(
  //               height: 600.0,
  //               child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Text("No records found!",
  //                         style:
  //                             TextStyle(color: kThirdColor.withOpacity(0.7))),
  //                   ]),
  //             ),
  //           ),
  //   );
  // }

  void _setActiveTabIndex() {
    setState(() => _activeTabIndex = _tabController!.index);
  }
}
