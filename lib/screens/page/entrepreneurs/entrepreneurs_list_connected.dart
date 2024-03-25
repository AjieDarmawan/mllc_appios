import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:mlcc_app_ios/widget/disable_screenshots.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/screens/page/auth/login_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:mlcc_app_ios/screens/page/entrepreneurs/entrepreneur_details_view.dart';
import 'package:mlcc_app_ios/screens/page/entrepreneurs/entrepreneur_search_page.dart';

class EntrepreneursListConnectedPage extends StatefulWidget {
  final String? data;

  const EntrepreneursListConnectedPage({Key? key, this.data}) : super(key: key);

  @override
  _EntrepreneursListConnectedPageState createState() =>
      _EntrepreneursListConnectedPageState();
}

class _EntrepreneursListConnectedPageState
    extends State<EntrepreneursListConnectedPage> {
  int currentPage = 1;

  late int totalPages;
  late int tPages;
  late int cPages = 1;

  late bool result_loading = false;

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<void> clearSecureScreen() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  var userId = 0;
  List<dynamic> items = [];
  List<dynamic> itemsEntrepreneurs = [];
  List<dynamic> itemList = [];
  bool connect = false;
  bool pending = false;
  bool notconnect = false;
  late bool showExpired = false;
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
      showExpired = prefs.getBool("isExpired")!;
    });
  }

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  Future<bool> getConnected({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
    } else {
      if (currentPage >= totalPages) {
        refreshController.loadNoData();
        return false;
      }
    }

    final _connectedformData = {};
    _connectedformData['userId'] = userId;
    final response = await httpProvider.postHttp2(
        "entrepreneur/connect/listing?page=$currentPage}", {'user_id': userId});

    print("connected${response}");

    if (response != null) {
      final result = response;
      result.removeWhere((item) => item['id'] == userId);
      if (isRefresh) {
        items = result;
      } else {
        items.addAll(result);
      }

      currentPage++;

      // totalPages = result[0]['totalPages'] + 1 as int;

      //totalPages = result[0]['totalPages'];

      print("WOI${items}");
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  void filterSearchResults(String query) {
    // List<UserInfo> dummySearchList = List();
    // dummySearchList.addAll(widget.dataUserInfo);

    if (query.isNotEmpty && query != "") {
      List<dynamic> dummyListData = [];
      for (var item in itemsEntrepreneurs) {
        if (item['name'].toLowerCase().contains(query.toLowerCase()) ||
            item['preferred_name']
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            item['preferred_name']
                .toUpperCase()
                .contains(query.toUpperCase()) ||
            item['name'].toUpperCase().contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      }

      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
    } else {
      setState(() {
        items.clear();
        items.addAll(itemsEntrepreneurs);
      });
    }
  }

  @override
  void initState() {
    secureScreen();
    DisableScreenshots.disable();
    getUser();

    getConnected();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    clearSecureScreen();
    super.dispose();
  }

  Widget build(BuildContext context) {
    // print("getAllData-itemsEntrepreneurs${itemsEntrepreneurs.length}");
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // endDrawer: populateDrawer(),
        appBar: AppBar(
          leading: Container(),
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: EntrepreneurSearchPage(
                        data: itemsEntrepreneurs, typesearch: 'connected'),
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                height: 50,
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  // autofocus: true,
                  enabled: false,
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
                    disabledBorder: OutlineInputBorder(
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
        ),
        body: SmartRefresher(
            controller: refreshController,
            footer: const ClassicFooter(loadStyle: LoadStyle.ShowWhenLoading),
            // enablePullUp: true,
            // enablePullDown: true,
            //enablePullUp: true,
            onRefresh: () async {
              final result = await getConnected(isRefresh: true);
              if (result) {
                refreshController.refreshCompleted();
                setState(() {
                  result_loading = true;
                });
                print("cek_complate connected");
              } else {
                setState(() {
                  result_loading = false;
                });
                print("cek_loading connected");
                refreshController.refreshFailed();
              }
            },
            onLoading: () async {
              final result = await getConnected();
              if (result) {
                print("cek-result-1 connected${result}");
                print("cek_complate-1 connected");
                setState(() {
                  result_loading = true;
                });
                refreshController.loadComplete();
              } else {
                print("cek-result-2 connected${result}");
                print("cek_loading-2 connected");
                setState(() {
                  result_loading = true;
                });
                // refreshController.loadComplete();
                refreshController.loadFailed();
              }
            },
            child: result_loading == true
                ? items.isNotEmpty
                    ? ListView.separated(
                        itemBuilder: (context, index) {
                          return _buildEntrepreneursList(items[index]);
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: items.length,
                      )
                    : SizedBox(
                        height: 600.0,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text("Not Records Found",
                                        style: TextStyle(
                                            color:
                                                kThirdColor.withOpacity(0.7))),
                                  ),
                                ],
                              )
                            ]),
                      )
                : SizedBox(
                    height: 600.0,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: Text("",
                                    style: TextStyle(
                                        color: kThirdColor.withOpacity(0.7))),
                              ),
                            ],
                          )
                        ]),
                  )),
      ),
    );
  }

  // var entrepreneurDetailDataReturn = [];
  // void getDetails(id) async {
  //   setState(() async {
  //     entrepreneurDetailDataReturn =
  //         await httpProvider.postHttp("member/info", {'user_id': id});
  //   });
  // }

  Widget _buildEntrepreneursList(dynamic data) {
    connect = true;
    pending = false;
    notconnect = false;

    return GestureDetector(
      onTap: () {
        if (userId != 0) {
          // getDetails(data['id']);
          if (showExpired != true) {
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: EntrepreneurDetailsViewPage(
                    data: data,
                  )),
            );
          } else {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text('Notices'),
                      content: const Text(
                          'Membership period is expired. \nPlease make a payment to renew.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                          style: TextButton.styleFrom(primary: Colors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                                context, '/payment_webview_page',
                                arguments: {
                                  'userId': userId,
                                  'training': 0,
                                  'event': 0,
                                  'product': 0,
                                });
                          },
                          child: const Text('Pay'),
                          style: TextButton.styleFrom(primary: Colors.blue),
                        ),
                      ],
                    ));
          }
        } else {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text('View Member Detail'),
                    content: const Text(
                        'Need to login first only can view this member.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'OK');
                          Navigator.pushNamed(context, '/login_page');
                        },
                        child: const Text('OK'),
                        style: TextButton.styleFrom(primary: Colors.black),
                      ),
                    ],
                  ));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
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
                    child:
                        (data['thumbnail'] != null && data['thumbnail'] != "")
                            ? CachedNetworkImage(
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                imageUrl: data['thumbnail'],
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
                                'assets/mlcc_noPic.png',
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
                      Flexible(
                        child: Text(
                          data['name'],
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: Theme.of(context).textTheme.bodyText1!.merge(
                              const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: kPrimaryColor)),
                        ),
                      ),
                    ],
                  ),
                  if (data['preferred_name'] != '')
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "(" + data['preferred_name'] + ")",
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
                          data['company_name'],
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
                          data['business_category'],
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
                  // if (data['member_type_string'] == 'Both')
                  //   Row(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.only(right: 5.0),
                  //         child: Image.asset("assets/mlcc_logo.png",
                  //             width: 30, height: 30),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.only(left: 0.0),
                  //         child: Image.asset("assets/mlcc_logo.png",
                  //             width: 30, height: 30),
                  //       )
                  //     ],
                  //   ),
                  // if (data['member_type_string'] == 'Ambassador')
                  //   Padding(
                  //     padding: const EdgeInsets.only(bottom: 0.0),
                  //     child: Image.asset("assets/mlcc_logo.png",
                  //         width: 30, height: 30),
                  //   ),
                  // if (data['member_type_string'] == 'Consultant')
                  //   Padding(
                  //     padding: const EdgeInsets.only(bottom: 0.0),
                  //     child: Image.asset("assets/mlcc_logo.png",
                  //         width: 30, height: 30),
                  //   )
                ],
              ),
            ),
            if (connect == true)
              Flexible(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Connected",
                    style: const TextStyle(color: kGreenColor, fontSize: 12),
                  ),
                ),
              ),
            if (pending == true)
              Flexible(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Pending",
                    style: const TextStyle(color: korangeColor, fontSize: 12),
                  ),
                ),
              ),
            if (notconnect == true)
              Flexible(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Not Connected",
                    style: const TextStyle(color: kredColor, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Future<void> showProgress(
  //   BuildContext context,
  // ) async {
  //   var result = await showDialog(
  //     context: context,
  //     builder: (context) => FutureProgressDialog(getFuture(),
  //         message: const Text('Getting Entrepreneurs Detail...')),
  //   );
  //   showResultDialog(context, result);
  //   // return result;
  // }

  // Future getFuture() {
  //   return Future(() async {
  //     await Future.delayed(const Duration(milliseconds: 1200));
  //     return 'Submit Successfully!';
  //   });
  // }

  // void showResultDialog(
  //   BuildContext context,
  //   String result,
  // ) {
  //   // Navigator.pop(context);

  //   // Navigator.pop(context);
  // }
}
