import 'dart:async';

import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/screens/page/training/media_view.dart';

import '../../../constant.dart';
import '../../../main.dart';

class MediaListPage extends StatefulWidget {
  final List<dynamic> training;
  const MediaListPage({Key? key, required this.training}) : super(key: key);
  @override
  _MediaListPageState createState() => _MediaListPageState();
}

class _MediaListPageState extends State<MediaListPage> {
  dynamic trainings = [];
  int userId = 0;
  List<dynamic> items = [];
  List<dynamic> allItems = [];
  List<dynamic> itemList = [];
  late bool showExpired = false;
  @override
  void initState() {
    getUser();
    getTran();
    super.initState();
  }

  getTran() async {
    if (items.isEmpty) {
      // items = widget.data;
      for (var item in widget.training) {
        var getAllTrainingDetail = await httpProvider
            .postHttp("training/info", {'training_id': item['id']});
        if (getAllTrainingDetail != null) {
          setState(() {
            if (getAllTrainingDetail['training_videos'].length > 0) {
              items.add(item);
              allItems.add(item);
            }
            // trainings = getAllTrainingDetail;
            // print(trainings);
          });
        }
      }
    }
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
      showExpired = prefs.getBool("isExpired")!;
    });
  }

  getAllTraining(trainingID) async {
    var getAllTrainingDetail = await httpProvider
        .postHttp("training/info", {'training_id': trainingID});
    if (getAllTrainingDetail != null) {
      setState(() {
        trainings = getAllTrainingDetail;
        // print(trainings);
      });
    }
  }

  void filterSearchResults(String query) {
    // List<UserInfo> dummySearchList = List();
    // dummySearchList.addAll(widget.dataUserInfo);

    if (query.isNotEmpty && query != "") {
      List<dynamic> dummyListData = [];
      for (var item in allItems) {
        if (item['title'].toLowerCase().contains(query.toLowerCase()) ||
            item['title'].toUpperCase().contains(query.toUpperCase()) ||
            item['trainer'].toLowerCase().contains(query.toLowerCase()) ||
            item['trainer'].toUpperCase().contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      }

      setState(() {
        items.clear();
        for (var item in dummyListData) {
          items.add(item);
        }
        // items.addAll(dummyListData);
      });
    } else {
      setState(() {
        items.clear();
        for (var item in allItems) {
          items.add(item);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(),
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10.0),
            child: Container(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
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
        body: widget.training.isNotEmpty
            ? GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 8.0,
                children: List.generate(items.length, (index) {
                  return Center(
                    child: _buildMediaAlbumList(items[index]),
                  );
                }))
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
              ));
  }

  _buildMediaAlbumList(training) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.all(5),
        width: 180.0,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          // color: kPrimaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        // child: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Center(
        //       child:
        //           Image.network(newsletter['thumbnail'], fit: BoxFit.fitHeight)),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Image.network(
              training['thumbnail'],
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.90,
            )),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, right: 10, left: 10),
                        child: Text(
                          training['title'],
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: kPrimaryColor),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 0, right: 10, left: 10),
                        child: Text(
                          training['caption'],
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w300,
                              color: kThirdColor),
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(flex: 1, child: Icon(Icons.more_vert)),
              ],
            ),

            // const Padding(
            //   padding: EdgeInsets.only(left: 8.0, right: 8.0),
            //   child: Divider(color: Colors.grey),
            // ),
            // Container(
            //   padding: const EdgeInsets.only(right: 5.0),
            //   child: Column(children: [
            //     Row(
            //       children: const [
            //         Padding(
            //           padding: EdgeInsets.only(
            //               left: 10, right: 10.0, top: 5, bottom: 5),
            //           child: Icon(
            //             Icons.calendar_today,
            //             color: kThirdColor,
            //             size: 11,
            //           ),
            //         ),
            //         Text(
            //           "2022.01.01",
            //           style:
            //               TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
            //         ),
            //       ],
            //     ),
            //     Row(
            //       children: const [
            //         Padding(
            //           padding: EdgeInsets.only(left: 10, right: 10.0),
            //           child: Icon(
            //             Icons.person,
            //             color: kThirdColor,
            //             size: 11,
            //           ),
            //         ),
            //         Text(
            //           "By Admin",
            //           style:
            //               TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
            //         )
            //       ],
            //     ),
            //   ]),
            // ),
          ],
        ),
      ),
      onTap: () {
        // Navigator.of(context).popUntil((route) => route.isFirst);
        getAllTraining(training['id']);
        if (userId != 0) {
          if (showExpired != true) {
            showProgress(context);
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
                    title: const Text('View Training Media '),
                    content: const Text(
                        'Need to login first only can view this training media.'),
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
        // Timer(const Duration(milliseconds: 600), () {

        // });
      },
    );
  }

  Future<void> showProgress(
    BuildContext context,
  ) async {
    var result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(getFuture(),
          message: const Text('Getting Media...')),
    );
    showResultDialog(context, result);
    // return result;
  }

  Future getFuture() {
    return Future(() async {
      await Future.delayed(const Duration(milliseconds: 600));
      return 'Submit Successfully!';
    });
  }

  void showResultDialog(
    BuildContext context,
    String result,
  ) {
    // Navigator.pop(context);
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: MediaViewPage(
          trainings: trainings,
        ),
      ),
    );
    // Navigator.pop(context);
  }
}
