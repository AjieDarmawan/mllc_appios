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
import 'package:mlcc_app_ios/screens/page/home/connect_detail.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';
import 'package:mlcc_app_ios/screens/page/home/newsletter_view.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';

class RequestListPage extends StatefulWidget {
  final int userId;
  final int resquestID;
  const RequestListPage(
      {Key? key, required this.userId, required this.resquestID})
      : super(key: key);
  @override
  _RequestListPageState createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {
  int userId = 0;
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
    });
  }

  @override
  void initState() {
    // getUser();
    // items = entrepreneursList;

    context.read<DashboardBloc>().add(GetRequestList(widget.userId));

    super.initState();
  }

  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Pending'),
    const Tab(text: 'Rejected'),
  ];

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
                title: const Text("All Request List",
                    style: TextStyle(
                      color: kSecondaryColor,
                    )),
                centerTitle: true,
                backgroundColor: kPrimaryColor,
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
              body: BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (BuildContext context, DashboardState state) {
                if (state is GetReqestListSuccessful) {
                  var allRequestList1 = state.requestList;

                  print("connect-listi${allRequestList1}");

                  dynamic reject = [];
                  dynamic approve = [];
                  if (allRequestList1.length > 0) {
                    for (int i = 0; i < allRequestList1.length; i++) {
                      if (allRequestList1[i]['status'] == 'Reject') {
                        if (allRequestList1[i]['connector_id'] ==
                            widget.userId) {
                          reject.add(allRequestList1[i]);
                        }
                      }

                      if (allRequestList1[i]['status'] == 'Pending') {
                        if (allRequestList1[i]['connector_id'] ==
                            widget.userId) {
                          approve.add(allRequestList1[i]);
                        }
                      }

                      if (widget.resquestID != 0) {
                        if (allRequestList1[i]['id'] == widget.resquestID) {
                          if (allRequestList1[i]['status'] == 'Reject') {
                            if (allRequestList1[i]['connector_id'] ==
                                widget.userId) {
                              Timer(const Duration(milliseconds: 1000), () {
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: ConnectDetailsViewPage(
                                        data: allRequestList1[i],
                                        status: 'Reject'),
                                  ),
                                );
                              });
                            }
                          } else if (allRequestList1[i]['status'] ==
                              'Pending') {
                            if (allRequestList1[i]['connector_id'] ==
                                widget.userId) {
                              Timer(const Duration(milliseconds: 1000), () {
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: ConnectDetailsViewPage(
                                      data: allRequestList1[i],
                                    ),
                                  ),
                                );
                              });
                            }
                          } else if (allRequestList1[i]['status'] ==
                              'Approve') {
                            if (allRequestList1[i]['requestor_id'] ==
                                widget.userId) {
                              Timer(const Duration(milliseconds: 1000), () {
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: ConnectDetailsViewPage(
                                      data: allRequestList1[i],
                                    ),
                                  ),
                                );
                              });
                            }
                          }
                        }
                      }
                    }
                  }

                  return TabBarView(
                    // controller: _tabController,
                    children: <Widget>[
                      _buildContent(approve),
                      _buildContent(reject),
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

  Widget _buildContent(dynamic requestList) {
    return requestList.length > 0
        ? SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: requestList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildNewslettersList(requestList[index]);
                  }),
            ),
          )
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

  Widget _buildNewslettersList(dynamic requestList) {
    bool rejected = false;
    if (requestList['status'] == 'Reject') {
      rejected = true;
    }

    return InkWell(
      onTap: () {
        if (rejected == false) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: ConnectDetailsViewPage(data: requestList),
            ),
          );
        } else if (rejected == true) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child:
                  ConnectDetailsViewPage(data: requestList, status: 'Reject'),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
            if (rejected == false)
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
            if (rejected == false)
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
                            requestList['company_name'].toString(),
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
                            "Request at :\n" +
                                requestList['request_connect_at'].toString(),
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
            if (rejected == false)
              Flexible(
                flex: 1,
                child: Column(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        _validateInputs(requestList['id'], 'Approve');
                      },
                      color: Colors.green,
                      textColor: Colors.white,
                      child: const Icon(
                        Icons.done,
                        size: 20,
                      ),
                      padding: const EdgeInsets.all(8),
                      shape: const CircleBorder(),
                    ),
                    MaterialButton(
                      onPressed: () {
                        _validateInputs(requestList['id'], 'Reject');
                      },
                      color: Colors.red,
                      textColor: Colors.white,
                      child: const Icon(
                        Icons.close,
                        size: 20,
                      ),
                      padding: const EdgeInsets.all(8),
                      shape: const CircleBorder(),
                    ),
                  ],
                ),
              ),
            if (rejected == true)
              Stack(
                children: <Widget>[
                  SizedBox(
                    width: 75,
                    height: 75,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: (requestList['connector_thumbnail'] != null &&
                              requestList['connector_thumbnail'] != "")
                          ? CachedNetworkImage(
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl: requestList['connector_thumbnail'],
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
            if (rejected == true)
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
                            requestList['company_name'].toString(),
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
                            "Request at :\n" +
                                requestList['request_connect_at'].toString(),
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
    );
  }

  void _validateInputs(connectid, status) {
    final _formData = {};
    _formData['user_id'] = widget.userId;
    _formData['connect_id'] = connectid;
    _formData['status'] = status;

    print("requestconnect${_formData}");

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
          child: RequestListPage(userId: widget.userId, resquestID: 0)),
    );
  }
}
