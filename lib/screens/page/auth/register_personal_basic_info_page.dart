// ignore_for_file: prefer_is_empty

import 'dart:convert';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mlcc_app_ios/screens/page/auth/login_page.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../widget/block_button_widget.dart';
import '../../../widget/text_field_widget.dart';

class RegisterPersonalBasicInfoPage extends StatefulWidget {
  const RegisterPersonalBasicInfoPage({Key? key}) : super(key: key);

  @override
  _RegisterPersonalBasicInfoPageState createState() =>
      _RegisterPersonalBasicInfoPageState();
}

class _RegisterPersonalBasicInfoPageState
    extends State<RegisterPersonalBasicInfoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AutovalidateMode _autoValidate;
  bool showExpandingNationalityOther = false;
  bool showExpandingStateOther = false;
  bool hidePassword = true;
  HttpProvider httpProvider = HttpProvider();
  List<dynamic> titleList = [];
  List<dynamic> groupList = [];
  List<String> title = [];
  List<String> group = [];

  bool isMaleSelected = false;
  bool isFemaleSelected = false;
  bool isOthersSelected = false;

  bool isNoCompanySelected = false;
  bool isYesCompanySelected = false;

  bool currentlyWorking = false;
  int selectedBusinessNatureID = 0;
  String selectedBusinessNature = "";
  int selectedSubBusinessNatureID = 0;
  String selectedSubBusinessNature = "";
  int selectedSalesID = 0;
  String selectedSales = "";
  int selectedStateID = 0;
  String selectedState = "";
  int selectedCountryID = 0;
  String selectedCountry = "";
  bool showExpandingAreasOther = false;

  var showcompany = true;

  var loading = false;
  var validateinteraction = false;

  dynamic initArea = [];
  String uriCert = '';
  bool isdisabled = false;
  final TextEditingController _passwordController = new TextEditingController();
  List<String> organizationEntity = [
    'Sole Proprietorship',
    'Private Limited Company',
    'Public Listed Company',
    'Partnership'
  ];

  List selectedExpandingAreas = [];
  List expandingAreas = [
    'Networking',
    'Resources',
    'Stronger Team',
    'New Projects',
    'Increasing Knowledge',
    'Others'
  ];
  List listToSearch = [
    {'area': 'Networking', 'id': 0},
    {'area': 'Resources', 'id': 1},
    {'area': 'Stronger Team', 'id': 2},
    {'area': 'New Projects', 'id': 3},
    {'area': 'Increasing Knowledge', 'id': 4},
    {'area': 'Others', 'id': 5},
  ];
  List<String> businessCategory = [];
  List<dynamic> businessCategoryList = [];
  Future<void> getBusinessCategory() async {
    HttpProvider httpProvider = HttpProvider();
    businessCategoryList =
        await httpProvider.getHttp("business_category/main_listing");
    setState(() {
      for (var element in businessCategoryList) {
        businessCategory.add(element['name']);
      }
    });
  }

  getTitle() async {
    titleList = await httpProvider.getHttp("title");
    setState(() {
      for (var element in titleList) {
        title.add(element['title']);
      }
    });
  }

  getLaison() async {
    groupList = await httpProvider.getHttp("group");
    setState(() {
      for (var element in groupList) {
        group.add(element['name']);
      }
    });
  }

  var maskFormatter = MaskTextInputFormatter(mask: '######-##-####');
  List<dynamic> nationalityList = [];
  List<String> nationality = [];
  getNationality() async {
    nationalityList = await httpProvider.getHttp("nationality");
    setState(() {
      for (var element in nationalityList) {
        nationality.add(element['name']);
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

  List<dynamic> salesList = [];
  List<String> sales = [];
  getSalesList() async {
    salesList = await httpProvider.getHttp("company_sales_turnover");
    setState(() {
      for (var element in salesList) {
        sales.add(element['description']);
        // if (selectedSalesID == element['id']) {
        //   selectedSales = element['description'];
        // }
      }
    });
  }

  @override
  void initState() {
    getTitle();
    getNationality();
    getStateList();
    getLaison();
    getBusinessCategory();
    getSalesList();

    super.initState();
  }

  final Map<String, dynamic> _AreaData = {};
  List<dynamic> SubCategoryList = [];
  List<String> SubCategory = [];
  bool showExpandingSubCategory = false;
  Future<void> getSubCategory(id) async {
    dynamic formData = {'main_id': id};
    SubCategory = [];
    SubCategoryList =
        await httpProvider.postHttp("business_category/sub_listing", formData);
    setState(() {
      showExpandingSubCategory = true;
      for (var element in SubCategoryList) {
        SubCategory.add(element['name']);
        if (selectedSubBusinessNatureID == element['id']) {
          selectedSubBusinessNature = element['name'];
        }
      }
    });
  }

  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    // 'first_name': null,
    // 'last_name': null,
    'identity_card': null,
    'phone_number': null
  };

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
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            "Register",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        body: DelayedDisplay(
          delay: const Duration(
            milliseconds: 600,
          ),
          child: ListView(
            primary: true,
            children: [
              Stack(alignment: AlignmentDirectional.bottomCenter, children: [
                Container(
                  height: 160,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: kThirdColor,
                          blurRadius: 10,
                          offset: Offset(0, 5)),
                    ],
                  ),
                  margin: const EdgeInsets.only(bottom: 50),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: const [
                        Text(
                          "Malaysia Lin Chamber of Commerce",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Personal Basic Info",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        // Text("Fill the following credentials to login your account",
                        //     style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                    boxShadow: const [
                      BoxShadow(
                          color: kThirdColor,
                          blurRadius: 10,
                          offset: Offset(0, 5)),
                    ],
                    border: Border.all(color: kThirdColor),
                    // gradient: gradient,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Image.asset(
                        'assets/mlcc_logo.png',
                        fit: BoxFit.contain,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ),
              ]),
              Form(
                key: _formKey,
                // autovalidateMode: _autoValidate,
                autovalidateMode: validateinteraction == false
                    ? AutovalidateMode.disabled
                    : AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFieldWidget(
                        labelText: "Email Address",
                        mandatory: "*",
                        // exampleText: " Example(johndoe@gmail.com)",
                        hintText: "your.email@gmail.com",
                        iconData: Icons.alternate_email,
                        keyboardType: TextInputType.emailAddress,
                        isFirst: true,
                        isLast: false,
                        setValue: _setInputValue,
                        field: 'email',
                        validator: emailValidator),
                    // TextFieldWidget(
                    //   controller: _passwordController,
                    //   obscureText: hidePassword,
                    //   mandatory: "*",
                    //   labelText: "Password",
                    //   //hintText: "••••••••••••",
                    //   textMark:
                    //       "at least 8 character uppercase \n lowercase number symbol(@!..)",
                    //   hintText: "your password",
                    //   iconData: Icons.lock_outline,
                    //   keyboardType: TextInputType.visiblePassword,
                    //   isFirst: false,
                    //   isLast: false,
                    //   setValue: _setInputValue,
                    //   field: 'password',
                    //   validator: passwordValidator,
                    // suffixIcon: IconButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       hidePassword = !hidePassword;
                    //     });
                    //   },
                    //   color: Theme.of(context).focusColor,
                    //   icon: Icon(hidePassword
                    //       ? Icons.visibility_outlined
                    //       : Icons.visibility_off_outlined),
                    // ),
                    // ),

                    Container(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 14, left: 20, right: 20),
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 20, bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Get.theme.focusColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5)),
                            ],
                            border: Border.all(
                                color: Get.theme.focusColor.withOpacity(0.05))),
                        child: Column(children: [
                          Row(
                            children: [
                              Text(
                                "Password",
                                style: Get.textTheme.bodyText1,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: _passwordController,
                            validator: passwordValidator,
                            obscureText: hidePassword,
                            // initialValue: _formData['password'],
                            onSaved: (dynamic value) {
                              _setInputValue('password', value);
                            },
                            onChanged: (dynamic value) {
                              _setInputValue('password', value);
                            },
                            decoration: InputDecoration(
                              hintStyle: Get.textTheme.caption,
                              prefixIcon: Icons.lock_outline != null
                                  ? Icon(Icons.lock_outline,
                                          color: kPrimaryColor)
                                      .marginOnly(right: 14)
                                  : const SizedBox(),
                              prefixIconConstraints: Icons.lock_outline != null
                                  ? const BoxConstraints.expand(
                                      width: 38, height: 38)
                                  : const BoxConstraints.expand(
                                      width: 0, height: 0),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              contentPadding: const EdgeInsets.all(0),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                color: Theme.of(context).focusColor,
                                icon: Icon(hidePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                              ),
                            ),
                          ),
                          FlutterPwValidator(
                            controller: _passwordController,
                            minLength: 8,
                            uppercaseCharCount: 1,
                            numericCharCount: 3,
                            specialCharCount: 1,
                            normalCharCount: 3,
                            width: 300,
                            height: 100,
                            onSuccess: () {
                              print("MATCHED");
                              ScaffoldMessenger.of(context).showSnackBar(
                                  new SnackBar(
                                      content:
                                          new Text("Password is matched")));
                            },
                            onFail: () {
                              print("NOT MATCHED");
                            },
                          ),
                        ])),

                    Container(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 14, left: 20, right: 20),
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(0)),
                          boxShadow: [
                            BoxShadow(
                                color: Get.theme.focusColor.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5)),
                          ],
                          border: Border.all(
                              color: Get.theme.focusColor.withOpacity(0.05))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Title",
                                style: Get.textTheme.bodyText1,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownSearch<String>(
                              mode: Mode.BOTTOM_SHEET,
                              showSelectedItems: true,
                              items: title,
                              // label: "Title",
                              onChanged: (item) {
                                final data = titleList
                                    .firstWhere((e) => e['title'] == item);
                                _formData['title_id'] = data['id'];
                              },
                              onSaved: (item) {
                                final data = titleList
                                    .firstWhere((e) => e['title'] == item);
                                _formData['title_id'] = data['id'];
                              },
                              validator: (item) {
                                if (item == null) {
                                  return "Please select title";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextFieldWidget(
                      labelText: "Name",
                      mandatory: "*",
                      hintText: "your name",
                      iconData: Icons.person_outline,
                      isFirst: false,
                      isLast: false,
                      setValue: _setInputValue,
                      field: 'name',
                      validator:
                          RequiredValidator(errorText: 'Name is required'),
                    ),
                    TextFieldWidget(
                      labelText: "Preferred Name",
                      mandatory: "*",
                      hintText: "your preferred name",
                      iconData: Icons.person_outline,
                      isFirst: false,
                      isLast: false,
                      setValue: _setInputValue,
                      field: 'preferred_name',
                      validator: RequiredValidator(
                          errorText: 'Preferred Name is required'),
                    ),
                    TextFieldWidget(
                      labelText: "Chinese Name",
                      // hintText: "李薇薇",
                      hintText: "姓名",
                      iconData: Icons.person_outline,
                      isFirst: false,
                      isLast: false,
                      setValue: _setInputValue,
                      field: 'chinese_name',
                    ),
                    TextFieldWidget(
                      labelText: "Phone Number",
                      mandatory: "*",
                      //textMark: "No dash (-) or space allowed. Eg: 0123456789",
                      hintText: "Eg: 0123456789",
                      iconData: Icons.phone_iphone,
                      keyboardType: TextInputType.phone,
                      isFirst: false,
                      isLast: true,
                      setValue: _setInputValue,
                      field: 'phone_number',
                      validator: phoneNumberValidator,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 14, left: 20, right: 20),
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: Get.theme.focusColor.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5)),
                          ],
                          border: Border.all(
                              color: Get.theme.focusColor.withOpacity(0.05))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Gender",
                                style: Get.textTheme.bodyText1,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     const Icon(FontAwesomeIcons.venusMars,
                              //             color: kPrimaryColor)
                              //         .marginOnly(right: 14)
                              //   ],
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Radio(
                                      toggleable: isMaleSelected,
                                      activeColor: kThirdColor,
                                      value: "Male",
                                      groupValue: _formData['gender'],
                                      onChanged: (value) {
                                        setState(() {
                                          _formData['gender'] = value;
                                        });
                                      }),
                                  const Text('Male')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Radio(
                                    toggleable: isFemaleSelected,
                                    activeColor: kThirdColor,
                                    value: "Female",
                                    groupValue: _formData['gender'],
                                    onChanged: (value) {
                                      setState(() {
                                        _formData['gender'] = value;
                                      });
                                    },
                                  ),
                                  const Text('Female'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Radio(
                                    toggleable: isOthersSelected,
                                    activeColor: kThirdColor,
                                    value: "Others",
                                    groupValue: _formData['gender'],
                                    onChanged: (value) {
                                      setState(() {
                                        _formData['gender'] = value;
                                      });
                                    },
                                  ),
                                  const Text('Others'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 14, left: 20, right: 20),
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: Get.theme.focusColor.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5)),
                          ],
                          border: Border.all(
                              color: Get.theme.focusColor.withOpacity(0.05))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Have a Company ?",
                                style: Get.textTheme.bodyText1,
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Radio(
                                      toggleable: isYesCompanySelected,
                                      activeColor: kThirdColor,
                                      value: 1,
                                      groupValue: _formData['is_company'],
                                      onChanged: (value) {
                                        setState(() {
                                          _formData['is_company'] = value;
                                          showcompany = true;
                                        });
                                      }),
                                  const Text('Yes')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Radio(
                                    toggleable: isNoCompanySelected,
                                    activeColor: kThirdColor,
                                    value: 0,
                                    groupValue: _formData['is_company'],
                                    onChanged: (value) {
                                      setState(() {
                                        _formData['is_company'] = value;
                                        showcompany = false;
                                      });
                                    },
                                  ),
                                  const Text('No'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 14, left: 20, right: 20),
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(0)),
                          boxShadow: [
                            BoxShadow(
                                color: Get.theme.focusColor.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5)),
                          ],
                          border: Border.all(
                              color: Get.theme.focusColor.withOpacity(0.05))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Liaison",
                                style: Get.textTheme.bodyText1,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownSearch<String>(
                              mode: Mode.BOTTOM_SHEET,
                              showSelectedItems: true,
                              items: group,
                              // label: "Liaison",
                              onChanged: (item) {
                                final data = groupList
                                    .firstWhere((e) => e['name'] == item);
                                _formData['⁠liaison'] = data['name'];
                                _formData['⁠group_id_name'] = data['name'];
                                _formData['⁠group_id'] = data['id'];

                                setState(() {
                                  // print(data['id']);
                                  // print(data['name']);
                                  _formData['⁠group_id_name'] = data['name'];
                                });
                              },
                              onSaved: (item) {
                                final data = groupList
                                    .firstWhere((e) => e['name'] == item);
                                _formData['⁠liaison'] = data['name'];
                                _formData['⁠group_id_name'] = data['name'];
                                _formData['⁠group_id'] = data['id'];
                              },
                              validator: (item) {
                                if (item == null) {
                                  return "Please select Laison";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 14, left: 20, right: 20),
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(0)),
                          boxShadow: [
                            BoxShadow(
                                color: Get.theme.focusColor.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5)),
                          ],
                          border: Border.all(
                              color: Get.theme.focusColor.withOpacity(0.05))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Nationality",
                                style: Get.textTheme.bodyText1,
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                "*",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownSearch<String>(
                              mode: Mode.BOTTOM_SHEET,
                              showSelectedItems: true,
                              items: nationality,
                              // label: "Nationality",
                              onChanged: (item) {
                                final data = nationalityList
                                    .firstWhere((e) => e['name'] == item);
                                _formData['nationality_id'] = data['id'];
                                if (data['id'] == 9) {
                                  setState(() {
                                    showExpandingNationalityOther = true;
                                    showExpandingStateOther = false;
                                  });
                                } else {
                                  setState(() {
                                    showExpandingNationalityOther = false;
                                    showExpandingStateOther = true;
                                  });
                                }
                              },
                              onSaved: (item) {
                                final data = nationalityList
                                    .firstWhere((e) => e['name'] == item);
                                _formData['nationality_id'] = data['id'];
                              },
                              validator: (item) {
                                if (item == null) {
                                  return "Please select nationality";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    showExpandingNationalityOther == true
                        ? TextFieldWidget(
                            labelText: "Others",
                            mandatory: "*",
                            hintText: "Type your nationality",
                            keyboardType: TextInputType.multiline,
                            iconData: Icons.expand,
                            isFirst: false,
                            isLast: false,
                            setValue: _setInputValue,
                            field: 'others_nationality',
                            validator: RequiredValidator(
                                errorText: 'Others is required'),
                          )
                        : Container(),
                    showExpandingStateOther == true
                        ? Container(
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 14, left: 20, right: 20),
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 0, bottom: 0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(0)),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Get.theme.focusColor.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5)),
                                ],
                                border: Border.all(
                                    color: Get.theme.focusColor
                                        .withOpacity(0.05))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "State",
                                      style: Get.textTheme.bodyText1,
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      "*",
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownSearch<String>(
                                    mode: Mode.BOTTOM_SHEET,
                                    showSelectedItems: true,
                                    items: state,
                                    //label: "State",
                                    onChanged: (item) {
                                      final data = stateList
                                          .firstWhere((e) => e['name'] == item);
                                      _formData['state_id'] = data['id'];
                                    },
                                    onSaved: (item) {
                                      final data = stateList
                                          .firstWhere((e) => e['name'] == item);
                                      _formData['state_id'] = data['id'];
                                    },
                                    validator: (item) {
                                      if (item == null) {
                                        return "Please select state";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    showExpandingStateOther == true
                        ? Container()

                        // TextFieldWidget(
                        //     labelText: "Identity Card",
                        //     mandatory: "*",
                        //     hintText: "XXXXXX-XX-XXXX",
                        //     iconData: Icons.ac_unit,
                        //     //iconData: FontAwesomeIcons.solidAddressCard,
                        //     inputFormatters: [maskFormatter],
                        //     // keyboardType: TextInputType.number,
                        //     isFirst: false,
                        //     isLast: false,
                        //     setValue: _setInputValue,
                        //     field: 'identity_card',
                        //     validator: identityCardValidator,
                        //   )
                        : Container(),
                    showExpandingNationalityOther == true
                        ? Container()

                        //  TextFieldWidget(
                        //     labelText: "Passport No (For Non-Malaysians)",
                        //     //hintText: "XXXXXXXXXXXXXXXX",
                        //     iconData: Icons.ac_unit,
                        //     //iconData: FontAwesomeIcons.solidAddressCard,
                        //     isFirst: false,
                        //     isLast: false,
                        //     setValue: _setInputValue,
                        //     keyboardType: TextInputType.number,
                        //     field: 'passport_number',
                        //   )
                        : Container(),

                    if (showcompany == true)
                      TextFieldWidget(
                        labelText: "Company Name",
                        hintText: "Company Name",
                        isFirst: false,
                        isLast: false,
                        iconData: FontAwesomeIcons.building,
                        //iconData: Icons.ac_unit,
                        setValue: _setInputValue,
                        field: 'company_name',
                        // validator: RequiredValidator(
                        //     errorText: 'Company Name is required'),
                        initialValue: _formData['company_name'],
                      ),
                    if (showcompany == true)
                      TextFieldWidget(
                        labelText: "Designation",
                        hintText: "Designation",
                        iconData: Icons.business_center_rounded,
                        setValue: _setInputValue,
                        isFirst: false,
                        isLast: false,
                        field: 'designation',
                        // validator:
                        //     RequiredValidator(errorText: 'Designation is required'),
                        initialValue: _formData['designation'],
                      ),
                    if (showcompany == true)
                      TextFieldWidget(
                        labelText: "Company Address",
                        hintText: "Company Address",
                        keyboardType: TextInputType.multiline,
                        iconData: Icons.home,
                        // keyboardType: TextInputType.phone,
                        setValue: _setInputValue,
                        initialValue: _formData['company_address'],
                        field: 'company_address',
                        isFirst: false,
                        isLast: false,
                      ),

                    if (showcompany == true)
                      TextFieldWidget(
                        labelText: "Postcode",
                        // mandatory: "*",
                        hintText: "Postcode",
                        keyboardType: TextInputType.number,
                        iconData: Icons.home,
                        // keyboardType: TextInputType.phone,
                        setValue: _setInputValue,
                        initialValue: _formData['company_postcode'],
                        field: 'company_postcode',
                        isFirst: false,
                        isLast: false,
                        validator: RequiredValidator(
                            errorText: 'Company Postcode is required'),
                      ),

                    if (showcompany == true)
                      TextFieldWidget(
                        labelText: "City",
                        hintText: "Company City",
                        iconData: Icons.home,
                        // keyboardType: TextInputType.phone,
                        setValue: _setInputValue,
                        initialValue: _formData['company_city'],
                        field: 'company_city',
                        isFirst: false,
                        isLast: false,
                      ),
                    if (showcompany == true)
                      Container(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 14, left: 20, right: 20),
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, top: 0, bottom: 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Get.theme.focusColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5)),
                            ],
                            border: Border.all(
                                color: Get.theme.focusColor.withOpacity(0.05))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Business Category",
                              style: Get.textTheme.bodyText1,
                              textAlign: TextAlign.start,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownSearch<String>(
                                mode: Mode.BOTTOM_SHEET,
                                showSelectedItems: true,

                                items: businessCategory,
                                //label: "Business Category",
                                onChanged: (item) {
                                  final data = businessCategoryList
                                      .firstWhere((e) => e['name'] == item);
                                  _formData['business_category_main_id'] =
                                      data['id'];
                                  getSubCategory(data['id']);
                                  setState(() {
                                    selectedBusinessNature = data['name'];
                                    selectedSubBusinessNature = "";
                                  });
                                },
                                onSaved: (item) {
                                  print("item${item}");
                                  if (item != '') {
                                    print("itemmasuk");

                                    final data = businessCategoryList
                                        .firstWhere((e) => e['name'] == item);

                                    _formData['business_category_main_id'] =
                                        data['id'];
                                  } else {
                                    print("itemkeluar");
                                    _formData['business_category_main_id'] = "";
                                  }
                                },
                                selectedItem: selectedBusinessNature,
                                // validator: (item) {
                                //   if (item == null) {
                                //     return "Please select a Business Category";
                                //   } else {
                                //     return null;
                                //   }
                                // },
                              ),
                            ),
                          ],
                        ),
                      ),

                    showExpandingSubCategory == true
                        ? Container(
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 14, left: 20, right: 20),
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 0, bottom: 0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Get.theme.focusColor.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5)),
                                ],
                                border: Border.all(
                                    color: Get.theme.focusColor
                                        .withOpacity(0.05))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Sub Category of Business",
                                  style: Get.textTheme.bodyText1,
                                  textAlign: TextAlign.start,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownSearch<String>(
                                    mode: Mode.BOTTOM_SHEET,
                                    showSelectedItems: true,
                                    items: SubCategory,
                                    // label: "Sub Category of Business",
                                    onChanged: (item) {
                                      final data = SubCategoryList.firstWhere(
                                          (e) => e['name'] == item);
                                      _formData['business_category_sub_id'] =
                                          data['id'];
                                    },
                                    onSaved: (item) {
                                      final data = SubCategoryList.firstWhere(
                                          (e) => e['name'] == item);
                                      _formData['business_category_sub_id'] =
                                          data['id'];
                                    },
                                    selectedItem: selectedSubBusinessNature,
                                    // validator: (item) {
                                    //   if (item == null) {
                                    //     return "Please select sub business category";
                                    //   } else {
                                    //     return null;
                                    //   }
                                    // },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    if (showcompany == true)
                      TextFieldWidget(
                        labelText: "Nature of Business",
                        hintText: "Ex : Software Development",
                        iconData: Icons.business_center_rounded,
                        setValue: _setInputValue,
                        field: 'business_nature',
                        isFirst: false,
                        isLast: false,
                        initialValue: _formData['business_nature'],
                        // validator: RequiredValidator(
                        //     errorText: 'Business Nature is required'),
                      ),
                    if (showcompany == true)
                      Container(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 14, left: 8, right: 20),
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, top: 0, bottom: 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(0)),
                            boxShadow: [
                              BoxShadow(
                                  color: Get.theme.focusColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5)),
                            ],
                            border: Border.all(
                                color: Get.theme.focusColor.withOpacity(0.05))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "   Expanding Areas",
                              style: Get.textTheme.bodyText1,
                              textAlign: TextAlign.start,
                            ),
                            CustomSearchableDropDown(
                                items: listToSearch,
                                label: '    Expanding Areas',
                                multiSelectTag: '    Expanding Areas',
                                multiSelectValuesAsWidget: true,
                                multiSelect: true,
                                prefixIcon: const Icon(
                                  Icons.expand,
                                  color: kPrimaryColor,
                                ),
                                initialValue: initArea,
                                onChanged: (value) {
                                  initArea = [];
                                  _formData['expanding_areas'] = '';
                                  if (value != null) {
                                    dynamic data = jsonDecode(value);
                                    String dataListSelected = '';
                                    for (int i = 0; i < data.length; i++) {
                                      dataListSelected =
                                          dataListSelected.toString() +
                                              ',' +
                                              '"' +
                                              data[i]['area'].toString() +
                                              '"';
                                      if (data[i]['area'].contains("Others") ==
                                          true) {
                                        setState(() {
                                          showExpandingAreasOther = true;
                                        });
                                      } else {
                                        setState(() {
                                          showExpandingAreasOther = false;
                                        });
                                      }
                                    }
                                    _formData['expanding_areas'] = '"[' +
                                        dataListSelected.substring(1) +
                                        ']"';
                                    print(
                                        "expanding_area${_formData['expanding_areas']}");
                                  } else {
                                    selectedExpandingAreas.clear();
                                  }
                                },
                                dropDownMenuItems: listToSearch.map((item) {
                                  return item['area'];
                                }).toList(),
                                primaryColor: kPrimaryColor),
                          ],
                        ),
                      ),
                    showExpandingAreasOther == true
                        ? TextFieldWidget(
                            labelText: "Others",
                            // hintText: "Others",
                            keyboardType: TextInputType.multiline,
                            iconData: Icons.expand,
                            isFirst: false,
                            isLast: false,
                            setValue: _setInputValue,
                            field: 'expanding_areas_others',
                            initialValue: _formData['expanding_areas_others'],
                            validator: RequiredValidator(
                                errorText: 'Others is required'),
                          )
                        : Container(),
                    TextFieldWidget(
                      labelText: "Expectations",
                      hintText: "Expectations",
                      iconData: Icons.chat_rounded,
                      keyboardType: TextInputType.multiline,
                      isFirst: false,
                      isLast: true,
                      setValue: _setInputValue,
                      field: 'expectation',
                      initialValue: _formData['expectation'],
                      // validator: RequiredValidator(
                      //     errorText: 'Expectations is required'),
                    ),

                    BlocListener<AuthBloc, AuthState>(listener:
                        (BuildContext context, AuthState state) async {
                      if (state is RegisterSuccessful) {
                        print("tes_save-success");
                        // Navigator.pushNamed(context, '/login_page');
                        showProgress(context);
                      } else if (state is UserNotFound) {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Error'),
                                  content: Text(state.status),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                      style: TextButton.styleFrom(
                                          primary: Colors.black),
                                    ),
                                  ],
                                ));
                      }
                    }, child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (BuildContext context, AuthState state) {
                      if (state is AuthLoading) {
                        return const LoadingWidget();
                      } else {
                        return loading == true
                            ? Center(child: CircularProgressIndicator())
                            : BlockButtonWidget(
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                    validateinteraction = true;
                                  });

                                  print("tes_save${_formData}");
                                  // _formData['phone_number'] =
                                  //     "+6${_formData['phone_number']}";
                                  final form = _formKey.currentState;
                                  //  if (form!.validate()) {
                                  print("tes_save${_formData}");
                                  // form.save();
                                  context
                                      .read<AuthBloc>()
                                      .add(Register(_formData));

                                  setState(() {
                                    loading = false;
                                  });

                                  if (form!.validate()) {
                                    print("tes_save_after_click${_formData}");
                                    form.save();
                                  }
                                },
                                color: kPrimaryColor,
                                text: const Text(
                                  "Done",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ).paddingOnly(
                                top: 15, bottom: 5, right: 20, left: 20);
                      }
                    })),
                    // BlockButtonWidget(
                    //   onPressed: () async {
                    //     // Navigator.pushNamed(context, '/register_company_page');
                    //     final form = _formKey.currentState;
                    //     if (form!.validate()) {
                    //       form.save();
                    //       HttpProvider httpProvider = HttpProvider();
                    //       var checkEmailDataReturn = await httpProvider.postHttp(
                    //           "register/chk_email", _formData);
                    //       if (checkEmailDataReturn == "Unique email") {
                    //         Navigator.pushNamed(context, '/register_company_page',
                    //             arguments: _formData);
                    //       } else if (checkEmailDataReturn ==
                    //           "This email has registered and pending for admin approval.") {
                    //         showDialog<String>(
                    //             context: context,
                    //             builder: (BuildContext context) => AlertDialog(
                    //                   title: const Text('Email Exist'),
                    //                   content: Text(checkEmailDataReturn),
                    //                   actions: <Widget>[
                    //                     TextButton(
                    //                       onPressed: () =>
                    //                           Navigator.pop(context, 'OK'),
                    //                       child: const Text('OK'),
                    //                       style: TextButton.styleFrom(
                    //                           primary: Colors.black),
                    //                     ),
                    //                   ],
                    //                 ));
                    //       } else if (checkEmailDataReturn ==
                    //           "This email has registered. You may proceed to login.") {
                    //         showDialog<String>(
                    //             context: context,
                    //             builder: (BuildContext context) => AlertDialog(
                    //                   title: const Text('Email Exist'),
                    //                   content: Text(checkEmailDataReturn),
                    //                   actions: <Widget>[
                    //                     TextButton(
                    //                       onPressed: () =>
                    //                           Navigator.pop(context, 'OK'),
                    //                       child: const Text('OK'),
                    //                       style: TextButton.styleFrom(
                    //                           primary: Colors.black),
                    //                     ),
                    //                   ],
                    //                 ));
                    //       } else if (checkEmailDataReturn ==
                    //           "Your previous registration with this email has rejected by admin.") {
                    //         showDialog<String>(
                    //             context: context,
                    //             builder: (BuildContext context) => AlertDialog(
                    //                   title: const Text('Email Exist'),
                    //                   content: Text(checkEmailDataReturn),
                    //                   actions: <Widget>[
                    //                     TextButton(
                    //                       onPressed: () =>
                    //                           Navigator.pop(context, 'OK'),
                    //                       child: const Text('OK'),
                    //                       style: TextButton.styleFrom(
                    //                           primary: Colors.black),
                    //                     ),
                    //                   ],
                    //                 ));
                    //       }
                    //     }
                    //   },
                    //   color: kPrimaryColor,
                    //   text: const Text(
                    //     "Next",
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    // ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            showProgress(context);
                            // Navigator.popUntil(
                            //     context, ModalRoute.withName('/login_page'));
                            // Navigator.pushReplacement(
                            //   context,
                            //   PageTransition(
                            //       type: PageTransitionType.fade,
                            //       child: const LoginPage()),
                            //);
                          },
                          child: const Text("Already a Member? Sign In Here",
                              style: TextStyle(color: kPrimaryColor)),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _setInputValue(String field, String value) {
    setState(() => _formData[field] = value.trim());
  }

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Please enter an valid email')
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
    PatternValidator(r'^.*(?=.{7,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).*$',
        errorText:
            ' Password Invalid format need at least one lowercase letter,\n one uppercase letter and a number.'),
  ]);

  final identityCardValidator = MultiValidator([
    RequiredValidator(errorText: 'Identity Card is required'),
    MaxLengthValidator(14, errorText: 'Identity Card must follow the format'),
    PatternValidator(r'([0-9]{6}-[0-9]{2}-[0-9]{4})',
        errorText: 'Identity Card must follow the format'),
  ]);

  final phoneNumberValidator = MultiValidator([
    RequiredValidator(errorText: 'Phone Number is required'),
    MinLengthValidator(10, errorText: 'Phone Number must follow the format'),
    MaxLengthValidator(13, errorText: 'Phone Number must follow the format'),
    PatternValidator(r'(01[0-9]{8,9})',
        errorText: 'Phone Number must follow the format'),
  ]);

  Future getFuture() {
    return Future(() async {
      await Future.delayed(const Duration(seconds: 2));
      return 'Submit Successfully!';
    });
  }

  Future<void> showProgress(BuildContext context) async {
    // var result = await showDialog(
    //   context: context,
    //   builder: (context) =>
    //       FutureProgressDialog(getFuture(), message: Text('Waiting  ...')),
    // );
    showResultDialog(context);
    // return result;
  }

  void showResultDialog(
    BuildContext context,
    //String result,
  ) {
    showDialog<String>(
        // barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Send Registration '),
              content: Text(
                  'Registration  successfully submitted. Wait for confirmation from admin.  Please check your email regularly'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: const LoginPage()),
                    );
                    // Navigator.pop(context);
                  },
                  child: const Text('OK'),
                  style: TextButton.styleFrom(primary: Colors.black),
                ),
              ],
            ));
  }
}
