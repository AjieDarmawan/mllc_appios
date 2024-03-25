import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlcc_app_ios/screens/page/account/account_subcription.dart';
import 'package:mlcc_app_ios/screens/page/account/order_history_view.dart';
import 'package:mlcc_app_ios/screens/page/account/referral_view.dart';
import 'package:mlcc_app_ios/screens/page/entrepreneurs/entrepreneurs_list_connected.dart';
import 'package:mlcc_app_ios/screens/page/home/connect_list.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';
import 'package:mlcc_app_ios/screens/page/home/newsletter_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/entrepreneurs/entrepreneurs_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/screens/page/auth/login_page.dart';
import 'package:mlcc_app_ios/screens/page/entrepreneurs/entrepreneurs_list.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import '../../main_view.dart';
import 'entrepreneur_details_view.dart';

class EntrepreneursViewPage extends StatefulWidget {
  final dynamic data;
  const EntrepreneursViewPage({Key? key, this.data}) : super(key: key);

  @override
  _EntrepreneursViewPageState createState() => _EntrepreneursViewPageState();
}

class _EntrepreneursViewPageState extends State<EntrepreneursViewPage>
    with SingleTickerProviderStateMixin {
  List<dynamic> entrepreneursList = [];
  List<dynamic> entrepreneursLists = [];
  var userId = 0;
  List<dynamic> items = [];
  List<dynamic> itemList = [];
  List<dynamic> connectList = [];
  dynamic userInfo = [];
  List planList = [];

  late StreamSubscription<Map> streamSubscription;
  StreamController<String> controllerData = StreamController<String>();
  StreamController<String> controllerInitSession = StreamController<String>();
  Future<void> getPlan() async {
    planList = await httpProvider.getHttp("member_package");
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
      if (widget.data.length > 0) {
        setState(() {
          widget.data.removeWhere((item) => item['id'] == userId);
          // items = entrepreneursList;
          // entrepreneursLists =state.entrepreneursList;
          connectList = [];
          for (int i = 0; i < widget.data.length; i++) {
            if (widget.data[i]['connect_user_id'].contains(userId) == true) {
              connectList.add(widget.data[i]);
            }
          }
        });
      }
    });
  }

  @override
  void initState() {
    context.read<EntrepreneursBloc>().add(GetEntrepreneursList(userId));
    getUser();

    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController!.addListener(_setActiveTabIndex);
    // items = entrepreneursList;
    listenDynamicLinks();
    super.initState();
  }

  var newLetter;
  getNewsLetterInfo(id) async {
    var _formData = {'news_id': id};
    newLetter = await httpProvider.postHttp("newsletter/info", _formData);
    if (newLetter != null) {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: NewsLetterViewPage(data: newLetter),
        ),
      );
    }
  }

  void listenDynamicLinks() {
    streamSubscription = FlutterBranchSdk.initSession().listen((data) async {
      print('listenDynamicLinks - DeepLink Data: $data');
      controllerData.sink.add((data.toString()));
      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        print(data);

        if (data['type'] == 'Training') {
          Navigator.pushNamed(context, '/training_details_view_page',
              arguments: {'data': data['dataID'], 'type': 'Notification'});
        } else if (data['type'] == 'Event') {
          Navigator.pushNamed(context, '/event_details_view_page',
              arguments: {'data': data['dataID'], 'type': 'Notification'});
        } else if (data['type'] == 'Product') {
          Navigator.pushNamed(context, '/product_details_view_page',
              arguments: {'data': data['dataID'], 'type': 'Notification'});
        }
        // else if (data['type'] == 'Advertisement' ||
        //     data['type'] == 'Newsletter') {
        //   getNewsLetterInfo(data['dataID']);
        // }
        else if (data['type'] == 'Newsletter') {
          getNewsLetterInfo(data['dataID']);
        } else if (data['type'] == 'Advertisement') {
          if (data['sub_type'] == 'Voucher') {
            Navigator.pushNamed(context, '/voucher_details_view_page',
                arguments: {'data': data['dataID'], 'type': 'Notification'});
          } else {
            Navigator.pushNamed(context, '/reward_details_view_page',
                arguments: {'data': data['dataID'], 'type': 'Notification'});
          }
        } else if (data['type'] == 'Profile') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (prefs.getBool("isLoggedIn")! == true) {
            userInfo = await httpProvider.postHttp2(
                "entrepreneur/info", {'user_id': prefs.getInt("userId")!});
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: SubsciptionPlanPage(
                      data: userInfo[0], planList: planList)),
            );
          }
        }
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      print(
          'InitSession error: ${platformException.code} - ${platformException.message}');
      controllerInitSession.add(
          'InitSession error: ${platformException.code} - ${platformException.message}');
    });
  }

  dynamic entrepreneurData = [];

  @override
  void dispose() {
    context.read<EntrepreneursBloc>().add(ClearService());
    streamSubscription.cancel();
    super.dispose();
  }

  TabController? _tabController;
  var _activeTabIndex;

  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'All'),
    const Tab(text: 'Connected'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Members'),
          automaticallyImplyLeading: false,
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
          children: const [
            TabBarView(
              // controller: _tabController,
              children: <Widget>[
                EntrepreneursListPage(
                  data: '',
                  // allUser: entrepreneursList,
                ),
                EntrepreneursListConnectedPage(
                  //data: 'connect',
                  data: '',
                  // allUser: entrepreneursList,
                )
              ],
            ),
          ],
        ),
      ),
    );
    // return widget.data.length > 0
    //     ? _buildContent(context, widget.data)
    //     : BlocBuilder<EntrepreneursBloc, EntrepreneursState>(
    //         builder: (BuildContext context, EntrepreneursState state) {
    //         if (state is GetEntrepreneursListSuccessful) {
    //           entrepreneursList = state.entrepreneursList;
    //           entrepreneursList.removeWhere((item) => item['id'] == userId);
    //           // items = entrepreneursList;
    //           // entrepreneursLists =state.entrepreneursList;
    //           connectList = [];
    //           for (var item in entrepreneursList) {
    //             if (item['connect_user_id'].contains(userId) == true) {
    //               connectList.add(item);
    //             }
    //           }
    //           return _buildContent(context, entrepreneursList);
    //         } else {
    //           return Scaffold(
    //               appBar: AppBar(
    //                 // leading: IconButton(
    //                 //   onPressed: () {
    //                 //     Navigator.pushReplacementNamed(context, '/home_page');
    //                 //   },
    //                 //   icon: const Icon(Icons.keyboard_arrow_left,size:25),
    //                 // ),
    //                 title: const Text(
    //                   "Entrepreneurs",
    //                   style: TextStyle(
    //                     color: kSecondaryColor,
    //                   ),
    //                 ),
    //                 centerTitle: true,
    //                 backgroundColor: kPrimaryColor,
    //                 elevation: 0,
    //               ),
    //               body: const LoadingWidget());
    //         }
    //       });
    // return BlocBuilder<EntrepreneursBloc, EntrepreneursState>(
    //     builder: (BuildContext context, EntrepreneursState state) {
    //   if (state is GetEntrepreneursListSuccessful) {
    //     entrepreneursList = state.entrepreneursList;
    //     entrepreneursList.removeWhere((item) => item['id'] == userId);
    //     // items = entrepreneursList;
    //     // entrepreneursLists =state.entrepreneursList;
    //     connectList = [];
    //     for (var item in entrepreneursList) {
    //       if (item['connect_user_id'].contains(userId) == true) {
    //         connectList.add(item);
    //       }
    //     }
    //     return _buildContent(context, entrepreneursList);
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
    //             "Entrepreneurs",
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

  // @override
  // Widget _buildContent(BuildContext context, List<dynamic> entrepreneursList) {
  //   entrepreneursList.removeWhere((item) => item['id'] == userId);
  //   // ignore: unused_local_variable
  //   final double width = MediaQuery.of(context).size.width;
  //   final double height = MediaQuery.of(context).size.height;
  //   // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  //   return Scaffold(
  //       body: DefaultTabController(
  //     length: myTabs.length,
  //     child: Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Entrepreneurs'),
  //         backgroundColor: kPrimaryColor,
  //         centerTitle: true,
  //         bottom: PreferredSize(
  //           preferredSize: const Size.fromHeight(40.0),
  //           child: TabBar(
  //               // controller: _tabController,
  //               // onTap: (index) =>
  //               //     setState(() => _activeTabIndex = widget.tabIndex),
  //               indicatorColor: Colors.white,
  //               tabs: myTabs),
  //         ),
  //       ),
  //       body: Stack(
  //         children: [
  //           TabBarView(
  //             // controller: _tabController,
  //             children: <Widget>[
  //               if (widget.data.length > 0)
  //                 EntrepreneursListPage(
  //                   data: entrepreneursList,
  //                   allUser: widget.data,
  //                 )
  //               else
  //                 EntrepreneursListPage(
  //                   data: entrepreneursList,
  //                   allUser: entrepreneursList,
  //                 ),
  //               if (widget.data.length > 0)
  //                 EntrepreneursListPage(
  //                   data: connectList,
  //                   allUser: widget.data,
  //                 )
  //               else
  //                 EntrepreneursListPage(
  //                   data: connectList,
  //                   allUser: entrepreneursList,
  //                 )

  //               // TrainingsListPage(data: listData['trainings']),
  //               // EventsListPage(data: listData['events']),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   ));
  // }

  // Widget _buildContent(BuildContext context, List<dynamic> entrepreneursList) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       // leading: IconButton(
  //       //   onPressed: () {
  //       //     Navigator.pushReplacementNamed(context, '/home_page');
  //       //   },
  //       //   icon: const Icon(Icons.keyboard_arrow_left,size:25),
  //       // ),
  //       title: const Text(
  //         "Entrepreneurs",
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
  //               return _buildEntrepreneursList(entrepreneursList[index]);
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
