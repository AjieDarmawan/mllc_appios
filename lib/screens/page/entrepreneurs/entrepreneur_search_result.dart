// ignore_for_file: prefer_is_empty

import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/main.dart';
// import 'package:chips_choice/chips_choice.dart';
import 'package:async/async.dart';
import 'package:mlcc_app_ios/screens/page/entrepreneurs/entrepreneur_details_view.dart';
import 'package:mlcc_app_ios/screens/page/entrepreneurs/entrepreneur_search_page.dart';
import 'package:mlcc_app_ios/widget/block_button_widget.dart';
import 'package:mlcc_app_ios/widget/text_field_widget.dart';

class EntrepreneurSearchResultPage extends StatefulWidget {
  final int id;
  final String name;
  final String type;
  const EntrepreneurSearchResultPage(
      {Key? key, required this.id, required this.name, required this.type})
      : super(key: key);

  @override
  _EntrepreneurSearchResultPageState createState() =>
      _EntrepreneurSearchResultPageState();
}

class _EntrepreneurSearchResultPageState
    extends State<EntrepreneurSearchResultPage> {
  int userId = 0;
  List<String> businessCategory = [];
  List<dynamic> businessCategoryList = [];
  List<String> isSelected_Main_Category = [];
  List<String> isSelected_Main_Category_id = [];
  List<dynamic> SubCategoryList = [];
  List<String> SubCategory = [];
  List<String> isSelected_Category = [];
  List<String> isSelected_Category_id = [];
  List<int> items_id = [];
  List<dynamic> items = [];
  List<dynamic> itemsEntrepreneurs = [];
  List<dynamic> itemList = [];
  bool showSubCategory = true;

  bool connect = false;
  bool pending = false;
  bool notconnect = false;

  final TextEditingController _yearFrom = TextEditingController();
  final TextEditingController _yearTo = TextEditingController();

  // bool isSelected_Category = false;

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
    getStateList();
    getUser();
    // if (itemsEntrepreneurs.isEmpty) {
    //   setState(() {
    //     itemsEntrepreneurs = widget.data;
    //   });
    // }
    getMainBusinessCategory();
    if (widget.type == "Category") {
      getBusinessCategory(widget.id);
      getAllCategoryData();
      getAllStateData();
    } else if (widget.type == "State") {
      getAllStateData();
      showSubCategory = false;
    }

    super.initState();
  }

  clearAll() {
    setState(() {
      items.clear();
      itemsEntrepreneurs.clear();
      businessCategory.clear();
      businessCategoryList.clear();
      isSelected_Main_Category.clear();
      isSelected_Main_Category_id.clear();
      SubCategory.clear();
      SubCategoryList.clear();
      isSelected_Category.clear();
      isSelected_Category_id.clear();
      items_id.clear();
      stateList.clear();
      state.clear();
      isSelected_State.clear();
      isSelected_State_id.clear();
      isSelected_member_id.clear();
      isSelected_member = ["false", "false", "false"];
      getMainBusinessCategory();
      getStateList();
      if (widget.type == "Category") {
        getBusinessCategory(widget.id);
        getAllCategoryData();
      } else if (widget.type == "State") {
        getAllStateData();
        showSubCategory = false;
      }

      _yearFrom.text = "";
      _yearTo.text = "";
    });
  }

  getAllCategoryData() async {
    final _formData = {};
    _formData['main_business_category_id'] = widget.id;
    final response =
        await httpProvider.postHttp2("entrepreneur/filter", _formData);
    if (response != null) {
      response.removeWhere((item) => item['id'] == userId);
      setState(() {
        itemsEntrepreneurs.addAll(response);

        items.addAll(response);
      });
    }
  }

  getAllStateData() async {
    final _formData = {};
    _formData['company_state_id'] = widget.id;
    final response =
        await httpProvider.postHttp2("entrepreneur/filter", _formData);
    if (response != null) {
      response.removeWhere((item) => item['id'] == userId);
      setState(() {
        itemsEntrepreneurs.addAll(response);

        items.addAll(response);
      });
    }
  }

  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
  }

  int tag = 0;

  Future<void> getBusinessCategory(id) async {
    dynamic formData = {'main_id': id};
    SubCategory = [];
    SubCategoryList =
        await httpProvider.postHttp("business_category/sub_listing", formData);
    setState(() {
      for (var element in SubCategoryList) {
        SubCategory.add(element['name']);
        isSelected_Category.add("false");
      }
    });
  }

  List<dynamic> stateList = [];
  List<String> state = [];
  List<String> isSelected_State = [];
  List<String> isSelected_State_id = [];

  List<String> member_type = ['Ambassador', 'Consultant', 'Both'];
  List<String> isSelected_member = ["false", "false", "false"];
  List<String> isSelected_member_id = [];

  Future<void> getMainBusinessCategory() async {
    businessCategoryList =
        await httpProvider.getHttp("business_category/main_listing");
    setState(() {
      for (var element in businessCategoryList) {
        businessCategory.add(element['name']);
        isSelected_Main_Category.add("false");
      }
    });
  }

  getStateList() async {
    stateList = await httpProvider.getHttp("state");
    setState(() {
      for (var element in stateList) {
        state.add(element['name']);
        isSelected_State.add("false");
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
            item['company_name'].toLowerCase().contains(query.toLowerCase()) ||
            item['business_category']
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            item['sub_business_category']
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            item['member_type_string']
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            item['company_state'].toLowerCase().contains(query.toLowerCase()) ||
            item['establish_year']
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            item['business_nature']
                .toUpperCase()
                .contains(query.toUpperCase()) ||
            item['name'].toUpperCase().contains(query.toUpperCase()) ||
            item['preferred_name']
                .toUpperCase()
                .contains(query.toUpperCase()) ||
            item['company_name'].toUpperCase().contains(query.toUpperCase()) ||
            item['business_category']
                .toUpperCase()
                .contains(query.toUpperCase()) ||
            item['sub_business_category']
                .toUpperCase()
                .contains(query.toUpperCase()) ||
            item['member_type_string']
                .toUpperCase()
                .contains(query.toUpperCase()) ||
            item['company_state'].toUpperCase().contains(query.toUpperCase()) ||
            item['establish_year']
                .toUpperCase()
                .contains(query.toUpperCase()) ||
            item['business_nature']
                .toUpperCase()
                .contains(query.toUpperCase())) {
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

  populateDrawer() {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.white),
      child: Drawer(
          child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                      top: 50, left: 15, right: 15, bottom: 5),
                  color: kPrimaryColor,
                  child: const Text('Search Filter',
                      style: TextStyle(fontSize: 17, color: kSecondaryColor))),
              const Padding(
                padding:
                    EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
                child: Text('Establish Year',
                    style: TextStyle(
                      fontSize: 13,
                    )),
              ),
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _yearFrom,
                          decoration: InputDecoration(
                            labelText: "From",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          onChanged: (value) {
                            setState(() {
                              items.clear();
                              items_id.clear();
                              if (value.length > 0) {
                                if (value.length == 4) {
                                  if (_yearTo.text.length == 4) {
                                    for (var i in itemsEntrepreneurs) {
                                      if (int.parse(i['establish_year']) >=
                                              int.parse(value) &&
                                          int.parse(i['establish_year']) <=
                                              int.parse(_yearTo.text)) {
                                        items.add(i);
                                      }
                                    }
                                  } else {
                                    for (var i in itemsEntrepreneurs) {
                                      if (i['establish_year'] == value) {
                                        items.add(i);
                                      }
                                    }
                                  }
                                }
                              } else {
                                items.addAll(itemsEntrepreneurs);
                              }
                            });
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4),
                          ],
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                    ),
                    const Text("-"),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _yearTo,
                          decoration: InputDecoration(
                            labelText: "To",
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          onChanged: (value) {
                            setState(() {
                              items.clear();
                              items_id.clear();
                              if (value.length > 0) {
                                if (value.length == 4) {
                                  if (_yearFrom.text.length > 3) {
                                    for (var i in itemsEntrepreneurs) {
                                      if (int.parse(i['establish_year']) <=
                                              int.parse(value) &&
                                          int.parse(i['establish_year']) >=
                                              int.parse(_yearFrom.text)) {
                                        items.add(i);
                                      }
                                    }
                                  } else {
                                    for (var i in itemsEntrepreneurs) {
                                      if (i['establish_year'] == value) {
                                        items.add(i);
                                      }
                                    }
                                  }
                                }
                              } else {
                                items.addAll(itemsEntrepreneurs);
                              }
                            });
                          },
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4),
                          ],
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: kThirdColor),
              const Padding(
                padding:
                    EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
                child: Text('Main Business Category',
                    style: TextStyle(
                      fontSize: 13,
                    )),
              ),
              if (widget.type == "State")
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 6.0,
                          runSpacing: 3.0,
                          children: List<Widget>.generate(
                              businessCategoryList.length, (int index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  if (isSelected_Main_Category[index] ==
                                      "false") {
                                    isSelected_Main_Category_id.clear();
                                    isSelected_Main_Category.clear();
                                    SubCategory.clear();
                                    SubCategoryList.clear();
                                    isSelected_Category.clear();
                                    isSelected_Category_id.clear();
                                    for (var i in businessCategoryList) {
                                      isSelected_Main_Category.add("false");
                                    }
                                    final data =
                                        businessCategoryList.firstWhere((e) =>
                                            e['name'] ==
                                            businessCategory[index]);
                                    int category_id = data['id'];
                                    getBusinessCategory(category_id);
                                    isSelected_Main_Category[index] = "true";
                                    isSelected_Main_Category_id
                                        .add(businessCategory[index]);
                                    showSubCategory = true;
                                  } else {
                                    isSelected_Main_Category_id.clear();
                                    isSelected_Main_Category.clear();
                                    for (var i in businessCategoryList) {
                                      isSelected_Main_Category.add("false");
                                    }
                                    isSelected_Main_Category[index] = "false";
                                    isSelected_Main_Category_id.removeWhere(
                                        (item) =>
                                            item == businessCategory[index]);
                                    showSubCategory = false;
                                  }
                                  items.clear();
                                  items_id.clear();
                                  if (isSelected_State_id.isEmpty &&
                                      isSelected_Category_id.isEmpty &&
                                      isSelected_member_id.isEmpty &&
                                      isSelected_Main_Category_id.isEmpty) {
                                    items.addAll(itemsEntrepreneurs);
                                  } else if (isSelected_Main_Category_id
                                      .isEmpty) {
                                    for (var i in itemsEntrepreneurs) {
                                      if (isSelected_State_id.isEmpty &&
                                          isSelected_member_id.isEmpty &&
                                          isSelected_Category_id.isEmpty) {
                                        items_id.add(i['id']);
                                        items_id =
                                            LinkedHashSet<int>.from(items_id)
                                                .toList();
                                      } else {
                                        if (isSelected_State_id.isNotEmpty) {
                                          for (var j in isSelected_State_id) {
                                            if (i['company_state'] == j) {
                                              if (isSelected_Category_id
                                                  .isNotEmpty) {
                                                for (var j
                                                    in isSelected_Category_id) {
                                                  if (i['sub_business_category'] ==
                                                      j) {
                                                    if (isSelected_member_id
                                                        .isNotEmpty) {
                                                      for (var j
                                                          in isSelected_member_id) {
                                                        if (i['member_type_string'] ==
                                                            j) {
                                                          items_id.add(i['id']);
                                                          items_id = LinkedHashSet<
                                                                      int>.from(
                                                                  items_id)
                                                              .toList();
                                                        }
                                                      }
                                                    } else {
                                                      items_id.add(i['id']);
                                                      items_id = LinkedHashSet<
                                                                  int>.from(
                                                              items_id)
                                                          .toList();
                                                    }
                                                  }
                                                }
                                              } else {
                                                items_id.add(i['id']);
                                                items_id =
                                                    LinkedHashSet<int>.from(
                                                            items_id)
                                                        .toList();
                                                print(items_id);
                                              }
                                            }
                                          }
                                        }

                                        if (isSelected_Category_id.isNotEmpty) {
                                          for (var j in isSelected_State_id) {
                                            if (i['sub_business_category'] ==
                                                j) {
                                              if (isSelected_State_id
                                                  .isNotEmpty) {
                                                for (var j
                                                    in isSelected_State_id) {
                                                  if (i['company_state'] == j) {
                                                    if (isSelected_member_id
                                                        .isNotEmpty) {
                                                      for (var j
                                                          in isSelected_member_id) {
                                                        if (i['member_type_string'] ==
                                                            j) {
                                                          items_id.add(i['id']);
                                                          items_id = LinkedHashSet<
                                                                      int>.from(
                                                                  items_id)
                                                              .toList();
                                                        }
                                                      }
                                                    } else {
                                                      items_id.add(i['id']);
                                                      items_id = LinkedHashSet<
                                                                  int>.from(
                                                              items_id)
                                                          .toList();
                                                    }
                                                  }
                                                }
                                              } else {
                                                items_id.add(i['id']);
                                                items_id =
                                                    LinkedHashSet<int>.from(
                                                            items_id)
                                                        .toList();
                                                print(items_id);
                                              }
                                            }
                                          }
                                        }

                                        if (isSelected_member_id.isNotEmpty) {
                                          for (var j in isSelected_member_id) {
                                            if (i['member_type_string'] == j) {
                                              if (isSelected_Category_id
                                                  .isNotEmpty) {
                                                for (var j
                                                    in isSelected_Category_id) {
                                                  if (i['sub_business_category'] ==
                                                      j) {
                                                    if (isSelected_State_id
                                                        .isNotEmpty) {
                                                      for (var j
                                                          in isSelected_State_id) {
                                                        if (i['company_state'] ==
                                                            j) {
                                                          items_id.add(i['id']);
                                                          items_id = LinkedHashSet<
                                                                      int>.from(
                                                                  items_id)
                                                              .toList();
                                                        }
                                                      }
                                                    } else {
                                                      items_id.add(i['id']);
                                                      items_id = LinkedHashSet<
                                                                  int>.from(
                                                              items_id)
                                                          .toList();
                                                    }
                                                  }
                                                }
                                              } else {
                                                items_id.add(i['id']);
                                                items_id =
                                                    LinkedHashSet<int>.from(
                                                            items_id)
                                                        .toList();
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                    if (items_id.isNotEmpty) {
                                      for (var i in itemsEntrepreneurs) {
                                        for (var j in items_id) {
                                          if (i['id'] == j) {
                                            if (_yearFrom.text.length > 0 &&
                                                _yearTo.text.length > 0) {
                                              if (int.parse(i[
                                                          'establish_year']) >=
                                                      int.parse(
                                                          _yearFrom.text) &&
                                                  int.parse(i[
                                                          'establish_year']) <=
                                                      int.parse(_yearTo.text)) {
                                                items.add(i);
                                              }
                                            } else if (_yearFrom.text.length >
                                                    3 &&
                                                _yearTo.text.length == 0) {
                                              if (int.parse(
                                                      i['establish_year']) >=
                                                  int.parse(_yearFrom.text)) {
                                                items.add(i);
                                              }
                                            } else if (_yearFrom.text.length ==
                                                    0 &&
                                                _yearTo.text.length > 3) {
                                              if (int.parse(
                                                      i['establish_year']) <=
                                                  int.parse(_yearTo.text)) {
                                                items.add(i);
                                              }
                                            } else {
                                              items.add(i);
                                            }
                                          }
                                        }
                                      }
                                    }
                                  } else {
                                    for (var i in itemsEntrepreneurs) {
                                      if (isSelected_Main_Category_id
                                          .isNotEmpty) {
                                        for (var j
                                            in isSelected_Main_Category_id) {
                                          if (i['business_category'] == j) {
                                            if (isSelected_State_id.isEmpty &&
                                                isSelected_Category_id
                                                    .isEmpty &&
                                                isSelected_member_id.isEmpty) {
                                              items_id.add(i['id']);
                                              items_id =
                                                  LinkedHashSet<int>.from(
                                                          items_id)
                                                      .toList();
                                            } else {
                                              if (isSelected_State_id
                                                  .isNotEmpty) {
                                                for (var j
                                                    in isSelected_State_id) {
                                                  if (i['company_state'] == j) {
                                                    if (isSelected_Category_id
                                                        .isNotEmpty) {
                                                      for (var j
                                                          in isSelected_Category_id) {
                                                        if (i['sub_business_category'] ==
                                                            j) {
                                                          if (isSelected_member_id
                                                              .isNotEmpty) {
                                                            for (var j
                                                                in isSelected_member_id) {
                                                              if (i['member_type_string'] ==
                                                                  j) {
                                                                items_id.add(
                                                                    i['id']);
                                                                items_id = LinkedHashSet<
                                                                            int>.from(
                                                                        items_id)
                                                                    .toList();
                                                              }
                                                            }
                                                          } else {
                                                            items_id
                                                                .add(i['id']);
                                                            items_id = LinkedHashSet<
                                                                        int>.from(
                                                                    items_id)
                                                                .toList();
                                                          }
                                                        }
                                                      }
                                                    } else {
                                                      items_id.add(i['id']);
                                                      items_id = LinkedHashSet<
                                                                  int>.from(
                                                              items_id)
                                                          .toList();
                                                      print(items_id);
                                                    }
                                                  }
                                                }
                                              }

                                              if (isSelected_Category_id
                                                  .isNotEmpty) {
                                                for (var j
                                                    in isSelected_State_id) {
                                                  if (i['sub_business_category'] ==
                                                      j) {
                                                    if (isSelected_State_id
                                                        .isNotEmpty) {
                                                      for (var j
                                                          in isSelected_State_id) {
                                                        if (i['company_state'] ==
                                                            j) {
                                                          if (isSelected_member_id
                                                              .isNotEmpty) {
                                                            for (var j
                                                                in isSelected_member_id) {
                                                              if (i['member_type_string'] ==
                                                                  j) {
                                                                items_id.add(
                                                                    i['id']);
                                                                items_id = LinkedHashSet<
                                                                            int>.from(
                                                                        items_id)
                                                                    .toList();
                                                              }
                                                            }
                                                          } else {
                                                            items_id
                                                                .add(i['id']);
                                                            items_id = LinkedHashSet<
                                                                        int>.from(
                                                                    items_id)
                                                                .toList();
                                                          }
                                                        }
                                                      }
                                                    } else {
                                                      items_id.add(i['id']);
                                                      items_id = LinkedHashSet<
                                                                  int>.from(
                                                              items_id)
                                                          .toList();
                                                      print(items_id);
                                                    }
                                                  }
                                                }
                                              }

                                              if (isSelected_member_id
                                                  .isNotEmpty) {
                                                for (var j
                                                    in isSelected_member_id) {
                                                  if (i['member_type_string'] ==
                                                      j) {
                                                    if (isSelected_Category_id
                                                        .isNotEmpty) {
                                                      for (var j
                                                          in isSelected_Category_id) {
                                                        if (i['sub_business_category'] ==
                                                            j) {
                                                          if (isSelected_State_id
                                                              .isNotEmpty) {
                                                            for (var j
                                                                in isSelected_State_id) {
                                                              if (i['company_state'] ==
                                                                  j) {
                                                                items_id.add(
                                                                    i['id']);
                                                                items_id = LinkedHashSet<
                                                                            int>.from(
                                                                        items_id)
                                                                    .toList();
                                                              }
                                                            }
                                                          } else {
                                                            items_id
                                                                .add(i['id']);
                                                            items_id = LinkedHashSet<
                                                                        int>.from(
                                                                    items_id)
                                                                .toList();
                                                          }
                                                        }
                                                      }
                                                    } else {
                                                      items_id.add(i['id']);
                                                      items_id = LinkedHashSet<
                                                                  int>.from(
                                                              items_id)
                                                          .toList();
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                    if (items_id.isNotEmpty) {
                                      for (var i in itemsEntrepreneurs) {
                                        for (var j in items_id) {
                                          if (i['id'] == j) {
                                            if (_yearFrom.text.length > 0 &&
                                                _yearTo.text.length > 0) {
                                              if (int.parse(i[
                                                          'establish_year']) >=
                                                      int.parse(
                                                          _yearFrom.text) &&
                                                  int.parse(i[
                                                          'establish_year']) <=
                                                      int.parse(_yearTo.text)) {
                                                items.add(i);
                                              }
                                            } else if (_yearFrom.text.length >
                                                    3 &&
                                                _yearTo.text.length == 0) {
                                              if (int.parse(
                                                      i['establish_year']) >=
                                                  int.parse(_yearFrom.text)) {
                                                items.add(i);
                                              }
                                            } else if (_yearFrom.text.length ==
                                                    0 &&
                                                _yearTo.text.length > 3) {
                                              if (int.parse(
                                                      i['establish_year']) <=
                                                  int.parse(_yearTo.text)) {
                                                items.add(i);
                                              }
                                            } else {
                                              items.add(i);
                                            }

                                            // items.add(i);
                                          }
                                        }
                                      }
                                    }
                                  }
                                  print(isSelected_Category_id);
                                });
                              },
                              child: Chip(
                                backgroundColor:
                                    isSelected_Main_Category[index] == "true"
                                        ? Colors.blue[100]
                                        : Colors.grey[300],
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
              if (widget.type == "Category")
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 6.0,
                        runSpacing: 3.0,
                        children: List<Widget>.generate(1, (int index) {
                          return InkWell(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   PageTransition(
                              //     type: PageTransitionType.fade,
                              //     child: EntrepreneurSearchResultPage(
                              //         id: sub_cat_id,
                              //         name: state[index],
                              //         type: 'State'),
                              //   ),
                              // );
                            },
                            child: Chip(
                              backgroundColor: Colors.blue[100],
                              label: Text(widget.name),
                              // onDeleted: () {
                              //   setState(() {
                              //     businessCategory.removeAt(index);
                              //   });
                              // },
                            ),
                          );
                        }),
                      ),
                    )),
              if (widget.type == "Category") const Divider(color: kThirdColor),
              if (showSubCategory == true)
                const Padding(
                  padding:
                      EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
                  child: Text('Sub Business Category',
                      style: TextStyle(
                        fontSize: 13,
                      )),
                ),
              if (showSubCategory == true)
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 6.0,
                          runSpacing: 3.0,
                          children: List<Widget>.generate(SubCategory.length,
                              (int index) {
                            return InkWell(
                              onTap: () {
                                final data = SubCategoryList.firstWhere(
                                    (e) => e['name'] == SubCategory[index]);
                                int sub_cat_id = data['id'];
                                print(sub_cat_id);
                                setState(() {
                                  if (isSelected_Category[index] == "false") {
                                    isSelected_Category[index] = "true";
                                    isSelected_Category_id
                                        .add(SubCategory[index]);
                                  } else {
                                    isSelected_Category[index] = "false";
                                    isSelected_Category_id.removeWhere(
                                        (item) => item == SubCategory[index]);
                                  }
                                  items.clear();
                                  items_id.clear();
                                  if (isSelected_State_id.isEmpty &&
                                      isSelected_Category_id.isEmpty &&
                                      isSelected_member_id.isEmpty &&
                                      isSelected_Main_Category_id.isEmpty) {
                                    items.addAll(itemsEntrepreneurs);
                                  } else if (isSelected_Category_id.isEmpty) {
                                    for (var i in itemsEntrepreneurs) {
                                      if (isSelected_State_id.isEmpty &&
                                          isSelected_member_id.isEmpty &&
                                          isSelected_Main_Category_id.isEmpty) {
                                        items_id.add(i['id']);
                                        items_id =
                                            LinkedHashSet<int>.from(items_id)
                                                .toList();
                                      } else {
                                        if (isSelected_State_id.isNotEmpty) {
                                          for (var j in isSelected_State_id) {
                                            if (i['company_state'] == j) {
                                              if (isSelected_Category_id
                                                  .isNotEmpty) {
                                                for (var j
                                                    in isSelected_Category_id) {
                                                  if (i['sub_business_category'] ==
                                                      j) {
                                                    if (isSelected_member_id
                                                        .isNotEmpty) {
                                                      for (var j
                                                          in isSelected_member_id) {
                                                        if (i['member_type_string'] ==
                                                            j) {
                                                          items_id.add(i['id']);
                                                          items_id = LinkedHashSet<
                                                                      int>.from(
                                                                  items_id)
                                                              .toList();
                                                        }
                                                      }
                                                    } else {
                                                      items_id.add(i['id']);
                                                      items_id = LinkedHashSet<
                                                                  int>.from(
                                                              items_id)
                                                          .toList();
                                                    }
                                                  }
                                                }
                                              } else {
                                                items_id.add(i['id']);
                                                items_id =
                                                    LinkedHashSet<int>.from(
                                                            items_id)
                                                        .toList();
                                                print(items_id);
                                              }
                                            }
                                          }
                                        }

                                        if (isSelected_Main_Category_id
                                            .isNotEmpty) {
                                          for (var j
                                              in isSelected_Main_Category_id) {
                                            if (i['business_category'] == j) {
                                              if (isSelected_State_id
                                                  .isNotEmpty) {
                                                for (var j
                                                    in isSelected_State_id) {
                                                  if (i['company_state'] == j) {
                                                    if (isSelected_member_id
                                                        .isNotEmpty) {
                                                      for (var j
                                                          in isSelected_member_id) {
                                                        if (i['member_type_string'] ==
                                                            j) {
                                                          items_id.add(i['id']);
                                                          items_id = LinkedHashSet<
                                                                      int>.from(
                                                                  items_id)
                                                              .toList();
                                                        }
                                                      }
                                                    } else {
                                                      items_id.add(i['id']);
                                                      items_id = LinkedHashSet<
                                                                  int>.from(
                                                              items_id)
                                                          .toList();
                                                    }
                                                  }
                                                }
                                              } else {
                                                items_id.add(i['id']);
                                                items_id =
                                                    LinkedHashSet<int>.from(
                                                            items_id)
                                                        .toList();
                                                print(items_id);
                                              }
                                            }
                                          }
                                        }

                                        if (isSelected_member_id.isNotEmpty) {
                                          for (var j in isSelected_member_id) {
                                            if (i['member_type_string'] == j) {
                                              if (isSelected_Category_id
                                                  .isNotEmpty) {
                                                for (var j
                                                    in isSelected_Category_id) {
                                                  if (i['sub_business_category'] ==
                                                      j) {
                                                    if (isSelected_State_id
                                                        .isNotEmpty) {
                                                      for (var j
                                                          in isSelected_State_id) {
                                                        if (i['company_state'] ==
                                                            j) {
                                                          items_id.add(i['id']);
                                                          items_id = LinkedHashSet<
                                                                      int>.from(
                                                                  items_id)
                                                              .toList();
                                                        }
                                                      }
                                                    } else {
                                                      items_id.add(i['id']);
                                                      items_id = LinkedHashSet<
                                                                  int>.from(
                                                              items_id)
                                                          .toList();
                                                    }
                                                  }
                                                }
                                              } else {
                                                items_id.add(i['id']);
                                                items_id =
                                                    LinkedHashSet<int>.from(
                                                            items_id)
                                                        .toList();
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                    if (items_id.isNotEmpty) {
                                      for (var i in itemsEntrepreneurs) {
                                        for (var j in items_id) {
                                          if (i['id'] == j) {
                                            if (_yearFrom.text.length > 0 &&
                                                _yearTo.text.length > 0) {
                                              if (int.parse(i[
                                                          'establish_year']) >=
                                                      int.parse(
                                                          _yearFrom.text) &&
                                                  int.parse(i[
                                                          'establish_year']) <=
                                                      int.parse(_yearTo.text)) {
                                                items.add(i);
                                              }
                                            } else if (_yearFrom.text.length >
                                                    3 &&
                                                _yearTo.text.length == 0) {
                                              if (int.parse(
                                                      i['establish_year']) >=
                                                  int.parse(_yearFrom.text)) {
                                                items.add(i);
                                              }
                                            } else if (_yearFrom.text.length ==
                                                    0 &&
                                                _yearTo.text.length > 3) {
                                              if (int.parse(
                                                      i['establish_year']) <=
                                                  int.parse(_yearTo.text)) {
                                                items.add(i);
                                              }
                                            } else {
                                              items.add(i);
                                            }
                                          }
                                        }
                                      }
                                    }
                                  } else {
                                    for (var i in itemsEntrepreneurs) {
                                      if (isSelected_Category_id.isNotEmpty) {
                                        for (var j in isSelected_Category_id) {
                                          if (i['sub_business_category'] == j) {
                                            if (isSelected_State_id.isEmpty &&
                                                isSelected_member_id.isEmpty) {
                                              items_id.add(i['id']);
                                              items_id =
                                                  LinkedHashSet<int>.from(
                                                          items_id)
                                                      .toList();
                                            } else {
                                              if (isSelected_State_id
                                                  .isNotEmpty) {
                                                for (var j
                                                    in isSelected_State_id) {
                                                  if (i['company_state'] == j) {
                                                    if (isSelected_member_id
                                                        .isNotEmpty) {
                                                      for (var j
                                                          in isSelected_member_id) {
                                                        if (i['member_type_string'] ==
                                                            j) {
                                                          items_id.add(i['id']);
                                                          items_id = LinkedHashSet<
                                                                      int>.from(
                                                                  items_id)
                                                              .toList();
                                                        }
                                                      }
                                                    } else {
                                                      items_id.add(i['id']);
                                                      items_id = LinkedHashSet<
                                                                  int>.from(
                                                              items_id)
                                                          .toList();
                                                    }
                                                  }
                                                }
                                              }
                                              if (isSelected_member_id
                                                  .isNotEmpty) {
                                                for (var j
                                                    in isSelected_member_id) {
                                                  if (i['member_type_string'] ==
                                                      j) {
                                                    if (isSelected_State_id
                                                        .isNotEmpty) {
                                                      for (var j
                                                          in isSelected_State_id) {
                                                        if (i['company_state'] ==
                                                            j) {
                                                          items_id.add(i['id']);
                                                          items_id = LinkedHashSet<
                                                                      int>.from(
                                                                  items_id)
                                                              .toList();
                                                        }
                                                      }
                                                    } else {
                                                      items_id.add(i['id']);
                                                      items_id = LinkedHashSet<
                                                                  int>.from(
                                                              items_id)
                                                          .toList();
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                    if (items_id.isNotEmpty) {
                                      for (var i in itemsEntrepreneurs) {
                                        for (var j in items_id) {
                                          if (i['id'] == j) {
                                            if (_yearFrom.text.length > 0 &&
                                                _yearTo.text.length > 0) {
                                              if (int.parse(i[
                                                          'establish_year']) >=
                                                      int.parse(
                                                          _yearFrom.text) &&
                                                  int.parse(i[
                                                          'establish_year']) <=
                                                      int.parse(_yearTo.text)) {
                                                items.add(i);
                                              }
                                            } else if (_yearFrom.text.length >
                                                    3 &&
                                                _yearTo.text.length == 0) {
                                              if (int.parse(
                                                      i['establish_year']) >=
                                                  int.parse(_yearFrom.text)) {
                                                items.add(i);
                                              }
                                            } else if (_yearFrom.text.length ==
                                                    0 &&
                                                _yearTo.text.length > 3) {
                                              if (int.parse(
                                                      i['establish_year']) <=
                                                  int.parse(_yearTo.text)) {
                                                items.add(i);
                                              }
                                            } else {
                                              items.add(i);
                                            }

                                            // items.add(i);
                                          }
                                        }
                                      }
                                    }
                                  }
                                  print(isSelected_Category_id);
                                });
                                // Navigator.push(
                                //   context,
                                //   PageTransition(
                                //     type: PageTransitionType.fade,
                                //     child: EntrepreneurSearchResultPage(
                                //         id: sub_cat_id,
                                //         name: state[index],
                                //         type: 'State'),
                                //   ),
                                // );
                              },
                              child: Chip(
                                backgroundColor:
                                    isSelected_Category[index] == "true"
                                        ? Colors.blue[100]
                                        : Colors.grey[300],
                                label: Text(SubCategory[index]),
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
              if (showSubCategory == true) const Divider(color: kThirdColor),
              const Padding(
                padding:
                    EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
                child: Text('Company State',
                    style: TextStyle(
                      fontSize: 13,
                    )),
              ),
              if (widget.type == "Category")
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.16,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 6.0,
                          runSpacing: 3.0,
                          children:
                              List<Widget>.generate(state.length, (int index) {
                            return InkWell(
                              onTap: () {
                                final data = stateList.firstWhere(
                                    (e) => e['name'] == state[index]);
                                int sub_cat_id = data['id'];
                                print(sub_cat_id);
                                setState(() {
                                  if (isSelected_State[index] == "false") {
                                    isSelected_State[index] = "true";
                                    isSelected_State_id.add(state[index]);
                                  } else {
                                    isSelected_State[index] = "false";
                                    isSelected_State_id.removeWhere(
                                        (item) => item == state[index]);
                                  }
                                  print(isSelected_State_id);
                                });
                                items.clear();
                                items_id.clear();
                                if (isSelected_State_id.isEmpty &&
                                    isSelected_Category_id.isEmpty &&
                                    isSelected_member_id.isEmpty) {
                                  items.addAll(itemsEntrepreneurs);
                                } else if (isSelected_State_id.isEmpty) {
                                  for (var i in itemsEntrepreneurs) {
                                    if (isSelected_Category_id.isEmpty &&
                                        isSelected_member_id.isEmpty) {
                                      items_id.add(i['id']);
                                      items_id =
                                          LinkedHashSet<int>.from(items_id)
                                              .toList();
                                    } else {
                                      if (isSelected_Category_id.isNotEmpty) {
                                        for (var j in isSelected_Category_id) {
                                          if (i['sub_business_category'] == j) {
                                            if (isSelected_member_id
                                                .isNotEmpty) {
                                              for (var j
                                                  in isSelected_member_id) {
                                                if (i['member_type_string'] ==
                                                    j) {
                                                  items_id.add(i['id']);
                                                  items_id =
                                                      LinkedHashSet<int>.from(
                                                              items_id)
                                                          .toList();
                                                }
                                              }
                                            } else {
                                              items_id.add(i['id']);
                                              items_id =
                                                  LinkedHashSet<int>.from(
                                                          items_id)
                                                      .toList();
                                            }
                                          }
                                        }
                                      }
                                      if (isSelected_member_id.isNotEmpty) {
                                        for (var j in isSelected_member_id) {
                                          if (i['member_type_string'] == j) {
                                            if (isSelected_Category_id
                                                .isNotEmpty) {
                                              for (var j
                                                  in isSelected_Category_id) {
                                                if (i['sub_business_category'] ==
                                                    j) {
                                                  items_id.add(i['id']);
                                                  items_id =
                                                      LinkedHashSet<int>.from(
                                                              items_id)
                                                          .toList();
                                                }
                                              }
                                            } else {
                                              items_id.add(i['id']);
                                              items_id =
                                                  LinkedHashSet<int>.from(
                                                          items_id)
                                                      .toList();
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                  if (items_id.isNotEmpty) {
                                    for (var i in itemsEntrepreneurs) {
                                      for (var j in items_id) {
                                        if (i['id'] == j) {
                                          if (_yearFrom.text.length > 0 &&
                                              _yearTo.text.length > 0) {
                                            if (int.parse(
                                                        i['establish_year']) >=
                                                    int.parse(_yearFrom.text) &&
                                                int.parse(
                                                        i['establish_year']) <=
                                                    int.parse(_yearTo.text)) {
                                              items.add(i);
                                            }
                                          } else if (_yearFrom.text.length >
                                                  3 &&
                                              _yearTo.text.length == 0) {
                                            if (int.parse(
                                                    i['establish_year']) >=
                                                int.parse(_yearFrom.text)) {
                                              items.add(i);
                                            }
                                          } else if (_yearFrom.text.length ==
                                                  0 &&
                                              _yearTo.text.length > 3) {
                                            if (int.parse(
                                                    i['establish_year']) <=
                                                int.parse(_yearTo.text)) {
                                              items.add(i);
                                            }
                                          } else {
                                            items.add(i);
                                          }
                                        }
                                      }
                                    }
                                  }
                                } else {
                                  for (var i in itemsEntrepreneurs) {
                                    if (isSelected_State_id.isNotEmpty) {
                                      for (var j in isSelected_State_id) {
                                        if (i['company_state'] == j) {
                                          if (isSelected_Category_id.isEmpty &&
                                              isSelected_member_id.isEmpty) {
                                            items_id.add(i['id']);
                                            items_id = LinkedHashSet<int>.from(
                                                    items_id)
                                                .toList();
                                          } else {
                                            if (isSelected_Category_id
                                                .isNotEmpty) {
                                              for (var j
                                                  in isSelected_Category_id) {
                                                if (i['sub_business_category'] ==
                                                    j) {
                                                  if (isSelected_member_id
                                                      .isNotEmpty) {
                                                    for (var j
                                                        in isSelected_member_id) {
                                                      if (i['member_type_string'] ==
                                                          j) {
                                                        items_id.add(i['id']);
                                                        items_id = LinkedHashSet<
                                                                    int>.from(
                                                                items_id)
                                                            .toList();
                                                      }
                                                    }
                                                  } else {
                                                    items_id.add(i['id']);
                                                    items_id =
                                                        LinkedHashSet<int>.from(
                                                                items_id)
                                                            .toList();
                                                  }
                                                }
                                              }
                                            }
                                            if (isSelected_member_id
                                                .isNotEmpty) {
                                              for (var j
                                                  in isSelected_member_id) {
                                                if (i['member_type_string'] ==
                                                    j) {
                                                  if (isSelected_Category_id
                                                      .isNotEmpty) {
                                                    for (var j
                                                        in isSelected_Category_id) {
                                                      if (i['sub_business_category'] ==
                                                          j) {
                                                        items_id.add(i['id']);
                                                        items_id = LinkedHashSet<
                                                                    int>.from(
                                                                items_id)
                                                            .toList();
                                                      }
                                                    }
                                                  } else {
                                                    items_id.add(i['id']);
                                                    items_id =
                                                        LinkedHashSet<int>.from(
                                                                items_id)
                                                            .toList();
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                  for (var i in itemsEntrepreneurs) {
                                    for (var j in items_id) {
                                      if (i['id'] == j) {
                                        if (_yearFrom.text.length > 0 &&
                                            _yearTo.text.length > 0) {
                                          if (int.parse(i['establish_year']) >=
                                                  int.parse(_yearFrom.text) &&
                                              int.parse(i['establish_year']) <=
                                                  int.parse(_yearTo.text)) {
                                            items.add(i);
                                          }
                                        } else if (_yearFrom.text.length > 3 &&
                                            _yearTo.text.length == 0) {
                                          if (int.parse(i['establish_year']) >=
                                              int.parse(_yearFrom.text)) {
                                            items.add(i);
                                          }
                                        } else if (_yearFrom.text.length == 0 &&
                                            _yearTo.text.length > 3) {
                                          if (int.parse(i['establish_year']) <=
                                              int.parse(_yearTo.text)) {
                                            items.add(i);
                                          }
                                        } else {
                                          items.add(i);
                                        }
                                      }
                                    }
                                  }
                                }
                                print(isSelected_Category_id);
                              },
                              child: Chip(
                                backgroundColor:
                                    isSelected_State[index] == "true"
                                        ? Colors.blue[100]
                                        : Colors.grey[300],
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
              if (widget.type == "State")
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 6.0,
                          runSpacing: 3.0,
                          children: List<Widget>.generate(1, (int index) {
                            return InkWell(
                              child: Chip(
                                backgroundColor: Colors.blue[100],
                                label: Text(widget.name),
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
              const Divider(color: kThirdColor),
              const Padding(
                padding:
                    EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
                child: Text('Member Type',
                    style: TextStyle(
                      fontSize: 13,
                    )),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        spacing: 6.0,
                        runSpacing: 3.0,
                        children: List<Widget>.generate(member_type.length,
                            (int index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (isSelected_member[index] == "false") {
                                  isSelected_member[index] = "true";
                                  isSelected_member_id.add(member_type[index]);
                                } else {
                                  isSelected_member[index] = "false";
                                  isSelected_member_id.removeWhere(
                                      (item) => item == member_type[index]);
                                }
                                items.clear();
                                items_id.clear();
                                if (isSelected_State_id.isEmpty &&
                                    isSelected_Category_id.isEmpty &&
                                    isSelected_member_id.isEmpty &&
                                    isSelected_Main_Category_id.isEmpty) {
                                  items.addAll(itemsEntrepreneurs);
                                } else if (isSelected_member_id.isEmpty) {
                                  for (var i in itemsEntrepreneurs) {
                                    if (isSelected_Category_id.isEmpty &&
                                        isSelected_State_id.isEmpty &&
                                        isSelected_Main_Category_id.isEmpty) {
                                      items_id.add(i['id']);
                                      items_id =
                                          LinkedHashSet<int>.from(items_id)
                                              .toList();
                                    } else {
                                      if (isSelected_Category_id.isNotEmpty) {
                                        for (var j in isSelected_Category_id) {
                                          if (i['sub_business_category'] == j) {
                                            if (isSelected_Main_Category_id
                                                .isNotEmpty) {
                                              for (var j
                                                  in isSelected_Main_Category_id) {
                                                if (i['business_category'] ==
                                                    j) {
                                                  if (isSelected_State_id
                                                      .isNotEmpty) {
                                                    for (var j
                                                        in isSelected_State_id) {
                                                      if (i['company_state'] ==
                                                          j) {
                                                        items_id.add(i['id']);
                                                        items_id = LinkedHashSet<
                                                                    int>.from(
                                                                items_id)
                                                            .toList();
                                                      }
                                                    }
                                                  } else {
                                                    items_id.add(i['id']);
                                                    items_id =
                                                        LinkedHashSet<int>.from(
                                                                items_id)
                                                            .toList();
                                                  }
                                                }
                                              }
                                            } else {
                                              items_id.add(i['id']);
                                              items_id =
                                                  LinkedHashSet<int>.from(
                                                          items_id)
                                                      .toList();
                                            }
                                          }
                                        }
                                      }

                                      if (isSelected_Main_Category_id
                                          .isNotEmpty) {
                                        for (var j
                                            in isSelected_Main_Category_id) {
                                          if (i['business_category'] == j) {
                                            if (isSelected_State_id
                                                .isNotEmpty) {
                                              for (var j
                                                  in isSelected_State_id) {
                                                if (i['company_state'] == j) {
                                                  if (isSelected_Category_id
                                                      .isNotEmpty) {
                                                    for (var j
                                                        in isSelected_Category_id) {
                                                      if (i['sub_business_category'] ==
                                                          j) {
                                                        items_id.add(i['id']);
                                                        items_id = LinkedHashSet<
                                                                    int>.from(
                                                                items_id)
                                                            .toList();
                                                      }
                                                    }
                                                  } else {
                                                    items_id.add(i['id']);
                                                    items_id =
                                                        LinkedHashSet<int>.from(
                                                                items_id)
                                                            .toList();
                                                  }
                                                }
                                              }
                                            } else {
                                              items_id.add(i['id']);
                                              items_id =
                                                  LinkedHashSet<int>.from(
                                                          items_id)
                                                      .toList();
                                              print(items_id);
                                            }
                                          }
                                        }
                                      }
                                      if (isSelected_State_id.isNotEmpty) {
                                        for (var j in isSelected_State_id) {
                                          if (i['company_state'] == j) {
                                            if (isSelected_Main_Category_id
                                                .isNotEmpty) {
                                              for (var j
                                                  in isSelected_Main_Category_id) {
                                                if (i['business_category'] ==
                                                    j) {
                                                  if (isSelected_Category_id
                                                      .isNotEmpty) {
                                                    for (var j
                                                        in isSelected_Category_id) {
                                                      if (i['sub_business_category'] ==
                                                          j) {
                                                        items_id.add(i['id']);
                                                        items_id = LinkedHashSet<
                                                                    int>.from(
                                                                items_id)
                                                            .toList();
                                                      }
                                                    }
                                                  } else {
                                                    items_id.add(i['id']);
                                                    items_id =
                                                        LinkedHashSet<int>.from(
                                                                items_id)
                                                            .toList();
                                                  }
                                                }
                                              }
                                            } else {
                                              items_id.add(i['id']);
                                              items_id =
                                                  LinkedHashSet<int>.from(
                                                          items_id)
                                                      .toList();
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                  if (items_id.isNotEmpty) {
                                    for (var i in itemsEntrepreneurs) {
                                      for (var j in items_id) {
                                        if (i['id'] == j) {
                                          if (_yearFrom.text.length > 0 &&
                                              _yearTo.text.length > 0) {
                                            if (int.parse(
                                                        i['establish_year']) >=
                                                    int.parse(_yearFrom.text) &&
                                                int.parse(
                                                        i['establish_year']) <=
                                                    int.parse(_yearTo.text)) {
                                              items.add(i);
                                            }
                                          } else if (_yearFrom.text.length >
                                                  3 &&
                                              _yearTo.text.length == 0) {
                                            if (int.parse(
                                                    i['establish_year']) >=
                                                int.parse(_yearFrom.text)) {
                                              items.add(i);
                                            }
                                          } else if (_yearFrom.text.length ==
                                                  0 &&
                                              _yearTo.text.length > 3) {
                                            if (int.parse(
                                                    i['establish_year']) <=
                                                int.parse(_yearTo.text)) {
                                              items.add(i);
                                            }
                                          } else {
                                            items.add(i);
                                          }
                                        }
                                      }
                                    }
                                  }
                                } else {
                                  for (var i in itemsEntrepreneurs) {
                                    if (isSelected_member_id.isNotEmpty) {
                                      for (var j in isSelected_member_id) {
                                        if (i['member_type_string'] == j) {
                                          if (isSelected_Category_id.isEmpty &&
                                              isSelected_State_id.isEmpty) {
                                            items_id.add(i['id']);
                                            items_id = LinkedHashSet<int>.from(
                                                    items_id)
                                                .toList();
                                          } else {
                                            if (isSelected_Category_id
                                                .isNotEmpty) {
                                              for (var j
                                                  in isSelected_Category_id) {
                                                if (i['sub_business_category'] ==
                                                    j) {
                                                  if (isSelected_State_id
                                                      .isNotEmpty) {
                                                    for (var j
                                                        in isSelected_State_id) {
                                                      if (i['company_state'] ==
                                                          j) {
                                                        items_id.add(i['id']);
                                                        items_id = LinkedHashSet<
                                                                    int>.from(
                                                                items_id)
                                                            .toList();
                                                      }
                                                    }
                                                  } else {
                                                    items_id.add(i['id']);
                                                    items_id =
                                                        LinkedHashSet<int>.from(
                                                                items_id)
                                                            .toList();
                                                  }
                                                }
                                              }
                                            }
                                            if (isSelected_State_id
                                                .isNotEmpty) {
                                              for (var j
                                                  in isSelected_State_id) {
                                                if (i['company_state'] == j) {
                                                  if (isSelected_Category_id
                                                      .isNotEmpty) {
                                                    for (var j
                                                        in isSelected_Category_id) {
                                                      if (i['sub_business_category'] ==
                                                          j) {
                                                        items_id.add(i['id']);
                                                        items_id = LinkedHashSet<
                                                                    int>.from(
                                                                items_id)
                                                            .toList();
                                                      }
                                                    }
                                                  } else {
                                                    items_id.add(i['id']);
                                                    items_id =
                                                        LinkedHashSet<int>.from(
                                                                items_id)
                                                            .toList();
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                  for (var i in itemsEntrepreneurs) {
                                    for (var j in items_id) {
                                      if (i['id'] == j) {
                                        if (_yearFrom.text.length > 0 &&
                                            _yearTo.text.length > 0) {
                                          if (int.parse(i['establish_year']) >=
                                                  int.parse(_yearFrom.text) &&
                                              int.parse(i['establish_year']) <=
                                                  int.parse(_yearTo.text)) {
                                            items.add(i);
                                          }
                                        } else if (_yearFrom.text.length > 3 &&
                                            _yearTo.text.length == 0) {
                                          if (int.parse(i['establish_year']) >=
                                              int.parse(_yearFrom.text)) {
                                            items.add(i);
                                          }
                                        } else if (_yearFrom.text.length == 0 &&
                                            _yearTo.text.length > 3) {
                                          if (int.parse(i['establish_year']) <=
                                              int.parse(_yearTo.text)) {
                                            items.add(i);
                                          }
                                        } else {
                                          items.add(i);
                                        }
                                      }
                                    }
                                  }
                                }
                                print(isSelected_member_id);
                              });
                            },
                            child: Chip(
                              backgroundColor:
                                  isSelected_member[index] == "true"
                                      ? Colors.blue[100]
                                      : Colors.grey[300],
                              label: Text(member_type[index]),
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
              const Divider(color: kThirdColor),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 0),
          decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: kThirdColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: BlockButtonWidget(
                  onPressed: () async {
                    clearAll();
                  },
                  color: Colors.grey.shade300,
                  text: const Text(
                    "Clear",
                    style: TextStyle(color: Colors.black),
                  ),
                ).paddingOnly(top: 8, bottom: 8, right: 8, left: 8),
              ),
              Expanded(
                child: BlockButtonWidget(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  color: kPrimaryColor,
                  text: const Text(
                    "Done",
                    style: TextStyle(color: Colors.white),
                  ),
                ).paddingOnly(top: 8, bottom: 8, right: 8, left: 8),
              ),
            ],
          ).paddingSymmetric(vertical: 0, horizontal: 5),
        ),
      )),
    );
  }

  void _setInputValue(String field, String value) {
    setState(() => _formData[field] = value.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_left,
                color: kSecondaryColor, size: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            widget.name,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
          actions: <Widget>[
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.filter_alt,
                      color: kSecondaryColor, size: 30),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            )
          ],
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
        endDrawer: populateDrawer(),
        body: items.isNotEmpty
            ? ListView.separated(
                itemBuilder: (context, index) {
                  return _buildEntrepreneursList(items[index]);
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: items.length,
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
                                style: TextStyle(
                                    color: kThirdColor.withOpacity(0.7))),
                          ],
                        )
                      ]),
                ),
              ));
  }

  Widget _buildEntrepreneursList(dynamic data) {
    print("data${data}");
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
                    title: const Text('View Entrepreneur Detail'),
                    content: const Text(
                        'Need to login first only can view this entrepreneur.'),
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
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
