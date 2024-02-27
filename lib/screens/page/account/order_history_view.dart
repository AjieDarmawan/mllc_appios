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
import 'package:mlcc_app_ios/screens/page/account/order_history_detail.dart';
import 'package:mlcc_app_ios/screens/page/account/referee_detail_view.dart';
import 'package:mlcc_app_ios/screens/page/account/referral_detail_view.dart';
import 'package:mlcc_app_ios/screens/page/home/connect_detail.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';
import 'package:mlcc_app_ios/screens/page/home/newsletter_view.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';

class OrderHistoryListPage extends StatefulWidget {
  final int userID;
  final int orderID;
  const OrderHistoryListPage(
      {Key? key, required this.userID, required this.orderID})
      : super(key: key);
  @override
  _OrderHistoryListPageState createState() => _OrderHistoryListPageState();
}

class _OrderHistoryListPageState extends State<OrderHistoryListPage> {
  int userId = 0;
  int run = 0;
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
    });
  }

  @override
  void initState() {
    context.read<DashboardBloc>().add(GetOrderList(widget.userID));
    getUser();
    // items = entrepreneursList;
    super.initState();
  }

  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Order Status'),
    const Tab(text: 'Commission'),
  ];
  List<dynamic> items = [];
  List<dynamic> itemList = [];
  dynamic allOrderList = [];
  bool hasData = true;
  List<dynamic> order_history = [];
  List<dynamic> referral_orders = [];
  void filterSearchResults(String query) {
    // List<UserInfo> dummySearchList = List();
    // dummySearchList.addAll(widget.dataUserInfo);
    context.read<DashboardBloc>().add(GetOrderList(widget.userID));
    if (query.isNotEmpty && query != "") {
      List<dynamic> dummyListDataorder_history = [];
      List<dynamic> dummyListDatareferral_orders = [];
      // itemList.addAll(eventsList);
      // print(allOrderList['referral'][0]);
      if (allOrderList[0]['order_history'].length > 0) {
        print(allOrderList[0]['order_history']);
        for (var item in allOrderList[0]['order_history']) {
          print(item['order_number']);
          if (item['order_number']
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              item['order_number']
                  .toUpperCase()
                  .contains(query.toUpperCase()) ||
              item['status'].toLowerCase().contains(query.toLowerCase()) ||
              item['status'].toUpperCase().contains(query.toUpperCase())) {
            dummyListDataorder_history.add(item);
          }
        }
      }

      if (allOrderList[0]['referral_orders'].length > 0) {
        for (var item in allOrderList[0]['referral_orders']) {
          print(item['order_number']);
          if (item['order_number']
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              item['order_number']
                  .toUpperCase()
                  .contains(query.toUpperCase()) ||
              item['status'].toLowerCase().contains(query.toLowerCase()) ||
              item['status'].toUpperCase().contains(query.toUpperCase())) {
            dummyListDatareferral_orders.add(item);
          }
        }
      }

      setState(() {
        items.clear();
        order_history.clear();
        referral_orders.clear();
        order_history.addAll(dummyListDataorder_history);
        referral_orders.addAll(dummyListDatareferral_orders);
        items.addAll(dummyListDatareferral_orders);
        items.addAll(dummyListDataorder_history);
        if (order_history.isNotEmpty || referral_orders.isNotEmpty) {
          hasData = false;
        }
      });
    } else {
      setState(() {
        context.read<DashboardBloc>().add(GetOrderList(widget.userID));
        items.clear();
        order_history.clear();
        referral_orders.clear();
        items.add(allOrderList);
        order_history = items[0][0]['order_history'];
        referral_orders = items[0][0]['referral_orders'];
        if (order_history.isNotEmpty || referral_orders.isNotEmpty) {
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
            index: 2,
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
                          index: 2,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.keyboard_arrow_left, size: 30),
                ),
                elevation: 0.0,
                title: const Text("Orders History",
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
                if (state is GetOrderListSuccessful) {
                  allOrderList = state.orderList;

                  if (run == 0) {
                    if (allOrderList.length > 0) {
                      if (order_history.isEmpty) {
                        order_history = allOrderList[0]['order_history'];
                      }

                      if (referral_orders.isEmpty) {
                        referral_orders = allOrderList[0]['referral_orders'];
                      }
                    }
                    run++;
                  }

                  if (widget.orderID != 0) {
                    for (var item in allOrderList[0]['order_history']) {
                      if (widget.orderID == item['id']) {
                        late Color _color;
                        if (item['status'] == 'New') {
                          _color = Colors.yellow.shade700;
                        } else if (item['status'] == 'Packing') {
                          _color = Colors.blueAccent.shade700;
                        } else if (item['status'] == 'Delivered') {
                          _color = Colors.green;
                        } else if (item['status'] == 'Delivering') {
                          _color = Colors.grey.shade700;
                        }
                        Timer(const Duration(milliseconds: 600), () {
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: OrderDetailsViewPage(
                                  data: item,
                                  status: item['status'],
                                  color: _color),
                            ),
                          );
                        });
                      }
                    }

                    for (var item in allOrderList[0]['referral_orders']) {
                      if (widget.orderID == item['id']) {
                        late Color _color;
                        if (item['status'] == 'New') {
                          _color = Colors.yellow.shade700;
                        } else if (item['status'] == 'Packing') {
                          _color = Colors.blueAccent.shade700;
                        } else if (item['status'] == 'Delivered') {
                          _color = Colors.green;
                        } else if (item['status'] == 'Delivering') {
                          _color = Colors.grey.shade700;
                        }
                        Timer(const Duration(milliseconds: 600), () {
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: OrderDetailsViewPage(
                                  data: item,
                                  status: item['status'],
                                  color: _color),
                            ),
                          );
                        });
                      }
                    }
                  }

                  // for (int i = 0; i < allOrderList.length; i++) {
                  //   if (allOrderList[i]['status'] == 'Reject') {
                  //     if (allOrderList[i]['requestor_id'] == userId) {
                  //       reject.add(allOrderList[i]);
                  //     }
                  //   } else if (allOrderList[i]['status'] == 'Pending') {
                  //     if (allOrderList[i]['connector_id'] == userId) {
                  //       approve.add(allOrderList[i]);
                  //     }
                  //   }
                  // }

                  return TabBarView(
                    // controller: _tabController,
                    children: <Widget>[
                      _buildContent(order_history, "order_history"),
                      _buildContent(referral_orders, "referral_orders"),
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

  Widget _buildContent(dynamic orderList, String type) {
    return orderList.length > 0
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: orderList.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildNewslettersList(orderList[index], type);
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

  Widget _buildNewslettersList(dynamic orderList, String type) {
    bool rejected = false;
    late Color _color;
    if (orderList['status'] == 'New') {
      _color = Colors.yellow.shade700;
    } else if (orderList['status'] == 'Packing') {
      _color = Colors.blueAccent.shade700;
    } else if (orderList['status'] == 'Delivered') {
      _color = Colors.green;
    } else if (orderList['status'] == 'Delivering') {
      _color = Colors.grey.shade700;
    }

    return Banner(
      message: orderList['status'],
      location: BannerLocation.topEnd,
      textStyle: const TextStyle(fontSize: 11),
      color: _color,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: OrderDetailsViewPage(
                  data: orderList, status: orderList['status'], color: _color),
            ),
          );
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
                      child: (orderList['thumbnail'] != null &&
                              orderList['thumbnail'] != "")
                          ? CachedNetworkImage(
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl: orderList['thumbnail'],
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
                            orderList['order_number'].toString(),
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
                            orderList['purchased_date'].toString(),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _validateInputs(connectid, status) {
  //   final _formData = {};
  //   _formData['user_id'] = userId;
  //   _formData['connect_id'] = connectid;
  //   _formData['status'] = status;

  //   Timer(const Duration(milliseconds: 600), () {
  //     showProgress(context);
  //     context.read<DashboardBloc>().add(UpdateOrderList(_formData));
  //     // Navigator.pop(context);
  //     // Navigator.pushReplacementNamed(context, '/training_details_view_page',
  //     //     arguments: {
  //     //       'data': widget.data,
  //     //       'trainingList': widget.trainingList
  //     //     });
  //   });
  // }

  // Future getFuture() {
  //   return Future(() async {
  //     await Future.delayed(const Duration(seconds: 2));
  //     return 'Submit Successfully!';
  //   });
  // }

  // Future<void> showProgress(
  //   BuildContext context,
  // ) async {
  //   var result = await showDialog(
  //     context: context,
  //     builder: (context) => FutureProgressDialog(getFuture(),
  //         message: const Text('Updating request data...')),
  //   );
  //   showResultDialog(context, result);
  //   // return result;
  // }

  // void showResultDialog(
  //   BuildContext context,
  //   String result,
  // ) {
  //   // Navigator.pop(context);

  //   Navigator.pushReplacement(
  //       context,
  //       PageTransition(
  //           type: PageTransitionType.fade,
  //           child: OrderHistoryListPage(userID: userId)));
  // }
}
