import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:html/parser.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/dashboard/dashboard_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/account/account_view.dart';
import 'package:mlcc_app_ios/screens/page/account/referee_detail_view.dart';
import 'package:mlcc_app_ios/screens/page/account/referral_detail_view.dart';
import 'package:mlcc_app_ios/screens/page/home/connect_detail.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';
import 'package:mlcc_app_ios/screens/page/home/newsletter_view.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';

class ReferralRequestListPage extends StatefulWidget {
  final int userID;
  final int referralID;
  const ReferralRequestListPage(
      {Key? key, required this.userID, required this.referralID})
      : super(key: key);
  @override
  _ReferralRequestListPageState createState() =>
      _ReferralRequestListPageState();
}

class _ReferralRequestListPageState extends State<ReferralRequestListPage> {
  int userId = 0;
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
    });
  }

  @override
  void initState() {
    context.read<DashboardBloc>().add(GetRefferalList(widget.userID));

    getUser();

    // items = entrepreneursList;
    super.initState();
  }

  final List<Tab> myTabs = <Tab>[
    // const Tab(text: 'Referee '),
    // const Tab(text: 'Referral'),

    const Tab(text: 'Referral Received '),
    const Tab(text: 'Referral Giving'),
  ];
  List<dynamic> items = [];
  List<dynamic> itemList = [];
  dynamic allRequestList = [];
  bool hasData = true;
  int run = 0;
  List<dynamic> refferal = [];
  List<dynamic> referree = [];
  void filterSearchResults(String query) {
    // List<UserInfo> dummySearchList = List();
    // dummySearchList.addAll(widget.dataUserInfo);
    context.read<DashboardBloc>().add(GetRefferalList(widget.userID));
    if (query.isNotEmpty && query != "") {
      List<dynamic> dummyListDatarefferal = [];
      List<dynamic> dummyListDatareferree = [];
      // itemList.addAll(eventsList);
      // print(allRequestList['referral'][0]);
      if (allRequestList['referral'].length > 0) {
        print(allRequestList['referral']);
        for (var item in allRequestList['referral']) {
          print(item['name']);
          if (item['name'].toLowerCase().contains(query.toLowerCase()) ||
              item['name'].toUpperCase().contains(query.toUpperCase()) ||
              item['status'].toLowerCase().contains(query.toLowerCase()) ||
              item['status'].toUpperCase().contains(query.toUpperCase())) {
            dummyListDatarefferal.add(item);
          }
        }
      }

      if (allRequestList['referree'].length > 0) {
        for (var item in allRequestList['referree']) {
          print(item['name']);
          if (item['name'].toLowerCase().contains(query.toLowerCase()) ||
              item['name'].toUpperCase().contains(query.toUpperCase()) ||
              item['status'].toLowerCase().contains(query.toLowerCase()) ||
              item['status'].toUpperCase().contains(query.toUpperCase())) {
            dummyListDatareferree.add(item);
          }
        }
      }

      setState(() {
        items.clear();
        refferal.clear();
        referree.clear();
        refferal.addAll(dummyListDatarefferal);
        referree.addAll(dummyListDatareferree);
        items.addAll(dummyListDatareferree);
        items.addAll(dummyListDatarefferal);
        if (refferal.isNotEmpty || referree.isNotEmpty) {
          hasData = true;
        }
      });
    } else {
      setState(() {
        context.read<DashboardBloc>().add(GetRefferalList(userId));
        items.clear();
        refferal.clear();
        referree.clear();
        items.add(allRequestList);
        refferal = items[0]['referral'];
        referree = items[0]['referree'];
        if (refferal.isNotEmpty || referree.isNotEmpty) {
          hasData = true;
        }
      });
    }
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: myTabs.length,
      child: WillPopScope(
        onWillPop: () async {
          return backtoPrevious();
        },
        child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Scaffold(
              appBar: AppBar(
                // bottomOpacity: 4.0,
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
                elevation: 0.0,
                title: const Text("Referral Lists",
                    style: TextStyle(
                      color: kSecondaryColor,
                    )),
                centerTitle: true,
                backgroundColor: kPrimaryColor,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(100.0),
                  child: Column(
                    children: [
                      TabBar(
                          // controller: _tabController,
                          // onTap: (index) =>
                          //     setState(() => _activeTabIndex = widget.tabIndex),
                          indicatorColor: Colors.white,
                          tabs: myTabs),
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 8.0),
                        height: 50,
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          // autofocus: true,
                          cursorColor: kSecondaryColor,
                          onChanged: (value) {
                            filterSearchResults(value);
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: kSecondaryColor,
                            ),
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: 'Search',
                            hintStyle: TextStyle(color: kSecondaryColor),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0)),
                              borderSide:
                                  BorderSide(color: kSecondaryColor, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0)),
                              borderSide: BorderSide(color: kSecondaryColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (BuildContext context, DashboardState state) {
                if (state is GetRefferalListSuccessful) {
                  allRequestList = state.refferalList;
                  if (run == 0) {
                    if (allRequestList.length > 0) {
                      if (refferal.isEmpty) {
                        refferal = allRequestList['referral'];
                      }

                      if (referree.isEmpty) {
                        referree = allRequestList['referree'];
                      }
                    }
                    run++;
                  }

                  if (widget.referralID != 0) {
                    for (var item in allRequestList['referral']) {
                      if (widget.referralID == item['id']) {
                        Timer(const Duration(milliseconds: 1000), () {
                          setState(() {
                            run = 0;
                          });

                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: ReferralDetailViewPage(data: item),
                            ),
                          );
                        });
                      }
                    }
                    for (var item in allRequestList['referree']) {
                      if (widget.referralID == item['id']) {
                        Timer(const Duration(milliseconds: 1000), () {
                          setState(() {
                            run = 0;
                          });
                          0;
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: ReferralDetailViewPage(data: item),
                            ),
                          );
                        });
                      }
                    }
                  }

                  // for (int i = 0; i < allRequestList.length; i++) {
                  //   if (allRequestList[i]['status'] == 'Reject') {
                  //     if (allRequestList[i]['requestor_id'] == userId) {
                  //       reject.add(allRequestList[i]);
                  //     }
                  //   } else if (allRequestList[i]['status'] == 'Pending') {
                  //     if (allRequestList[i]['connector_id'] == userId) {
                  //       approve.add(allRequestList[i]);
                  //     }
                  //   }
                  // }

                  return TabBarView(
                    // controller: _tabController,
                    children: <Widget>[
                      _buildContent(referree, "referree"),
                      _buildContent(refferal, "referral"),
                    ],
                  );
                } else {
                  return const LoadingWidget();
                }
              }),
            )),
      ),
    );
  }

  Widget _buildContent(dynamic requestList, String type) {
    return requestList.length > 0
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: requestList.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildNewslettersList(requestList[index], type);
            })
        : Center(
            child: SizedBox(
              height: 600.0,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("No records found!",
                            style:
                                TextStyle(color: kThirdColor.withOpacity(0.7))),
                      ],
                    )
                  ]),
            ),
          );
  }

  Widget _buildNewslettersList(dynamic requestList, String type) {
    bool rejected = false;
    late Color _color;
    if (requestList['status'] == 'In Progress') {
      _color = Colors.yellow.shade700;
    } else if (requestList['status'] == 'Contacted') {
      _color = Colors.blueAccent.shade700;
    } else if (requestList['status'] == 'Deal On') {
      _color = Colors.green;
    } else if (requestList['status'] == 'Deal Off') {
      _color = Colors.grey.shade700;
    }

    return Banner(
      message: requestList['status'],
      location: BannerLocation.topEnd,
      textStyle: const TextStyle(fontSize: 11),
      color: _color,
      child: InkWell(
        onTap: () {
          if (type == 'referree') {
            setState(() {
              run = 0;
            });
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: RefereeDetailsViewPage(
                    data: requestList,
                    status: requestList['status'],
                    color: _color),
              ),
            );
          } else if (type == 'referral') {
            setState(() {
              run = 0;
            });
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: ReferralDetailViewPage(data: requestList),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: rejected == true ? Colors.red.shade50 : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: kThirdColor.withOpacity(0.3),
                blurRadius: 10,
              ),
            ],
            border: Border.all(color: kPrimaryColor.withOpacity(0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  SizedBox(
                    width: 75,
                    height: 75,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: (requestList['thumbnail'] != null &&
                              requestList['thumbnail'] != "")
                          ? CachedNetworkImage(
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl: requestList['thumbnail'],
                              placeholder: (context, url) => Image.asset(
                                'assets/loading.gif',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 140,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error_outline),
                            )
                          : Image.asset(
                              'assets/mlcc_logo.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 140,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 3,
                    right: 3,
                    width: 12,
                    height: 12,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 15),
              Flexible(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            requestList['name'].toString(),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: Theme.of(context).textTheme.bodyText1!.merge(
                                const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: kPrimaryColor)),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            requestList['email'].toString(),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: Theme.of(context).textTheme.bodyText1!.merge(
                                TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: kThirdColor.withOpacity(0.8))),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            requestList['contact'],
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: Theme.of(context).textTheme.bodyText1!.merge(
                                TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: kThirdColor.withOpacity(0.8))),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateInputs(connectid, status) {
    final _formData = {};
    _formData['user_id'] = userId;
    _formData['connect_id'] = connectid;
    _formData['status'] = status;

    Timer(const Duration(milliseconds: 600), () {
      showProgress(context);
      context.read<DashboardBloc>().add(UpdateRequestList(_formData));
      // Navigator.pop(context);
      // Navigator.pushReplacementNamed(context, '/training_details_view_page',
      //     arguments: {
      //       'data': widget.data,
      //       'trainingList': widget.trainingList
      //     });
    });
  }

  Future getFuture() {
    return Future(() async {
      await Future.delayed(const Duration(seconds: 2));
      return 'Submit Successfully!';
    });
  }

  Future<void> showProgress(
    BuildContext context,
  ) async {
    var result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(getFuture(),
          message: const Text('Updating request data...')),
    );
    showResultDialog(context, result);
    // return result;
  }

  void showResultDialog(
    BuildContext context,
    String result,
  ) {
    // Navigator.pop(context);

    Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: ReferralRequestListPage(
              userID: userId,
              referralID: 0,
            )));
  }
}
