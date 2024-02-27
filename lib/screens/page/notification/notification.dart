import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/account/account_view.dart';
import 'package:mlcc_app_ios/screens/page/account/order_history_view.dart';
import 'package:mlcc_app_ios/screens/page/account/referral_view.dart';
import 'package:mlcc_app_ios/screens/page/entrepreneurs/entrepreneur_details_view.dart';
import 'package:mlcc_app_ios/screens/page/home/newsletter_view.dart';
import 'package:mlcc_app_ios/screens/page/notification/notification_list.dart';

class NotificationListPage extends StatefulWidget {
  final dynamic data;
  final dynamic allUser;
  final int notificationID;
  const NotificationListPage(
      {Key? key, this.data, this.allUser, required this.notificationID})
      : super(key: key);

  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  var userId = 0;
  List<dynamic> items = [];
  List<dynamic> itemList = [];
  bool connect = false;
  bool status = false;
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
    });
  }

  void filterSearchResults(String query) {
    // List<UserInfo> dummySearchList = List();
    // dummySearchList.addAll(widget.dataUserInfo);

    if (query.isNotEmpty && query != "") {
      List<dynamic> dummyListData = [];
      widget.data.forEach((item) {
        if (item['title'].toLowerCase().contains(query.toLowerCase()) ||
            item['type'].toLowerCase().contains(query.toLowerCase()) ||
            item['type'].toUpperCase().contains(query.toUpperCase()) ||
            item['title'].toUpperCase().contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      });

      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
    } else {
      setState(() {
        items.clear();
        items.addAll(widget.data);
      });
    }
  }

  @override
  void initState() {
    getUser();

    // context.read<EntrepreneursBloc>().add(const GetEntrepreneursList());
    // _tabController = TabController(vsync: this, length: myTabs.length);
    // _tabController!.addListener(_setActiveTabIndex);
    if (items.isEmpty) {
      items.addAll(widget.data);
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
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
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  borderSide: BorderSide(color: kSecondaryColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  borderSide: BorderSide(color: kSecondaryColor),
                ),
              ),
            ),
          ),
        ),
      ),
      body: widget.data.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildNotificationList(items[index]);
              })
          : Center(
              child: SizedBox(
                height: 600.0,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("No records found!",
                          style:
                              TextStyle(color: kThirdColor.withOpacity(0.7))),
                    ]),
              ),
            ),
    );
  }

  var newLetter;
  getNewsLetterInfo(id) async {
    var _formData = {'news_id': id};
    newLetter = await httpProvider.postHttp("newsletter/info", _formData);
  }

  notificationSpecifyPage(
      data, notification, notificationItem, notificationList) async {
    if (widget.notificationID != 0) {
      if (widget.notificationID == data['object_id']) {
        final _formData = {};
        _formData['user_id'] = userId;
        _formData['notification_id'] = data['id'];
        var updateStatusData = await httpProvider.postHttp(
            "notification/update_status", _formData);
        if (data['type'] == 'Newsletter') {
          getNewsLetterInfo(data['object_id']);
        }
        if (updateStatusData == 'Success') {
          setState(() {
            status = true;
          });
          showProgress(context);
          notification =
              await httpProvider.postHttp("notification/listing", _formData);
          if (notification.isNotEmpty) {
            setState(() {
              for (var item in notification) {
                if (item['type'] != 'Entrepreneurs') {
                  if (item['status'] == 0) {
                    notificationItem.add(item);
                  }
                  notificationList.add(item);
                }
              }
            });
          }
          Timer(const Duration(milliseconds: 600), () {
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
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: NotificationPage(
                      data: notificationList,
                      unread: notificationItem,
                      notificationID: 0)),
            );
            if (data['type'] == 'Advertisement') {
              if (data['sub_type'] == 'Voucher') {
                Navigator.pushNamed(context, '/voucher_details_view_page',
                    arguments: {
                      'data': data['object_id'],
                      'type': 'Notification'
                    });
              } else {
                Navigator.pushNamed(context, '/reward_details_view_page',
                    arguments: {
                      'data': data['object_id'],
                      'type': 'Notification'
                    });
              }
            } else if (data['type'] == 'Training') {
              Navigator.pushNamed(context, '/training_details_view_page',
                  arguments: {
                    'data': data['object_id'],
                    'type': 'Notification'
                  });
            } else if (data['type'] == 'Event') {
              Navigator.pushNamed(context, '/event_details_view_page',
                  arguments: {
                    'data': data['object_id'],
                    'type': 'Notification'
                  });
            } else if (data['type'] == 'Newsletter') {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: NewsLetterViewPage(data: newLetter),
                ),
              );
            } else if (data['type'] == 'Referral') {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: ReferralRequestListPage(
                    userID: userId,
                    referralID: 0,
                  ),
                ),
              );
            } else if (data['type'] == 'Order') {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: OrderHistoryListPage(userID: userId, orderID: 0),
                ),
              );
            } else if (data['type'] == 'Product') {
              Navigator.pushNamed(context, '/product_details_view_page',
                  arguments: {
                    'data': data['object_id'],
                    'type': 'Notification'
                  });
            }
          });
        }
      }
    }
  }

  Widget _buildNotificationList(dynamic data) {
    getUser();
    dynamic notificationList = [];
    dynamic notificationItem = [];
    dynamic notification = [];
    if (data['status'] != 1) {
      status = false;
    } else {
      status = true;
    }
    // Timer(const Duration(milliseconds: 2000), () {
    //   if (data['type'] == 'Newsletter') {
    //     getNewsLetterInfo(data['object_id']);
    //   }
    // });
    if (widget.notificationID != 0) {
      notificationSpecifyPage(
          data, notification, notificationItem, notificationList);
    }
    return GestureDetector(
      onTap: () async {
        final _formData = {};
        _formData['user_id'] = userId;
        _formData['notification_id'] = data['id'];
        var updateStatusData = await httpProvider.postHttp(
            "notification/update_status", _formData);
        if (data['type'] == 'Newsletter') {
          getNewsLetterInfo(data['object_id']);
        }
        if (updateStatusData == 'Success') {
          setState(() {
            status = true;
          });
          showProgress(context);
          notification =
              await httpProvider.postHttp("notification/listing", _formData);
          if (notification.isNotEmpty) {
            setState(() {
              for (var item in notification) {
                if (item['type'] != 'Entrepreneurs') {
                  if (item['status'] == 0) {
                    notificationItem.add(item);
                  }
                  notificationList.add(item);
                }
              }
            });
          }

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
          Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: NotificationPage(
                    data: notificationList,
                    unread: notificationItem,
                    notificationID: 0)),
          );
          if (data['type'] == 'Advertisement') {
            if (data['sub_type'] == 'Voucher') {
              Navigator.pushNamed(context, '/voucher_details_view_page',
                  arguments: {
                    'data': data['object_id'],
                    'type': 'Notification'
                  });
            } else {
              Navigator.pushNamed(context, '/reward_details_view_page',
                  arguments: {
                    'data': data['object_id'],
                    'type': 'Notification'
                  });
            }
          } else if (data['type'] == 'Training') {
            Navigator.pushNamed(context, '/training_details_view_page',
                arguments: {'data': data['object_id'], 'type': 'Notification'});
          } else if (data['type'] == 'Event') {
            Navigator.pushNamed(context, '/event_details_view_page',
                arguments: {'data': data['object_id'], 'type': 'Notification'});
          } else if (data['type'] == 'Newsletter') {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: NewsLetterViewPage(data: newLetter),
              ),
            );
          } else if (data['type'] == 'Referral') {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: ReferralRequestListPage(
                  userID: userId,
                  referralID: 0,
                ),
              ),
            );
          } else if (data['type'] == 'Order') {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: OrderHistoryListPage(userID: userId, orderID: 0),
              ),
            );
          } else if (data['type'] == 'Product') {
            Navigator.pushReplacementNamed(
                context, '/product_details_view_page',
                arguments: {'data': data['object_id'], 'type': 'Notification'});
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: status == false ? Colors.white : Colors.grey[300],
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
                      child: status == false
                          ? const Icon(Icons.markunread,
                              size: 50, color: kPrimaryColor)
                          : const Icon(Icons.mark_email_read,
                              size: 50, color: kPrimaryColor)),
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
                          data['title'],
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
                          data['body'],
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
                          data['type'],
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: Theme.of(context).textTheme.bodyText1!.merge(
                              TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.red.shade300)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            // if (connect == true)
            //   Flexible(
            //     flex: 2,
            //     child: Image.asset("assets/hand.gif"),
            //   )
          ],
        ),
      ),
    );
  }

  Future<void> showProgress(
    BuildContext context,
  ) async {
    var result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(getFuture(),
          message: const Text('Please wait...')),
    );
    showResultDialog(context, result);
    // return result;
  }

  Future getFuture() {
    return Future(() async {
      await Future.delayed(const Duration(seconds: 1));
      return 'Submit Successfully!';
    });
  }

  void showResultDialog(
    BuildContext context,
    String result,
  ) {
    // Navigator.pop(context);
    // Navigator.push(
    //   context,
    //   PageTransition(
    //     type: PageTransitionType.fade,
    //     child: MediaViewPage(
    //       trainings: trainings,
    //     ),
    //   ),
    // );
    // Navigator.pop(context);
  }
}
