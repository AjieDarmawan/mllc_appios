// ignore_for_file: prefer_is_empty

import 'dart:convert';
import 'dart:io';

import 'package:delayed_display/delayed_display.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:html/parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:mlcc_app_ios/screens/page/auth/register_successful_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';
// import 'package:url_launcher/link.dart';
//import 'package:mlcc/screens/page/auth/register_select_plan.dart';
import '../../../widget/block_button_widget.dart';
import '../../../widget/loading_widget.dart';
import '../../../widget/text_field_widget.dart';
import 'login_page.dart';

class RegisterCompanyPage extends StatefulWidget {
  //final List data;
  // final Map arguments;

  const RegisterCompanyPage({Key? key}) : super(key: key);

  @override
  _RegisterCompanyPageState createState() => _RegisterCompanyPageState();
}

class _RegisterCompanyPageState extends State<RegisterCompanyPage> {
  List expandingAreas = [
    'Networking',
    'Resources',
    'Stronger Team',
    'New Projects',
    'Increasing Knowledge',
    'Others'
  ];
  TextEditingController myController2 = TextEditingController();
  List selectedExpandingAreas = [];
  bool showExpandingSubCategory = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  HttpProvider httpProvider = HttpProvider();
  List<String> businessCategory = [];
  List<dynamic> businessCategoryList = [];
  List<dynamic> SubCategoryList = [];
  List<String> SubCategory = [];

  // final ImagePicker _picker = ImagePicker();
  // File? selectImage;
  // late String _filename =
  //     'Upload SSM Certificate Attachment (Type : JPG, PNG, JPEG)';
  // var image;

  Future<void> getBusinessCategory() async {
    businessCategoryList =
        await httpProvider.getHttp("business_category/main_listing");
    setState(() {
      for (var element in businessCategoryList) {
        businessCategory.add(element['name']);
      }
    });
  }

  Future<void> getSubCategory(id) async {
    dynamic formData = {'main_id': id};
    SubCategory = [];
    SubCategoryList =
        await httpProvider.postHttp("business_category/sub_listing", formData);
    setState(() {
      showExpandingSubCategory = true;
      for (var element in SubCategoryList) {
        SubCategory.add(element['name']);
      }
    });
  }

  // List<dynamic> reffererList = [];
  // List refferer = [];
  // getReffererList() async {
  //   reffererList = await httpProvider.getHttp("member/referral");
  //   setState(() {
  //     for (var element in reffererList) {
  //       refferer.add(element['display']);
  //     }
  //   });
  // }

  // List planList = [];

  // Future<void> getPlan() async {
  //   planList = await httpProvider.getHttp("member_package");
  //   print(planList);
  // }

  List<dynamic> salesList = [];
  List<String> sales = [];
  getSalesList() async {
    salesList = await httpProvider.getHttp("company_sales_turnover");
    setState(() {
      for (var element in salesList) {
        sales.add(element['description']);
      }
    });
  }

  bool showExpandingAreasOther = false;

  @override
  void initState() {
    getBusinessCategory();
    //getReffererList();
    getSalesList();
    //getPlan();
    super.initState();
  }

  bool isAgreed = false;
  void _handleValueChange(value) {
    setState(() {
      isAgreed = value;
    });
  }

  // Future<List> fetchSimpleData() async {
  //   await Future.delayed(const Duration(milliseconds: 600));
  //   List _list = refferer;
  //   return _list;
  // }

  @override
  void dispose() {
    myController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                        "Company",
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFieldWidget(
                    labelText: "Company Name",
                    hintText: "Company Name",
                    iconData: Icons.business,
                    isFirst: true,
                    isLast: false,
                    setValue: _setInputValue,
                    field: 'company_name',
                    validator: RequiredValidator(
                        errorText: 'Company Name is required'),
                  ),
                  TextFieldWidget(
                    labelText: "Designation",
                    hintText: "Director",
                    iconData: Icons.business_center_rounded,
                    isFirst: false,
                    isLast: false,
                    setValue: _setInputValue,
                    field: 'designation',
                    validator:
                        RequiredValidator(errorText: 'Designation is required'),
                  ),
                  // TextFieldWidget(
                  //   labelText: "Nature of Business",
                  //   hintText: "Information Technology",
                  //   iconData: Icons.paste_rounded,
                  //   isFirst: false,
                  //   isLast: false,
                  //   setValue: _setInputValue,
                  //   field: 'business_nature',
                  //   validator: RequiredValidator(
                  //       errorText: 'Nature of Business is required'),
                  // ),
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
                        Text(
                          "Main Category of Business",
                          style: Get.textTheme.bodyText1,
                          textAlign: TextAlign.start,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownSearch<String>(
                            mode: Mode.BOTTOM_SHEET,
                            showSelectedItems: true,
                            items: businessCategory,
                            label: "Main Category of Business",
                            onChanged: (item) {
                              final data = businessCategoryList
                                  .firstWhere((e) => e['name'] == item);
                              _formData['business_category_main_id'] =
                                  data['id'];

                              getSubCategory(data['id']);
                            },
                            onSaved: (item) {
                              final data = businessCategoryList
                                  .firstWhere((e) => e['name'] == item);
                              _formData['business_category_main_id'] =
                                  data['id'];
                            },
                            validator: (item) {
                              if (item == null) {
                                return "Please select an Category of Business";
                              } else {
                                return null;
                              }
                            },
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
                                  const BorderRadius.all(Radius.circular(0)),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        Get.theme.focusColor.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5)),
                              ],
                              border: Border.all(
                                  color:
                                      Get.theme.focusColor.withOpacity(0.05))),
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
                                  label: "Sub Category of Business",
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
                  TextFieldWidget(
                    labelText: "Nature of Business",
                    hintText: "Software Development (App, Web & System)",
                    iconData: Icons.business_center_rounded,
                    isFirst: false,
                    isLast: false,
                    setValue: _setInputValue,
                    field: 'business_nature',
                    validator: RequiredValidator(
                        errorText: 'Business Nature is required'),
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
                        Text(
                          "Referrer No.",
                          style: Get.textTheme.bodyText1,
                          textAlign: TextAlign.start,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: DropdownSearch<String>(
                        //     showSearchBox: true,
                        //     mode: Mode.BOTTOM_SHEET,
                        //     showSelectedItems: false,
                        //     items: refferer,
                        //     label: "Referrer No",
                        //     onChanged: (item) {
                        //       final data = reffererList
                        //           .firstWhere((e) => e['display'] == item);
                        //       _formData['referrer_number'] = data['id'];
                        //     },
                        //     onSaved: (item) {
                        //       final data = reffererList
                        //           .firstWhere((e) => e['display'] == item);
                        //       _formData['referrer_number'] = data['id'];
                        //     },
                        //     validator: (item) {
                        //       if (item == null) {
                        //         return "Please select referrer no";
                        //       } else {
                        //         return null;
                        //       }
                        //     },
                        //   ),
                        // ),
                        TextFieldSearch(
                            label: 'Referrer No',
                            controller: myController2,
                            future: () {
                              //return fetchSimpleData();
                            }),
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
                        Text(
                          "Company annual sales turnove",
                          style: Get.textTheme.bodyText1,
                          textAlign: TextAlign.start,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownSearch<String>(
                            showSearchBox: true,
                            mode: Mode.BOTTOM_SHEET,
                            showSelectedItems: true,
                            items: sales,
                            label: "Company annual sales turnove",
                            onChanged: (item) {
                              final data = salesList
                                  .firstWhere((e) => e['description'] == item);
                              _formData['company_sales_id'] = data['id'];
                            },
                            onSaved: (item) {
                              final data = salesList
                                  .firstWhere((e) => e['description'] == item);
                              _formData['company_sales_id'] = data['id'];
                            },
                            validator: (item) {
                              if (item == null) {
                                return "Please select company annual sales turnove";
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
                        Text(
                          "Expanding Areas",
                          style: Get.textTheme.bodyText1,
                          textAlign: TextAlign.start,
                        ),
                        // CustomSearchableDropDown(
                        //     items: expandingAreas,
                        //     label: 'Expanding Areas',
                        //     multiSelectTag: 'Expanding Areas',
                        //     multiSelectValuesAsWidget: true,
                        //     multiSelect: true,
                        //     prefixIcon: const Icon(
                        //       Icons.expand,
                        //       color: kPrimaryColor,
                        //     ),
                        //     onChanged: (value) {
                        //       if (value != null) {
                        //         _formData['expanding_area'] = jsonDecode(value);
                        //         if (jsonDecode(value).contains("Others") ==
                        //             true) {
                        //           setState(() {
                        //             showExpandingAreasOther = true;
                        //           });
                        //         } else {
                        //           setState(() {
                        //             showExpandingAreasOther = false;
                        //           });
                        //         }
                        //       } else {
                        //         selectedExpandingAreas.clear();
                        //       }
                        //     },
                        //     dropDownMenuItems: expandingAreas.map((item) {
                        //       return item;
                        //     }).toList(),
                        //     primaryColor: kPrimaryColor),
                      ],
                    ),
                  ),
                  showExpandingAreasOther == true
                      ? TextFieldWidget(
                          labelText: "Others",
                          hintText: "Others",
                          keyboardType: TextInputType.multiline,
                          iconData: Icons.expand,
                          isFirst: false,
                          isLast: false,
                          setValue: _setInputValue,
                          field: 'expanding_area_others',
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
                    validator: RequiredValidator(
                        errorText: 'Expectations is required'),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     _onAddFileClick();
                  //   },
                  //   child: Container(
                  //     padding: const EdgeInsets.only(
                  //         top: 20, bottom: 14, left: 20, right: 20),
                  //     margin: const EdgeInsets.only(
                  //         left: 20, right: 20, top: 20, bottom: 20),
                  //     decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius:
                  //             const BorderRadius.all(Radius.circular(10)),
                  //         boxShadow: [
                  //           BoxShadow(
                  //               color: Get.theme.focusColor.withOpacity(0.1),
                  //               blurRadius: 10,
                  //               offset: const Offset(0, 5)),
                  //         ],
                  //         border: Border.all(
                  //             color: Get.theme.focusColor.withOpacity(0.05))),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.stretch,
                  //       children: [
                  //         Text(
                  //           "SSM Certificate",
                  //           style: Get.textTheme.bodyText1,
                  //           textAlign: TextAlign.start,
                  //         ),
                  //         Row(
                  //           children: [
                  //             const Padding(
                  //               padding: EdgeInsets.all(8.0),
                  //               child: Icon(Icons.file_copy,
                  //                   size: 25, color: kPrimaryColor),
                  //             ),
                  //             SizedBox(
                  //               width: MediaQuery.of(context).size.width * 0.6,
                  //               child: Text(
                  //                 _filename,
                  //                 style: const TextStyle(
                  //                     fontSize: 12, color: Colors.grey),
                  //                 overflow: TextOverflow.ellipsis,
                  //                 softWrap: false,
                  //               ),
                  //             ),
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.only(right: 8.0),
                  //         child: Checkbox(
                  //           value: isAgreed,
                  //           onChanged: _handleValueChange,
                  //           activeColor: kThirdColor,
                  //         ),
                  //       ),
                  //       Link(
                  //           uri: Uri.parse(
                  //               'https://www.xclubmy.com/xclub/website/X%20Club%20Website%20Refund%20Policy,%20Privacy%20Policy%20and%20TnC%20220114.pdf'),
                  //           //target: LinkTarget.self,
                  //           builder: (context, followLink) {
                  //             return RichText(
                  //               text: TextSpan(children: [
                  //                 const TextSpan(
                  //                   text:
                  //                       'Do you understand and agree with the above \n',
                  //                   style: TextStyle(
                  //                     fontSize: 13,
                  //                     color: Colors.black,
                  //                   ),
                  //                 ),
                  //                 TextSpan(
                  //                   text: 'Terms and Condition',
                  //                   style: const TextStyle(
                  //                     color: Colors.blue,
                  //                     decoration: TextDecoration.underline,
                  //                     fontWeight: FontWeight.bold,
                  //                     fontSize: 14,
                  //                   ),
                  //                   recognizer: TapGestureRecognizer()
                  //                     ..onTap = followLink,
                  //                 ),
                  //               ]),
                  //             );
                  //         }),
                  //   ],
                  //   ),

                  //                 BlockButtonWidget(
                  //                   onPressed: () {

                  //                     final form = _formKey.currentState;
                  //                      if (isAgreed == true) {

                  //                       _formData['acknowledgement'] = 1;
                  //                       if (_formData['expanding_area'] != null) {
                  //                         //if (_formData['ssm_cert'] != null) {
                  //                           // if (myController2.text != '') {
                  //                           //   final data = reffererList.firstWhere(
                  //                           //       (e) => e['display'] == myController2.text);
                  //                           //   setState(() {
                  //                           //     _formData['referrer_number'] =
                  //                           //         data['member_number'];
                  //                           //     //print(data['member_number']);
                  //                              //}
                  //                           }
                  //                         // } else {
                  //                         //   showDialog<String>(
                  //                         //       context: context,
                  //                         //       builder: (BuildContext context) => AlertDialog(
                  //                         //             title: const Text('SSM Certificate'),
                  //                         //             content: const Text(
                  //                         //                 'Please Upload SSM Certificate Attachment (Type : JPG, PNG, JPEG)'),
                  //                         //             actions: <Widget>[
                  //                         //               TextButton(
                  //                         //                 onPressed: () =>
                  //                         //                     Navigator.pop(context, 'OK'),
                  //                         //                 child: const Text('OK'),
                  //                         //                 style: TextButton.styleFrom(
                  //                         //                     primary: Colors.black),
                  //                         //               ),
                  //                         //             ],
                  //                         //           ));
                  //                         // }

                  //                         final Map arguments =
                  //                             ModalRoute.of(context)!.settings.arguments as Map;
                  //                         arguments.addAll(_formData);
                  //                         // print("_formData");
                  //                         // print(_formData);
                  //                         if (form!.validate()) {
                  //                           form.save();
                  //                           // Navigator.push(
                  //                           //     context,
                  //                           //     MaterialPageRoute(
                  //                           //         builder: (context) =>
                  //                           //             RegisterSelectPlanPage(
                  //                           //                 data: planList,
                  //                           //                 arguments: arguments)));
                  //                           // Navigator.pushNamed(
                  //                           //     context, '/register_select_plan_page',
                  //                           //     arguments: arguments);

                  //                            Navigator.push(
                  //                               context,
                  //                               MaterialPageRoute(
                  //                                   builder: (context) =>
                  //                                       RegisterSuccessfulPage(
                  //                                          arguments: arguments
                  //                                       )));
                  //                             // Navigator.pushNamed(
                  //                             //   context, '/register_successful_page',
                  //                             //   arguments: arguments);

                  //                         }

                  //                       } else {
                  //                         showDialog<String>(
                  //                             context: context,
                  //                             builder: (BuildContext context) => AlertDialog(
                  //                                   title: const Text('Expanding Areas'),
                  //                                   content: const Text(
                  //                                       'Please select one or more for expanding areas'),
                  //                                   actions: <Widget>[
                  //                                     TextButton(
                  //                                       onPressed: () =>
                  //                                           Navigator.pop(context, 'OK'),
                  //                                       child: const Text('OK'),
                  //                                       style: TextButton.styleFrom(
                  //                                           primary: Colors.black),
                  //                                     ),
                  //                                   ],
                  //                                 ));
                  //                       }
                  //                    // } //else {
                  //                     //   _showSuccessMessage(
                  //                     //       context, 'Please agree acknowledgement ?');
                  //                     //  }
                  //                   },
                  //                   color: kPrimaryColor,
                  //                   text: const Text(
                  //                     "Next",
                  //                     style: TextStyle(color: Colors.white),
                  //                   ),
                  //                 ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20),
                  //                 Row(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   children: [
                  //                     TextButton(
                  //                       onPressed: () {
                  //                         // Navigator.popUntil(
                  //                         //     context, ModalRoute.withName('/login_page'));
                  //                         Navigator.pushReplacement(
                  //                           context,
                  //                           PageTransition(
                  //                               type: PageTransitionType.fade,
                  //                               child: const LoginPage()),
                  //                         );
                  //                       },
                  //                       child: const Text("You already have an account?",
                  //                           style: TextStyle(color: kPrimaryColor)),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //  );
                  // }

                  BlocListener<AuthBloc, AuthState>(
                      listener: (BuildContext context, AuthState state) async {
                    print(state);
                    if (state is RegisterSuccessful) {
                      Navigator.pushNamed(context, '/register_successful_page');
                    } else if (state is ErrorOccured) {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Register error'),
                                content: const Text(
                                    'Error occured! Please try again!'),
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
                      return BlockButtonWidget(
                        onPressed: () async {
                          final form = _formKey.currentState;
                          final Map arguments =
                              ModalRoute.of(context)!.settings.arguments as Map;
                          //_formData['package_id'] = widget.data[_current]['id'];
                          arguments.addAll(_formData);
                          print(arguments);
                          if (form!.validate()) {
                            form.save();
                            context.read<AuthBloc>().add(Register(arguments));
                          }
                        },
                        color: kPrimaryColor,
                        text: const Text(
                          "Register",
                          style: TextStyle(color: Colors.white),
                        ),
                      ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20);
                    }
                  })),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Navigator.popUntil(
                          //     context, ModalRoute.withName('/login_page'));
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: const LoginPage()),
                          );
                        },
                        child: const Text("You already have an account?",
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
    );
  }

  void _setInputValue(String field, String value) {
    setState(() => _formData[field] = value.trim());
  }

  void _showSuccessMessage(BuildContext context, String key) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(key), backgroundColor: Colors.red));
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  // _onAddFileClick() async {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Container(
  //             height: 170.0,
  //             padding: const EdgeInsets.all(10.0),
  //             child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
  //                 children: [
  //                   const Text("SSM Certificate"),
  //                   const SizedBox(
  //                     height: 5.0,
  //                   ),
  //                   const Divider(),
  //                   FlatButton(
  //                       child: const Text("Select Image From Gallery"),
  //                       onPressed: () async {
  //                         image = await _picker.pickImage(
  //                             source: ImageSource.gallery, imageQuality: 50);
  //                         print(image);
  //                         selectImage = File(image.path);
  //                         setState(() {
  //                           if (image != null) {
  //                             _formData['ssm_cert'] = image;
  //                             _filename = image.path.split('/').last;

  //                             Navigator.pop(context);
  //                           }
  //                         });
  //                       }),
  //                   FlatButton(
  //                       child: const Text("Take Image From Camera"),
  //                       onPressed: () async {
  //                         image = await _picker.pickImage(
  //                             source: ImageSource.camera, imageQuality: 50);

  //                         setState(() {
  //                           if (image != null) {
  //                             _formData['ssm_cert'] = image;
  //                             _filename = image.path.split('/').last;

  //                             Navigator.pop(context);
  //                           }
  //                         });
  //                       }),
  //                 ]));
  //      });
}
