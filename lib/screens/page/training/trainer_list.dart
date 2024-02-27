import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:html/parser.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/trainings/trainings_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';

class AllTrainerListPage extends StatefulWidget {
  final dynamic data;

  const AllTrainerListPage({Key? key, this.data}) : super(key: key);

  @override
  _AllTrainerListPageState createState() => _AllTrainerListPageState();
}

class _AllTrainerListPageState extends State<AllTrainerListPage> {
  String deviceID = '';
  int userId = 0;
  bool follow = false;
  List<dynamic> items = [];
  List<dynamic> itemList = [];
  late bool showExpired = false;
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
      showExpired = prefs.getBool("isExpired")!;
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
    if (items.isEmpty) {
      // items = widget.data;
      for (var item in widget.data) {
        items.add(item);
      }
    }
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  void filterSearchResults(String query) {
    // List<UserInfo> dummySearchList = List();
    // dummySearchList.addAll(widget.dataUserInfo);

    if (query.isNotEmpty && query != "") {
      List<dynamic> dummyListData = [];
      widget.data.forEach((item) {
        if (item['name'].toLowerCase().contains(query.toLowerCase()) ||
            item['name'].toUpperCase().contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      });

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
        for (var item in widget.data) {
          items.add(item);
        }
      });
    }
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
        body: widget.data.isNotEmpty
            ? ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildTrainersList(items[index]);
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
              ));
  }

  Widget _buildTrainersList(data) {
    if (data['wished_user_id'].isNotEmpty &&
        data['wished_user_id'].contains(userId) == true) {
      follow = true;
    } else {
      follow = false;
    }

    if (userId == 0) {
      if (data['wished_device_id'].isNotEmpty &&
          data['wished_device_id'].contains(deviceID) == true) {
        follow = true;
      } else {
        follow = false;
      }
    }
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/trainings_view_page',
            arguments: {'data': data});
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
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data['name'],
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
                          _parseHtmlString(data['description']),
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
                          data['category'],
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
            Flexible(
                flex: 1,
                child: MaterialButton(
                  onPressed: () {
                    if (userId != 0) {
                      if (showExpired != true) {
                        _validateInputs(data['id']);
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
                                      style: TextButton.styleFrom(
                                          primary: Colors.black),
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
                                      style: TextButton.styleFrom(
                                          primary: Colors.blue),
                                    ),
                                  ],
                                ));
                      }
                    } else {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Follow Trainer'),
                                content: const Text(
                                    'Need to login first only can follow this trainer.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'OK');
                                      Navigator.pushNamed(
                                          context, '/login_page');
                                    },
                                    child: const Text('OK'),
                                    style: TextButton.styleFrom(
                                        primary: Colors.black),
                                  ),
                                ],
                              ));
                    }
                  },
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: follow == false ? kPrimaryColor : Colors.grey,
                  child: follow == true
                      ? const Text("Following",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: kSecondaryColor, fontSize: 10))
                      : const Text("Follow",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: kSecondaryColor, fontSize: 10)),
                ))
          ],
        ),
      ),
    );
  }

  void _validateInputs(trainer_id) {
    final _formData = {};
    if (userId != 0) {
      _formData['user_id'] = userId;
      _formData['device_id'] = '';
    } else {
      _formData['user_id'] = '';
      _formData['device_id'] = deviceID;
    }
    _formData['trainer_id'] = trainer_id;

    Timer(const Duration(milliseconds: 600), () {
      showProgress(context);
      context.read<TrainingsBloc>().add(UpdateFavoriteTrainer(_formData));
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
      await Future.delayed(const Duration(seconds: 1));
      return 'Submit Successfully!';
    });
  }

  Future<void> showProgress(
    BuildContext context,
  ) async {
    var result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(getFuture(),
          message: const Text('Following...')),
    );
    showResultDialog(context, result);
    // return result;
  }

  void showResultDialog(
    BuildContext context,
    String result,
  ) {
    // Navigator.pop(context);
    Navigator.pushNamed(context, '/trainers_view_page');
  }
}
