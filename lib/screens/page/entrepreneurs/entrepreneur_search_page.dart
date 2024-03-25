// ignore_for_file: prefer_is_empty

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/main.dart';
// import 'package:chips_choice/chips_choice.dart';
import 'package:async/async.dart';
import 'package:mlcc_app_ios/screens/page/entrepreneurs/entrepreneur_details_view.dart';
import 'package:mlcc_app_ios/screens/page/entrepreneurs/entrepreneur_search_result.dart';

class EntrepreneurSearchPage extends StatefulWidget {
  final dynamic data;
  final String? typesearch;
  const EntrepreneurSearchPage({Key? key, this.data, this.typesearch})
      : super(key: key);

  @override
  _EntrepreneurSearchPageState createState() => _EntrepreneurSearchPageState();
}

class _EntrepreneurSearchPageState extends State<EntrepreneurSearchPage> {
  int userId = 0;
  List<String> businessCategory = [];
  List<dynamic> businessCategoryList = [];
  List<dynamic> SubCategoryList = [];
  List<String> SubCategory = [];

  List<dynamic> items = [];
  List<dynamic> itemsEntrepreneurs = [];
  List<dynamic> itemList = [];
  late bool showExpired = false;

  bool connect = false;
  bool pending = false;
  bool notconnect = false;

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
      showExpired = prefs.getBool("isExpired")!;
    });
  }

  @override
  void initState() {
    if (itemsEntrepreneurs.isEmpty) {
      setState(() {
        itemsEntrepreneurs = widget.data;
      });
    }
    getUser();
    getBusinessCategory();
    getStateList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int tag = 0;

  Future<void> getBusinessCategory() async {
    businessCategoryList =
        await httpProvider.getHttp("business_category/main_listing");
    setState(() {
      for (var element in businessCategoryList) {
        businessCategory.add(element['name']);
      }
    });
  }

  List<dynamic> stateList = [];
  List<String> state = [];
  getStateList() async {
    stateList = await httpProvider.getHttp("state");
    setState(() {
      for (var element in stateList) {
        state.add(element['name']);
      }
    });
  }

  // Future<void> getSubCategory(id) async {
  //   dynamic formData = {'main_id': id};
  //   SubCategory = [];
  //   SubCategoryList =
  //       await httpProvider.postHttp("business_category/sub_listing", formData);
  //   setState(() {
  //     for (var element in SubCategoryList) {
  //       SubCategory.add(element['name']);
  //     }
  //   });
  // }

  var search = [];
  String global_query = '';
  var loading_search = true;
  void filterSearchResults(String query) async {
    final _searchformData = {};
    if (widget.typesearch == 'connected') {
      _searchformData['type'] = 'connected';
      _searchformData['user_id'] = userId;
      _searchformData['search'] = query;
    } else {
      _searchformData['search'] = query;
    }

    if (query.isNotEmpty && query != "") {
      setState(() {
        global_query = query;
      });
      search =
          await httpProvider.postHttp2("entrepreneur/search", _searchformData);
      setState(() {
        loading_search = false;
      });
    }

    print("searchitemsEntrepreneurssss${search}");
    print("searchitemsEntrepreneurssss--${_searchformData}");
    if (query.isNotEmpty && query != "") {
      List<dynamic> dummyListData = [];

      setState(() {
        items.clear();
        items.addAll(search);
      });
    } else {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: EntrepreneurSearchPage(
              data: itemsEntrepreneurs, typesearch: widget.typesearch),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            "Search Member",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
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
        body: global_query.isNotEmpty
            ? loading_search == true
                ? Center(
                    child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ))
                : items.isNotEmpty
                    ? ListView.separated(
                        itemBuilder: (context, index) {
                          return _buildEntrepreneursList(items[index]);
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: items.length,
                      )
                    : Center(
                        child: Text("No record"),
                        //   child: CircularProgressIndicator(
                        //   color: kPrimaryColor,
                        // )
                      )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey[300],
                        padding: const EdgeInsets.all(10),
                        child: const Text("Main Business Category")),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.30,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              spacing: 6.0,
                              runSpacing: 3.0,
                              children: List<Widget>.generate(
                                  businessCategory.length, (int index) {
                                return InkWell(
                                  onTap: () {
                                    print("UAUADEPAN");
                                    final data =
                                        businessCategoryList.firstWhere((e) =>
                                            e['name'] ==
                                            businessCategory[index]);
                                    print("UAUADEPAN${data}");

                                    int category_id = data['id'];
                                    print(category_id);
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.fade,
                                        child: EntrepreneurSearchResultPage(
                                            id: category_id,
                                            name: businessCategory[index],
                                            type: 'Category'),
                                      ),
                                    );
                                    // print(businessCategory[index]);
                                  },
                                  child: Chip(
                                    label: Text(businessCategory[index]),
                                    // onDeleted: () {
                                    //   setState(() {
                                    //     businessCategory.removeAt(index);
                                    //   });
                                    // },
                                  ),
                                );
                              }),
                            ),
                          ),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey[300],
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(10),
                        child: const Text("Company State")),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.40,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              spacing: 6.0,
                              runSpacing: 3.0,
                              children: List<Widget>.generate(state.length,
                                  (int index) {
                                return InkWell(
                                  onTap: () {
                                    final data = stateList.firstWhere(
                                        (e) => e['name'] == state[index]);
                                    int state_id = data['id'];
                                    print(state_id);
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.fade,
                                        child: EntrepreneurSearchResultPage(
                                            id: state_id,
                                            name: state[index],
                                            type: 'State'),
                                      ),
                                    );
                                  },
                                  child: Chip(
                                    label: Text(state[index]),
                                    // onDeleted: () {
                                    //   setState(() {
                                    //     businessCategory.removeAt(index);
                                    //   });
                                    // },
                                  ),
                                );
                              }),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildEntrepreneursList(dynamic data) {
    if (data['connect_user_id'].isNotEmpty &&
        data['connect_user_id'].contains(userId) == true) {
      connect = true;
      pending = false;
      notconnect = false;
    } else if (data['connect_pending_user_id'].isNotEmpty &&
        data['connect_pending_user_id'].contains(userId) == true) {
      connect = false;
      pending = true;
      notconnect = false;
    } else {
      connect = false;
      pending = false;
      notconnect = true;
    }

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
                      Text(
                        data['name'],
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: Theme.of(context).textTheme.bodyText1!.merge(
                            const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: kPrimaryColor)),
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
                  if (data['member_type_string'] == 'Both')
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Image.asset("assets/Ambassador.png",
                              width: 30, height: 30),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Image.asset("assets/mlcc_logo.png",
                              width: 30, height: 30),
                        )
                      ],
                    ),
                  if (data['member_type_string'] == 'Ambassador')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Image.asset("assets/Ambassador.png",
                          width: 30, height: 30),
                    ),
                  if (data['member_type_string'] == 'Consultant')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Image.asset("assets/mlcc_logo.png",
                          width: 30, height: 30),
                    )
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
}
