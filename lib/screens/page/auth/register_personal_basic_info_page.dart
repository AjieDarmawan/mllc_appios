// ignore_for_file: prefer_is_empty

import 'package:delayed_display/delayed_display.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  List<String> title = [];
  getTitle() async {
    titleList = await httpProvider.getHttp("title");
    setState(() {
      for (var element in titleList) {
        title.add(element['title']);
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

  @override
  void initState() {
    getTitle();
    getNationality();
    getStateList();
    super.initState();
  }

  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'first_name': null,
    'last_name': null,
    'identity_card': null,
    'phone_number': null
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFieldWidget(
                      labelText: "Email Address",
                      hintText: "johndoe@gmail.com",
                      iconData: Icons.alternate_email,
                      keyboardType: TextInputType.emailAddress,
                      isFirst: true,
                      isLast: false,
                      setValue: _setInputValue,
                      field: 'email',
                      validator: emailValidator),
                  TextFieldWidget(
                    obscureText: hidePassword,
                    labelText: "Password",
                    hintText: "••••••••••••",
                    iconData: Icons.lock_outline,
                    keyboardType: TextInputType.visiblePassword,
                    isFirst: false,
                    isLast: false,
                    setValue: _setInputValue,
                    field: 'password',
                    validator: passwordValidator,
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
                          "Title",
                          style: Get.textTheme.bodyText1,
                          textAlign: TextAlign.start,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownSearch<String>(
                            mode: Mode.BOTTOM_SHEET,
                            showSelectedItems: true,
                            items: title,
                            label: "Title",
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
                    hintText: "Lee Wei Wei",
                    iconData: Icons.person_outline,
                    isFirst: false,
                    isLast: false,
                    setValue: _setInputValue,
                    field: 'name',
                    validator: RequiredValidator(errorText: 'Name is required'),
                  ),
                  TextFieldWidget(
                    labelText: "Preferred Name",
                    hintText: "Shirley Lee",
                    iconData: Icons.person_outline,
                    isFirst: false,
                    isLast: false,
                    setValue: _setInputValue,
                    field: 'preferred_name',
                  ),
                  TextFieldWidget(
                    labelText: "Chinese Name",
                    hintText: "李薇薇",
                    iconData: Icons.person_outline,
                    isFirst: false,
                    isLast: false,
                    setValue: _setInputValue,
                    field: 'chinese_name',
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
                          "Nationality",
                          style: Get.textTheme.bodyText1,
                          textAlign: TextAlign.start,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownSearch<String>(
                            mode: Mode.BOTTOM_SHEET,
                            showSelectedItems: true,
                            items: nationality,
                            label: "Nationality",
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
                          hintText: "Others",
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
                                  color:
                                      Get.theme.focusColor.withOpacity(0.05))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "State",
                                style: Get.textTheme.bodyText1,
                                textAlign: TextAlign.start,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownSearch<String>(
                                  mode: Mode.BOTTOM_SHEET,
                                  showSelectedItems: true,
                                  items: state,
                                  label: "State",
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
                      ? TextFieldWidget(
                          labelText: "Identity Card",
                          hintText: "XXXXXX-XX-XXXX",
                          iconData: Icons.ac_unit,
                          //iconData: FontAwesomeIcons.solidAddressCard,
                          inputFormatters: [maskFormatter],
                          // keyboardType: TextInputType.number,
                          isFirst: false,
                          isLast: false,
                          setValue: _setInputValue,
                          field: 'identity_card',
                          validator: identityCardValidator,
                        )
                      : Container(),
                  showExpandingNationalityOther == true
                      ? TextFieldWidget(
                          labelText: "Passport No (For Non-Malaysians)",
                          hintText: "XXXXXXXXXXXXXXXX",
                          iconData: Icons.ac_unit,
                          //iconData: FontAwesomeIcons.solidAddressCard,
                          isFirst: false,
                          isLast: false,
                          setValue: _setInputValue,
                          keyboardType: TextInputType.number,
                          field: 'passport_number',
                        )
                      : Container(),

                  TextFieldWidget(
                    labelText: "Phone Number",
                    hintText: "0123456789",
                    iconData: Icons.phone_iphone,
                    keyboardType: TextInputType.phone,
                    isFirst: false,
                    isLast: true,
                    setValue: _setInputValue,
                    field: 'phone_number',
                    validator: phoneNumberValidator,
                  ),

                  BlocListener<AuthBloc, AuthState>(
                      listener: (BuildContext context, AuthState state) async {
                    if (state is ValidEmail) {
                      Navigator.pushNamed(context, '/register_company_page',
                          arguments: _formData);
                    } else if (state is InvalidEmail) {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Register Error'),
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
                      return BlockButtonWidget(
                        onPressed: () async {
                          _formData['phone_number'] =
                              "+6${_formData['phone_number']}";
                          final form = _formKey.currentState;
                          if (form!.validate()) {
                            form.save();
                            context.read<AuthBloc>().add(CheckEmail(_formData));
                          }
                        },
                        color: kPrimaryColor,
                        text: const Text(
                          "Next",
                          style: TextStyle(color: Colors.white),
                        ),
                      ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20);
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

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Please enter an valid email')
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(6, errorText: 'Password must be at least 6 digits long'),
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
    MaxLengthValidator(11, errorText: 'Phone Number must follow the format'),
    PatternValidator(r'(01[0-9]{8,9})',
        errorText: 'Phone Number must follow the format'),
  ]);
}
