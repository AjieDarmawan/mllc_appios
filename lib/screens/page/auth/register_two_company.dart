// ignore_for_file: prefer_is_empty
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlcc_app_ios/screens/page/auth/register_view_social_media.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';
import 'package:mlcc_app_ios/screens/page/account/account_view.dart';
import 'package:mlcc_app_ios/widget/checkbox_field_widget.dart';
import 'package:mlcc_app_ios/widget/date_field_widget.dart';
import 'package:mlcc_app_ios/widget/text_field_widget.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../main_view.dart';

class Register_two_company extends StatefulWidget {
  //final List data;
  // final Map arguments;

  const Register_two_company({Key? key}) : super(key: key);

  @override
  _Register_two_companyState createState() => _Register_two_companyState();
}

class _Register_two_companyState extends State<Register_two_company> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> userData = {};
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
  Map<String, dynamic> sample = {};
  final ImagePicker _picker = ImagePicker();
  File? selectImage;
  late String _filename = '';
  var image;
  dynamic initArea = [];
  String uriCert = '';
  bool isdisabled = false;
  final Map<String, dynamic> _formData = {};

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
        if (selectedBusinessNatureID == element['id']) {
          selectedBusinessNature = element['name'];
        }
      }
    });
  }

  int userId = 0;
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
      final _formData_post = {};
      _formData_post['user_id'] = userId;

      // userdata();

      print("_formData_post${_formData_post}");

      if (userId != 0) {
        context.read<AuthBloc>().add(GetUserDetails(_formData_post));
      }
    });
  }

  int run = 0;

  // void userdata() async {
  //   final _formData_post = {};
  //   _formData_post['user_id'] = userId;

  //   var userdatadetail =
  //       await httpProvider.postHttp2("entrepreneur/info", _formData_post);

  //   print(
  //       "userdatadetail${userdatadetail[0]['company_details']['company_country_id']}");
  //   print("userdatadetail-${userdatadetail[0]['company_details']}");

  //   setState(() {
  //     if (userdatadetail[0]['company_details'] != null) {
  //       if (userdatadetail[0]['company_details']['user_id'] != null) {
  //         _formData['user_id'] =
  //             userdatadetail[0]['company_details']['user_id'];
  //         _formData['company_id'] = userdatadetail[0]['company_details']['id'];
  //       } else {
  //         _formData['user_id'] = userId;
  //         _formData['company_id'] = 0;
  //       }
  //       if (userdatadetail[0]['company_details']['company_sales_id'] != null) {
  //         _formData['company_sales_id'] =
  //             userdatadetail[0]['company_details']['company_sales_id'];
  //         selectedSalesID =
  //             userdatadetail[0]['company_details']['company_sales_id'];
  //       }
  //       if (userdatadetail[0]['company_details']['company_name'] != null) {
  //         _formData['company_name'] =
  //             userdatadetail[0]['company_details']['company_name'];
  //       }
  //       if (userdatadetail[0]['company_details']['designation'] != null) {
  //         _formData['designation'] =
  //             userdatadetail[0]['company_details']['designation'];
  //       }
  //       if (userdatadetail[0]['company_details']['business_category_main_id'] !=
  //           null) {
  //         _formData['business_category_main_id'] =
  //             userdatadetail[0]['company_details']['business_category_main_id'];
  //         selectedBusinessNatureID =
  //             userdatadetail[0]['company_details']['business_category_main_id'];
  //         getSubCategory(userdatadetail[0]['company_details']
  //             ['business_category_main_id']);
  //       }
  //       if (userdatadetail[0]['company_details']['business_category_sub_id'] !=
  //           null) {
  //         _formData['business_category_sub_id'] =
  //             userdatadetail[0]['company_details']['business_category_sub_id'];
  //         selectedSubBusinessNatureID =
  //             userdatadetail[0]['company_details']['business_category_sub_id'];
  //       }
  //       if (userdatadetail[0]['company_details']['business_nature'] != null) {
  //         _formData['business_nature'] =
  //             userdatadetail[0]['company_details']['business_nature'];
  //       }
  //       if (userdatadetail[0]['company_details']['expanding_areas'] != null) {
  //         String dataListSelected = "";
  //         initArea = [];
  //         for (var i in userdatadetail[0]['company_details']
  //             ['expanding_areas']) {
  //           dataListSelected = dataListSelected + "," + i;
  //           if (i == 'Networking') {
  //             initArea.add({
  //               'parameter': 'area',
  //               'value': 'Networking',
  //             });
  //           } else if (i == 'Resources') {
  //             initArea.add(
  //               {
  //                 'parameter': 'area',
  //                 'value': 'Resources',
  //               },
  //             );
  //           } else if (i == 'Stronger Team') {
  //             initArea.add(
  //               {
  //                 'parameter': 'area',
  //                 'value': 'Stronger Team',
  //               },
  //             );
  //           } else if (i == 'New Projects') {
  //             initArea.add(
  //               {
  //                 'parameter': 'area',
  //                 'value': 'New Projects',
  //               },
  //             );
  //           } else if (i == 'Increasing Knowledge') {
  //             initArea.add(
  //               {
  //                 'parameter': 'area',
  //                 'value': 'Increasing Knowledge',
  //               },
  //             );
  //           } else if (i == 'Others') {
  //             initArea.add(
  //               {
  //                 'parameter': 'area',
  //                 'value': 'Others',
  //               },
  //             );
  //           }
  //         }

  //         _formData['expanding_areas'] = dataListSelected.substring(1);
  //       }
  //       if (userdatadetail[0]['company_details']['others'] != null) {
  //         _formData['expanding_areas_others'] =
  //             userdatadetail[0]['company_details']['others'];
  //       }

  //       if (userdatadetail[0]['company_details']['expectations'] != null) {
  //         _formData['expectation'] =
  //             userdatadetail[0]['company_details']['expectations'];
  //       }
  //       // if (userdatadetail[0]['company_details']['ssm_cert'] != null) {
  //       //   _formData['ssm_cert'] = userdatadetail[0]['company_details']['ssm_cert'];
  //       // }
  //       if (userdatadetail[0]['company_details']['establish_year'] != null) {
  //         _formData['establish_year'] =
  //             userdatadetail[0]['company_details']['establish_year'];
  //       }
  //       if (userdatadetail[0]['company_details']['company_state_id'] != null) {
  //         _formData['company_state_id'] =
  //             userdatadetail[0]['company_details']['company_state_id'];
  //         selectedStateID =
  //             userdatadetail[0]['company_details']['company_state_id'];
  //       }
  //       if (userdatadetail[0]['company_details']['company_country_id'] !=
  //           null) {
  //         _formData['company_country_id'] =
  //             userdatadetail[0]['company_details']['company_country_id'];
  //         selectedCountryID =
  //             userdatadetail[0]['company_details']['company_country_id'];
  //       }
  //       if (userdatadetail[0]['company_details']['company_address'] != null) {
  //         _formData['company_address'] =
  //             userdatadetail[0]['company_details']['company_address'];
  //       }
  //       if (userdatadetail[0]['company_details']['company_postcode'] != null) {
  //         _formData['company_postcode'] =
  //             userdatadetail[0]['company_details']['company_postcode'];
  //       }
  //       if (userdatadetail[0]['company_details']['company_city'] != null) {
  //         _formData['company_city'] =
  //             userdatadetail[0]['company_details']['company_city'];
  //       }

  //       if (userdatadetail[0]['company_details']['expanding_areas'] != null) {
  //         if (userdatadetail[0]['company_details']['expanding_areas']
  //                 .contains("Others") ==
  //             true) {
  //           showExpandingAreasOther = true;
  //         }
  //       } else {
  //         showExpandingAreasOther = false;
  //       }
  //     }
  //   });
  // }

  @override
  void initState() {
    // final dynamic args = ModalRoute.of(context)!.settings.arguments;

    getBusinessCategory();
    getSalesList();
    getStateList();
    getNationality();
    getUser();
    super.initState();
  }

  List<dynamic> salesList = [];
  List<String> sales = [];
  getSalesList() async {
    salesList = await httpProvider.getHttp("company_sales_turnover");
    setState(() {
      for (var element in salesList) {
        sales.add(element['description']);
        if (selectedSalesID == element['id']) {
          selectedSales = element['description'];
        }
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
        if (selectedStateID == element['id']) {
          selectedState = element['name'];
        }
      }
    });
  }

  List<dynamic> nationalityList = [];
  List<String> nationality = [];
  getNationality() async {
    nationalityList = await httpProvider.getHttp("nationality");
    setState(() {
      for (var element in nationalityList) {
        if (element['name'] != "Others") {
          nationality.add(element['name']);
          if (selectedCountryID == element['id']) {
            selectedCountry = element['name'];
          }
        }
      }
    });
  }

  final Map<String, dynamic> _AreaData = {};
  List<dynamic> SubCategoryList = [];
  List<String> SubCategory = [];
  bool showExpandingSubCategory = false;
  Future<void> getSubCategory(id) async {
    dynamic formDatasubcategory = {'main_id': id};
    print("SubCategoryList${formDatasubcategory}");
    SubCategory = [];
    SubCategoryList = await httpProvider.postHttp(
        "business_category/sub_listing", formDatasubcategory);
    print("SubCategoryListSubCategoryList${SubCategoryList}");
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

  // @override
  // void didChangeDependencies() {
  //   if (run == 0) {
  //     if (userData != null) {
  //       if (userData['user_id'] != null) {
  //         _formData['user_id'] = userData['user_id'];
  //         _formData['company_id'] = userData['id'];
  //       } else {
  //         _formData['user_id'] = userId;
  //         _formData['company_id'] = 0;
  //       }
  //       if (userData['company_sales_id'] != null) {
  //         _formData['company_sales_id'] = userData['company_sales_id'];
  //         selectedSalesID = userData['company_sales_id'];
  //       }
  //       if (userData['company_name'] != null) {
  //         _formData['company_name'] = userData['company_name'];
  //       }
  //       if (userData['designation'] != null) {
  //         _formData['designation'] = userData['designation'];
  //       }
  //       if (userData['business_category_main_id'] != null) {
  //         _formData['business_category_main_id'] =
  //             userData['business_category_main_id'];
  //         selectedBusinessNatureID = userData['business_category_main_id'];
  //         getSubCategory(userData['business_category_main_id']);
  //       }
  //       if (userData['business_category_sub_id'] != null) {
  //         _formData['business_category_sub_id'] =
  //             userData['business_category_sub_id'];
  //         selectedSubBusinessNatureID = userData['business_category_sub_id'];
  //       }
  //       if (userData['business_nature'] != null) {
  //         _formData['business_nature'] = userData['business_nature'];
  //       }
  //       if (userData['expanding_areas'] != null) {
  //         String dataListSelected = "";
  //         initArea = [];
  //         for (var i in userData['expanding_areas']) {
  //           dataListSelected = dataListSelected + "," + i;
  //           if (i == 'Networking') {
  //             initArea.add({
  //               'parameter': 'area',
  //               'value': 'Networking',
  //             });
  //           } else if (i == 'Resources') {
  //             initArea.add(
  //               {
  //                 'parameter': 'area',
  //                 'value': 'Resources',
  //               },
  //             );
  //           } else if (i == 'Stronger Team') {
  //             initArea.add(
  //               {
  //                 'parameter': 'area',
  //                 'value': 'Stronger Team',
  //               },
  //             );
  //           } else if (i == 'New Projects') {
  //             initArea.add(
  //               {
  //                 'parameter': 'area',
  //                 'value': 'New Projects',
  //               },
  //             );
  //           } else if (i == 'Increasing Knowledge') {
  //             initArea.add(
  //               {
  //                 'parameter': 'area',
  //                 'value': 'Increasing Knowledge',
  //               },
  //             );
  //           } else if (i == 'Others') {
  //             initArea.add(
  //               {
  //                 'parameter': 'area',
  //                 'value': 'Others',
  //               },
  //             );
  //           }
  //         }

  //         _formData['expanding_areas'] = dataListSelected.substring(1);
  //       }
  //       if (userData['others'] != null) {
  //         _formData['expanding_areas_others'] = userData['others'];
  //       }

  //       if (userData['expectations'] != null) {
  //         _formData['expectation'] = userData['expectations'];
  //       }
  //       // if (userData['ssm_cert'] != null) {
  //       //   _formData['ssm_cert'] = userData['ssm_cert'];
  //       // }
  //       if (userData['establish_year'] != null) {
  //         _formData['establish_year'] = userData['establish_year'];
  //       }
  //       if (userData['company_state_id'] != null) {
  //         _formData['company_state_id'] = userData['company_state_id'];
  //         selectedStateID = userData['company_state_id'];
  //       }
  //       if (userData['company_country_id'] != null) {
  //         _formData['company_country_id'] = userData['company_country_id'];
  //         selectedCountryID = userData['company_country_id'];
  //       }
  //       if (userData['company_address'] != null) {
  //         _formData['company_address'] = userData['company_address'];
  //       }
  //       if (userData['company_postcode'] != null) {
  //         _formData['company_postcode'] = userData['company_postcode'];
  //       }
  //       if (userData['company_city'] != null) {
  //         _formData['company_city'] = userData['company_city'];
  //       }

  //       if (userData['expanding_areas'] != null) {
  //         if (userData['expanding_areas'].contains("Others") == true) {
  //           showExpandingAreasOther = true;
  //         }
  //       } else {
  //         showExpandingAreasOther = false;
  //       }
  //     }

  //     run++;
  //   }
  //   super.didChangeDependencies();
  // }

  var countcompany = 0;
  @override
  Widget build(BuildContext context) {
    setState(() {
      countcompany++;
      print("tes--countcompany${countcompany}");
    });

    return BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState state) {
      if (state is GetUserDetailsSuccessful) {
        userData = state.userData[0]['company_details'];

        print("userdata${userData['business_category_main_id']}");
        // if (countcompany == 1) {
        if (userData != null) {
          if (userData['user_id'] != null) {
            _formData['user_id'] = userData['user_id'];
            _formData['company_id'] = userData['id'];
          } else {
            _formData['user_id'] = userId;
            _formData['company_id'] = 0;
          }
          if (userData['company_sales_id'] != null) {
            _formData['company_sales_id'] = userData['company_sales_id'];
            selectedSalesID = userData['company_sales_id'];
          }
          if (userData['company_name'] != null) {
            _formData['company_name'] = userData['company_name'];
          }
          if (userData['designation'] != null) {
            _formData['designation'] = userData['designation'];
          }
          if (countcompany <= 10) {
            if (userData['business_category_main_id'] != null) {
              _formData['business_category_main_id'] =
                  userData['business_category_main_id'];
              selectedBusinessNatureID = userData['business_category_main_id'];
              print("business_category_main_id${selectedBusinessNatureID}");
              getSubCategory(userData['business_category_main_id']);
            }
          }
          if (userData['business_category_sub_id'] != null) {
            _formData['business_category_sub_id'] =
                userData['business_category_sub_id'];
            selectedSubBusinessNatureID = userData['business_category_sub_id'];
          }
          if (userData['business_nature'] != null) {
            _formData['business_nature'] = userData['business_nature'];
          }
          if (userData['expanding_areas'] != null) {
            String dataListSelected = "";
            initArea = [];
            for (var i in userData['expanding_areas']) {
              dataListSelected = dataListSelected + "," + i;
              if (i == 'Networking') {
                initArea.add({
                  'parameter': 'area',
                  'value': 'Networking',
                });
              } else if (i == 'Resources') {
                initArea.add(
                  {
                    'parameter': 'area',
                    'value': 'Resources',
                  },
                );
              } else if (i == 'Stronger Team') {
                initArea.add(
                  {
                    'parameter': 'area',
                    'value': 'Stronger Team',
                  },
                );
              } else if (i == 'New Projects') {
                initArea.add(
                  {
                    'parameter': 'area',
                    'value': 'New Projects',
                  },
                );
              } else if (i == 'Increasing Knowledge') {
                initArea.add(
                  {
                    'parameter': 'area',
                    'value': 'Increasing Knowledge',
                  },
                );
              } else if (i == 'Others') {
                initArea.add(
                  {
                    'parameter': 'area',
                    'value': 'Others',
                  },
                );
              }
            }

            _formData['expanding_areas'] = dataListSelected.substring(1);
          }
          if (userData['others'] != null) {
            _formData['expanding_areas_others'] = userData['others'];
          }

          if (userData['expectations'] != null) {
            _formData['expectation'] = userData['expectations'];
          }
          // if (userData['ssm_cert'] != null) {
          //   _formData['ssm_cert'] = userData['ssm_cert'];
          // }
          if (userData['establish_year'] != null) {
            _formData['establish_year'] = userData['establish_year'];
          }
          if (userData['company_state_id'] != null) {
            _formData['company_state_id'] = userData['company_state_id'];
            selectedStateID = userData['company_state_id'];
          }
          if (userData['company_country_id'] != null) {
            _formData['company_country_id'] = userData['company_country_id'];
            selectedCountryID = userData['company_country_id'];
          }
          if (userData['company_address'] != null) {
            _formData['company_address'] = userData['company_address'];
          }
          if (userData['company_postcode'] != null) {
            _formData['company_postcode'] = userData['company_postcode'];
          }
          if (userData['company_city'] != null) {
            _formData['company_city'] = userData['company_city'];
          }

          if (userData['expanding_areas'] != null) {
            if (userData['expanding_areas'].contains("Others") == true) {
              showExpandingAreasOther = true;
            }
          } else {
            showExpandingAreasOther = false;
          }
        }
        // }

        return _buildContent(context, userData);
      } else {
        return WillPopScope(
          onWillPop: () async {
            return backtoPrevious();
          },
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.keyboard_arrow_left, size: 30),
                ),
                title: const Text(
                  "Company Information",
                  style: TextStyle(
                    color: kSecondaryColor,
                  ),
                ),
                centerTitle: true,
                backgroundColor: kPrimaryColor,
                elevation: 0,
                actions: [
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (BuildContext context) =>
                  //                 RegisterviewSocialMedia()));
                  //   },
                  //   child: Text("Skip",
                  //       style: TextStyle(
                  //         color: kSecondaryColor,
                  //       )),
                  // )
                ],
              ),
              body: const LoadingWidget()),
        );
        // return const LoadingWidget();
      }
    });
  }

  backtoPrevious() {
    Navigator.pop(context);
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> userData) {
    bool _disableEdit = false;

    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            "Company Information",
            style: TextStyle(
              color: kSecondaryColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
          actions: [
            // TextButton(
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (BuildContext context) =>
            //                 RegisterviewSocialMedia()));
            //   },
            //   child: Text("Skip",
            //       style: TextStyle(
            //         color: kSecondaryColor,
            //       )),
            // )
          ],
        ),
        // bottomNavigationBar:

        body: DelayedDisplay(
          delay: const Duration(
            milliseconds: 600,
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(primary: true, children: [
              TextFieldWidget(
                labelText: "Company Name",
                mandatory: "*",
                iconData: FontAwesomeIcons.building,
                //iconData: Icons.ac_unit,
                setValue: _setInputValue,
                field: 'company_name',
                validator:
                    RequiredValidator(errorText: 'Company Name is required'),
                initialValue: _formData['company_name'],
              ),
              TextFieldWidget(
                labelText: "Designation",
                iconData: Icons.business_center_rounded,
                setValue: _setInputValue,
                field: 'designation',
                mandatory: "*",
                validator:
                    RequiredValidator(errorText: 'Designation is required'),
                initialValue: _formData['designation'],
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 14, left: 20, right: 20),
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                    DropdownSearch<String>(
                      mode: Mode.BOTTOM_SHEET,
                      showSelectedItems: true,
                      items: businessCategory,
                      label: "Business Category",
                      onChanged: (item) {
                        final data = businessCategoryList
                            .firstWhere((e) => e['name'] == item);
                        _formData['business_category_main_id'] = data['id'];
                        getSubCategory(data['id']);
                        setState(() {
                          selectedBusinessNature = data['name'];
                          selectedSubBusinessNature = "";
                        });
                      },
                      onSaved: (item) {
                        final data = businessCategoryList
                            .firstWhere((e) => e['name'] == item);
                        _formData['business_category_main_id'] = data['id'];
                      },
                      selectedItem: selectedBusinessNature,
                      validator: (item) {
                        if (item == null || item == '') {
                          return "Please select a Business Category";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
              // Container(
              //   padding: const EdgeInsets.only(
              //       top: 20, bottom: 14, left: 20, right: 20),
              //   margin: const EdgeInsets.only(
              //       left: 20, right: 20, top: 0, bottom: 0),
              //   decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: const BorderRadius.all(Radius.circular(10)),
              //       boxShadow: [
              //         BoxShadow(
              //             color: Get.theme.focusColor.withOpacity(0.1),
              //             blurRadius: 10,
              //             offset: const Offset(0, 5)),
              //       ],
              //       border: Border.all(
              //           color: Get.theme.focusColor.withOpacity(0.05))),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     children: [
              //       Text(
              //         "Business Category",
              //         style: Get.textTheme.bodyText1,
              //         textAlign: TextAlign.start,
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: DropdownSearch<String>(
              //           mode: Mode.BOTTOM_SHEET,
              //           showSelectedItems: true,
              //           items: businessCategory,
              //           // label: "Business Category",
              //           onChanged: (item) {
              //             final data = businessCategoryList
              //                 .firstWhere((e) => e['name'] == item);
              //             _formData['business_category_main_id'] = data['id'];
              //             getSubCategory(data['id']);
              //             setState(() {
              //               selectedBusinessNature = data['name'];
              //               selectedSubBusinessNature = "";
              //             });
              //           },
              //           onSaved: (item) {
              //             final data = businessCategoryList
              //                 .firstWhere((e) => e['name'] == item);
              //             _formData['business_category_main_id'] = data['id'];
              //           },
              //           selectedItem: selectedBusinessNature,
              //           validator: (item) {
              //             if (item == null) {
              //               return "Please select a Business Category";
              //             } else {
              //               return null;
              //             }
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
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
                              //label: "Sub Category of Business",
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
                              validator: (item) {
                                if (item == null || item == '') {
                                  return "Please select sub business category";
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
                setValue: _setInputValue,
                field: 'business_nature',
                mandatory: "*",
                initialValue: _formData['business_nature'],
                validator:
                    RequiredValidator(errorText: 'Business Nature is required'),
              ),
              TextFieldWidget(
                labelText: "Establish Year",
                mandatory: "*",
                hintText: "Ex: 2022",
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                ],
                keyboardType: TextInputType.number,
                iconData: Icons.today,
                setValue: _setInputValue,
                field: 'establish_year',
                initialValue: _formData['establish_year'],
                validator:
                    RequiredValidator(errorText: 'Establish Year is required'),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 14, left: 20, right: 20),
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 0, bottom: 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(0)),
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
                    CustomSearchableDropDown(
                        items: listToSearch,
                        label: 'Expanding Areas',
                        multiSelectTag: 'Expanding Areas',
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
                                  dataListSelected + ',' + data[i]['area'];
                              if (data[i]['area'].contains("Others") == true) {
                                setState(() {
                                  showExpandingAreasOther = true;
                                });
                              } else {
                                setState(() {
                                  showExpandingAreasOther = false;
                                });
                              }
                            }
                            _formData['expanding_areas'] =
                                dataListSelected.substring(1);
                            print(_formData['expanding_areas']);
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
                      hintText: "Others",
                      keyboardType: TextInputType.multiline,
                      iconData: Icons.expand,
                      isFirst: false,
                      isLast: false,
                      setValue: _setInputValue,
                      field: 'expanding_areas_others',
                      initialValue: _formData['expanding_areas_others'],
                      // validator:
                      //     RequiredValidator(errorText: 'Others is required'),
                    )
                  : Container(),
              TextFieldWidget(
                labelText: "Expectations",
                hintText: "Expectations",
                mandatory: "*",
                iconData: Icons.chat_rounded,
                keyboardType: TextInputType.multiline,
                isFirst: false,
                isLast: true,
                setValue: _setInputValue,
                field: 'expectation',
                initialValue: _formData['expectation'],
                validator:
                    RequiredValidator(errorText: 'Expectations is required'),
              ),
              TextFieldWidget(
                labelText: "Company Address",
                hintText: "Company Address",
                keyboardType: TextInputType.multiline,
                iconData: Icons.home,
                mandatory: "*",
                // keyboardType: TextInputType.phone,
                setValue: _setInputValue,
                initialValue: _formData['company_address'],
                field: 'company_address',
                isFirst: true,
                isLast: false,
                validator:
                    RequiredValidator(errorText: 'Company Address is required'),
              ),
              TextFieldWidget(
                labelText: "Postcode",
                hintText: "Postcode",
                mandatory: "*",
                keyboardType: TextInputType.number,
                iconData: Icons.home,
                // keyboardType: TextInputType.phone,
                setValue: _setInputValue,
                initialValue: _formData['company_postcode'],
                field: 'company_postcode',
                isFirst: false,
                validator: RequiredValidator(
                    errorText: 'Company Postcode is required'),
                isLast: false,
              ),
              TextFieldWidget(
                labelText: "City",
                hintText: "City",
                mandatory: "*",
                iconData: Icons.home,
                // keyboardType: TextInputType.phone,
                setValue: _setInputValue,
                initialValue: _formData['company_city'],
                field: 'company_city',
                isFirst: false,
                isLast: false,
                validator:
                    RequiredValidator(errorText: 'Company City is required'),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 14, left: 20, right: 20),
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 0, bottom: 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(0)),
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
                          _formData['company_state_id'] = '';
                          final data =
                              stateList.firstWhere((e) => e['name'] == item);
                          _formData['company_state_id'] = data['id'];
                          setState(() {
                            selectedState = data['name'];
                          });
                        },
                        onSaved: (item) {
                          final data =
                              stateList.firstWhere((e) => e['name'] == item);
                          _formData['company_state_id'] = data['id'];
                        },
                        selectedItem: selectedState,
                        validator: (item) {
                          if (item == null || item == '') {
                            return "Please select state";
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
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(10)),
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
                          "Country",
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
                        //  label: "Country",
                        onChanged: (item) {
                          _formData['company_country_id'] = '';
                          final data = nationalityList
                              .firstWhere((e) => e['name'] == item);
                          _formData['company_country_id'] = data['id'];
                          setState(() {
                            selectedCountry = data['name'];
                          });
                        },
                        onSaved: (item) {
                          final data = nationalityList
                              .firstWhere((e) => e['name'] == item);
                          _formData['company_country_id'] = data['id'];
                        },
                        selectedItem: selectedCountry,
                        validator: (item) {
                          if (item == null || item == '') {
                            return "Please select country";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: isdisabled == true ? 0 : 90,
                child: Column(
                  children: [
                    if (isdisabled == false)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: kThirdColor.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, -5)),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: MaterialButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    RegisterviewSocialMedia()));
                                      },
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      color: kPrimaryColor,
                                      child: const Text("Skip",
                                          style: TextStyle(
                                              color: kSecondaryColor)),
                                      elevation: 0,
                                      highlightElevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: MaterialButton(
                                    onPressed: () {
                                      final form = _formKey.currentState;
                                      if (form!.validate()) {
                                        _formData['user_id'] = userId;
                                        print("cekduu");
                                        form.save();
                                        print("cekduu${_formData}");
                                        // if (_filename != '') {
                                        //   print("cekduu123");
                                        context.read<AuthBloc>().add(
                                            UpdateCompanyDetail(_formData));
                                        Timer(
                                            const Duration(milliseconds: 1000),
                                            () {
                                          // Navigator.of(context)
                                          //     .popUntil((route) => route.isFirst);

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      RegisterviewSocialMedia()));
                                          // Navigator.pushReplacement(
                                          //     context,
                                          //     PageTransition(
                                          //       type: PageTransitionType.fade,
                                          //       child: const MainScreen(
                                          //         page: AccountViewPage(),
                                          //         index: 4,
                                          //       ),
                                          //     ));
                                          _showSuccessMessage(context,
                                              'Update Personal Basic Info Successful');
                                        });
                                      }
                                    },
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: kPrimaryColor,
                                    child: const Text("Save",
                                        style:
                                            TextStyle(color: kSecondaryColor)),
                                    elevation: 0,
                                    highlightElevation: 0,
                                    hoverElevation: 0,
                                    focusElevation: 0,
                                  ),
                                ),
                              ],
                            ).paddingSymmetric(vertical: 10, horizontal: 20),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }

  void _setInputValue(String field, String value) {
    setState(() => _formData[field] = value.trim());
  }

  void _setCheckboxValue(bool value) {
    setState(() {
      currentlyWorking = value;
      if (value == true) {
        _formData['current_role'] = 1;
      } else {
        _formData['current_role'] = 0;
      }
      // _formData['current_role'] = value;
    });
  }

  void _showSuccessMessage(BuildContext context, String key) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(key), backgroundColor: Colors.green));
  }
}
