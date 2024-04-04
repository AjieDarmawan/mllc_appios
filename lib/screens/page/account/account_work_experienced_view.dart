import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:provider/src/provider.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';
import 'package:mlcc_app_ios/widget/checkbox_field_widget.dart';
import 'package:mlcc_app_ios/widget/date_field_widget.dart';
import 'package:mlcc_app_ios/widget/text_field_widget.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AccountWorkExperiencedViewPage extends StatefulWidget {
  const AccountWorkExperiencedViewPage({Key? key}) : super(key: key);

  @override
  _AccountWorkExperiencedViewPageState createState() =>
      _AccountWorkExperiencedViewPageState();
}

class _AccountWorkExperiencedViewPageState
    extends State<AccountWorkExperiencedViewPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool currentlyWorking = false;
  String selectedBusinessNature = "";
  String selectedSubBusinessNature = "";

  final Map<String, dynamic> _formData = {
    'work_experience_id': null,
    'entity': null,
    'start_date': null,
    'end_date': null,
    'current_role': 0
  };

  List<String> organizationEntity = [
    'Sole Proprietorship',
    'Private Limited Company',
    'Public Listed Company',
    'Partnership'
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

  @override
  void initState() {
    // final dynamic args = ModalRoute.of(context)!.settings.arguments;
    getBusinessCategory();
    super.initState();
  }

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
      }
    });
  }

  @override
  void didChangeDependencies() {
    final dynamic args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      _formData['work_experience_id'] = args['data']['id'];
      _formData['company_name'] = args['data']['company_name'];
      _formData['entity'] = args['data']['entity'];
      _formData['designation'] = args['data']['designation'];
      if (args['data']['business_category'] != null) {
        selectedBusinessNature = args['data']['business_category'];
        getSubCategory(args['data']['business_category_id']);
      }
      if (args['data']['sub_business_category'] != null) {
        selectedSubBusinessNature = args['data']['sub_business_category'];
      }
      _formData['start_date'] = args['data']['start_date'];
      _formData['end_date'] = args['data']['end_date'];
      _formData['current_role'] = args['data']['current_role'];
      if (args['data']['current_role'] == 1) {
        currentlyWorking = true;
      } else if (args['data']['current_role'] == 0) {
        currentlyWorking = false;
      }
    }
    super.didChangeDependencies();
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
          // resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text(
              "Work Experienced",
              style: TextStyle(
                color: kSecondaryColor,
              ),
            ),
            centerTitle: true,
            backgroundColor: kPrimaryColor,
            elevation: 0,
          ),
          //   bottomNavigationBar:
          body: DelayedDisplay(
            delay: const Duration(
              milliseconds: 600,
            ),
            child: Form(
              key: _formKey,
              child: ListView(primary: true, children: [
                TextFieldWidget(
                  labelText: "Company Name",
                  mandatory: "*",
                  //iconData: Icons.ac_unit,
                  iconData: FontAwesomeIcons.building,
                  setValue: _setInputValue,
                  field: 'company_name',

                  isFirst: true,
                  isLast: false,
                  initialValue: _formData['company_name'],
                  validator:
                      RequiredValidator(errorText: 'Company Name is required'),
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
                            "  Organization Entity",
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
                          items: organizationEntity,
                          //label: "Organization Entity",
                          onChanged: (item) {
                            _formData['entity'] = item;
                          },
                          onSaved: (item) {
                            _formData['entity'] = item;
                          },
                          selectedItem: _formData['entity'],
                          validator: (item) {
                            if (item == null) {
                              return "Please select an organization entity";
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
                  labelText: "Designation",
                  iconData: Icons.business_center_rounded,
                  setValue: _setInputValue,
                  mandatory: "*",
                  field: 'designation',
                  validator:
                      RequiredValidator(errorText: 'Designation is required'),
                  initialValue: _formData['designation'],
                ),
                // TextFieldWidget(
                //   labelText: "Designation",
                //   iconData: Icons.business_center_rounded,
                //   setValue: _setInputValue,
                //   field: 'designation',
                //   validator:
                //       RequiredValidator(errorText: 'Designation is required'),
                //   initialValue: _formData['designation'],
                // ),
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
                      Row(
                        children: [
                          Text(
                            "  Business Category",
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
                          items: businessCategory,
                          //label: "Business Category",
                          onChanged: (item) {
                            final data = businessCategoryList
                                .firstWhere((e) => e['name'] == item);
                            _formData['business_category_main_id'] = data['id'];
                            showExpandingSubCategory = true;
                            getSubCategory(data['id']);
                          },
                          onSaved: (item) {
                            final data = businessCategoryList
                                .firstWhere((e) => e['name'] == item);
                            _formData['business_category_main_id'] = data['id'];
                          },
                          selectedItem: selectedBusinessNature,
                          validator: (item) {
                            print("itembisnis${item}");
                            if (item == '' || item == null) {
                              print("itembisnis--a");
                              return "Please select a Business Category";
                            } else {
                              print("itembisnis--b");
                              return null;
                              //return "Please select a Business Category";
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
                                  "   Sub Category of Business",
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
                                  if (item == '' || item == null) {
                                    return "Please select sub business category";
                                  } else {
                                    return null;
                                    //return "Please select sub business category";
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Container(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 14, left: 20, right: 20),
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 0, bottom: 0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(10)),
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
                        "Is Current Role",
                        style: Get.textTheme.bodyText1,
                        textAlign: TextAlign.start,
                      ),
                      CheckboxField(
                          translateLabel: 'Is Currently Working',
                          value: currentlyWorking,
                          setCheckboxValue: _setCheckboxValue,
                          icon: FontAwesomeIcons.briefcase
                          //icon: Icons.ac_unit,
                          )
                    ],
                  ),
                ),
                DateFieldWidget(
                  labelText: "Start Date",
                  mandatory: "*",
                  //iconData: Icons.ac_unit,
                  iconData: FontAwesomeIcons.solidCalendarAlt,
                  keyboardType: TextInputType.datetime,
                  isFirst: false,
                  isLast: currentlyWorking,
                  setValue: _setInputValue,
                  field: 'start_date',
                  validator:
                      RequiredValidator(errorText: 'Start Date is required'),
                  initialValue: _formData['start_date'],
                ),
                currentlyWorking == false
                    ? DateFieldWidget(
                        labelText: "End Date",
                        // iconData: Icons.ac_unit,
                        iconData: FontAwesomeIcons.solidCalendarAlt,
                        keyboardType: TextInputType.datetime,
                        isFirst: false,
                        isLast: true,
                        mandatory: "*",
                        setValue: _setInputValue,
                        field: 'end_date',
                        validator: RequiredValidator(
                            errorText: 'End Date is required'),
                        initialValue: _formData['end_date'],
                      )
                    : Container(),

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
                  child: Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          onPressed: () {
                            final form = _formKey.currentState;
                            if (form!.validate()) {
                              form.save();
                              context
                                  .read<AuthBloc>()
                                  .add(CreateUpdateWorkExperienced(_formData));
                              Navigator.pop(context);
                            }
                          },
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: kPrimaryColor,
                          child: const Text("Save",
                              style: TextStyle(color: kSecondaryColor)),
                          elevation: 0,
                          highlightElevation: 0,
                          hoverElevation: 0,
                          focusElevation: 0,
                        ),
                      ),
                    ],
                  ).paddingSymmetric(vertical: 10, horizontal: 20),
                ),
              ]),
            ),
          )),
    );
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
}
