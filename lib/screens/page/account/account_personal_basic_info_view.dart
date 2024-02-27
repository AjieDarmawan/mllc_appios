// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';
import 'package:mlcc_app_ios/widget/text_field_widget.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AccountPersonalBasicInfoViewPage extends StatefulWidget {
  final dynamic data;
  final String? first;
  final bool disableEdit;

  const AccountPersonalBasicInfoViewPage(
      {Key? key, this.data, this.first, required this.disableEdit})
      : super(key: key);

  @override
  _AccountPersonalBasicInfoViewPageState createState() =>
      _AccountPersonalBasicInfoViewPageState();
}

class _AccountPersonalBasicInfoViewPageState
    extends State<AccountPersonalBasicInfoViewPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? selectImage;
  bool hidePassword = true;
  bool isMaleSelected = false;
  bool isFemaleSelected = false;
  bool isOthersSelected = false;
  // bool widget.disableEdit = false;
  var membershipExpiryDate;
  var membershipRenewalDate;
  var thumbnail = "";
  String fileName = "";
  var image;
  var email = "";

  final Map<String, dynamic> _formData = {
    'new_password': null,
    'password': null,
    'identity_card': null,
    'phone_number': null,
    'gender': null,
    'introduction': null,
    'thumbnail': null,
    'title_id': null,
    'nationality_id': null,
    'state_id': null,
    'name': null,
    'preferred_name': null,
    'chinese_name': null,
    'passport_number': null,
    'others_nationality': null,
    'others_state': null
  };

  // @override
  // void didChangeDependencies() {
  //   final dynamic args = ModalRoute.of(context)!.settings.arguments;
  //   if (args != null) {
  //     _formData['title_id'] = widget.data['title_id'];
  //     _formData['nationality_id'] = widget.data['nationality_id'];
  //     _formData['state_id'] = widget.data['state_id'];
  //     _formData['name'] = widget.data['name'];
  //     _formData['preferred_name'] = widget.data['preferred_name'];
  //     _formData['chinese_name'] = widget.data['chinese_name'];
  //     _formData['identity_card'] = widget.data['identity_card'];
  //     _formData['phone_number'] = widget.data['phone_number'];
  //     _formData['passport_number'] = widget.data['passport_number'];
  //     _formData['others_nationality'] = widget.data['others_nationality'];
  //     _formData['others_state'] = widget.data['others_state'];
  //     email = widget.data['email'];
  //     if (widget.data['thumbnail'] != null) {
  //       thumbnail = widget.data['thumbnail'];
  //     }
  //     membershipExpiryDate = widget.data['expired_date'];
  //     membershipRenewalDate = widget.data['renewal_date'];
  //   }
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    _formData['user_id'] = widget.data['id'];
    _formData['title_id'] = widget.data['title_id'];
    _formData['nationality_id'] = widget.data['nationality_id'];
    _formData['state_id'] = widget.data['state_id'];
    _formData['name'] = widget.data['name'];
    _formData['preferred_name'] = widget.data['preferred_name'];
    _formData['chinese_name'] = widget.data['chinese_name'];
    _formData['identity_card'] = widget.data['identity_card'];
    _formData['phone_number'] = widget.data['phone_number'];
    _formData['passport_number'] = widget.data['passport_number'];
    _formData['others_nationality'] = widget.data['others_nationality'];
    _formData['others_state'] = widget.data['others_state'];
    _formData['gender'] = widget.data['gender'];
    _formData['introduction'] = widget.data['introduction'];
    email = widget.data['email'];
    if (widget.data['gender'] == 'Male') {
      setState(() {
        isMaleSelected = true;
        isFemaleSelected = false;
        isOthersSelected = false;
      });
    } else if (widget.data['gender'] == 'Female') {
      setState(() {
        isMaleSelected = false;
        isFemaleSelected = true;
        isOthersSelected = false;
      });
    } else {
      setState(() {
        isMaleSelected = false;
        isFemaleSelected = false;
        isOthersSelected = true;
      });
    }
    if (widget.data['thumbnail'] != null) {
      thumbnail = widget.data['thumbnail'];
    }
    membershipExpiryDate = widget.data['expired_date'];
    membershipRenewalDate = widget.data['renewal_date'];

    membershipExpiryDate = widget.data['expired_date'];
    membershipRenewalDate = widget.data['renewal_date'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("gender123${widget.data['gender']}");
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Personal Basic Info",
            style: TextStyle(
              color: kSecondaryColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        bottomNavigationBar: SizedBox(
          height: widget.disableEdit == true ? 0 : 90,
          child: Column(
            children: [
              if (widget.disableEdit == false)
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
                            if ((_formData['new_password'] != null &&
                                    _formData['new_password'] != "") &&
                                (_formData['password'] != null &&
                                    _formData['password'] != "") &&
                                (_formData['new_password'] !=
                                    _formData['password'])) {
                              _showErrorMessage(
                                  context, 'Please confirm your new password!');
                            } else {
                              _formData['phone_number'] =
                                  "+6${_formData['phone_number']}";
                              final form = _formKey.currentState;
                              if (form!.validate()) {
                                form.save();
                                context
                                    .read<AuthBloc>()
                                    .add(UpdateUserDetail(_formData));
                                Timer(const Duration(milliseconds: 500),
                                    () async {
                                  if (widget.first != null) {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool("isLoggedIn", true);
                                    // prefs.setString("email", _formData['email']);
                                    prefs.setString(
                                        "username", _formData['name']);
                                    prefs.setInt(
                                        "userId", _formData['user_id']);
                                    prefs.setBool("isExpired", false);
                                    var updateAccessDataReturn =
                                        await httpProvider
                                            .postHttp("last_access", {
                                      'user_id': _formData['user_id'],
                                      'push_token':
                                          prefs.getString("OneSignalPlayerID"),
                                      'push_token_status': '1'
                                    });
                                    _showSuccessMessage(context,
                                        'Update Personal Basic Info Successful');
                                    if (updateAccessDataReturn == "Success") {
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                      Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.fade,
                                          child: const MainScreen(
                                            page: HomePage(),
                                            index: 0,
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    Navigator.pop(context);
                                  }
                                });
                              }
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
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(primary: true, children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Container(
                  height: 130,
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
                      children: [
                        if (widget.disableEdit == false)
                          const Text("Press the image to change",
                              style: TextStyle(
                                  color: kSecondaryColor,
                                  fontStyle: FontStyle.italic))
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
                      child: GestureDetector(
                        onTap: () {
                          if (widget.disableEdit == true) {
                            showDialog<String>(
                                // barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Notices'),
                                      content: const Text(
                                          'You are not allowed to change profile picture.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('OK'),
                                          style: TextButton.styleFrom(
                                              primary: Colors.black),
                                        ),
                                      ],
                                    ));
                          } else {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                      height: 170.0,
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            const Text("Profile Image"),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            const Divider(),
                                            FlatButton(
                                                child: const Text(
                                                    "Select Image From Gallery"),
                                                onPressed: () async {
                                                  image =
                                                      await _picker.pickImage(
                                                          source: ImageSource
                                                              .gallery);
                                                  print(image);
                                                  _formData['thumbnail'] =
                                                      image;
                                                  setState(() {
                                                    if (image != null) {
                                                      selectImage =
                                                          File(image.path);
                                                      Navigator.pop(context);
                                                    }
                                                  });
                                                }),
                                            FlatButton(
                                                child: const Text(
                                                    "Take Image From Camera"),
                                                onPressed: () async {
                                                  image =
                                                      await _picker.pickImage(
                                                          source: ImageSource
                                                              .camera);
                                                  _formData['thumbnail'] =
                                                      image;
                                                  setState(() {
                                                    if (image != null) {
                                                      selectImage =
                                                          File(image.path);
                                                      Navigator.pop(context);
                                                    }
                                                  });
                                                }),
                                          ]));
                                });
                          }
                        },
                        child: (thumbnail == "" && selectImage == null)
                            ? Image.asset(
                                'assets/mlcc_logo.jpg',
                                fit: BoxFit.contain,
                                width: 100,
                                height: 100,
                              )
                            : (selectImage != null)
                                ? Image.file(
                                    selectImage!,
                                    fit: BoxFit.contain,
                                    width: 100,
                                    height: 100,
                                  )
                                : Image.network(
                                    thumbnail,
                                    fit: BoxFit.contain,
                                    width: 100,
                                    height: 100,
                                  ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (widget.disableEdit == false)
              const Text("Profile details")
                  .paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
            if (widget.disableEdit == false)
              const Text("Change the following details and save them")
                  .paddingSymmetric(horizontal: 22, vertical: 5),
            TextFieldWidget(
              labelText: "Name",
              hintText: "Lee Wei Wei",
              iconData: Icons.person_outline,
              isFirst: true,
              isLast: false,
              setValue: _setInputValue,
              field: 'name',
              readOnly: widget.disableEdit,
              initialValue: _formData['name'],
              validator: RequiredValidator(errorText: 'Name is required'),
            ),
            TextFieldWidget(
              labelText: "Preferred Name",
              hintText: "Shirley Lee",
              iconData: Icons.person_outline,
              isFirst: false,
              isLast: false,
              readOnly: widget.disableEdit,
              setValue: _setInputValue,
              field: 'preferred_name',
              initialValue: _formData['preferred_name'],
              // validator:
              //     RequiredValidator(errorText: 'Preferred Name is required'),
            ),
            TextFieldWidget(
              labelText: "Chinese Name",
              hintText: "李薇薇",
              iconData: Icons.person_outline,
              isFirst: false,
              isLast: true,
              setValue: _setInputValue,
              readOnly: widget.disableEdit,
              field: 'chinese_name',
              initialValue: _formData['chinese_name'],
              // validator:
              //     RequiredValidator(errorText: 'Chinese Name is required'),
            ),
            TextFieldWidget(
                labelText: "Email Address (Read Only)",
                hintText: "johndoe@gmail.com",
                iconData: Icons.alternate_email,
                keyboardType: TextInputType.emailAddress,
                setValue: _setInputValue,
                field: 'email',
                initialValue: email,
                validator: emailValidator,
                readOnly: true),
            TextFieldWidget(
              labelText: "Identity Card",
              hintText: "XXXXXX-XX-XXXX",
              //iconData: Icons.ac_unit,
              keyboardType: TextInputType.number,
              setValue: _setInputValue,
              field: 'identity_card',
              readOnly: widget.disableEdit,
              initialValue: _formData['identity_card'],
              validator: identityCardValidator,
            ),
            TextFieldWidget(
              labelText: "Phone Number",
              hintText: "0123456789",
              iconData: Icons.phone_iphone,
              keyboardType: TextInputType.phone,
              setValue: _setInputValue,
              field: 'phone_number',
              initialValue: _formData['phone_number'],
              validator: phoneNumberValidator,
              readOnly: widget.disableEdit,
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 14, left: 20, right: 20),
              margin:
                  const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
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
                  Text(
                    "Gender",
                    style: Get.textTheme.bodyText1,
                    textAlign: TextAlign.start,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            TextFieldWidget(
              labelText: "Introduction",
              hintText: "Introduction",
              iconData: FontAwesomeIcons.solidStickyNote,
              keyboardType: TextInputType.multiline,
              isFirst: true,
              isLast: false,
              setValue: _setInputValue,
              field: 'introduction',
              readOnly: widget.disableEdit,
              initialValue: _formData['introduction'],
            ),
            // TextFieldWidget(
            //   labelText: "Introduction",
            //   hintText: "Introduction",
            //   iconData: Icons.solidStickyNote,
            //   // keyboardType: TextInputType.multiline,
            //   setValue: _setInputValue,
            //   field: 'introduction',
            //   initialValue: _formData['introduction'],
            // ),
            // TextFieldWidget(
            //   labelText: "Membership Expiry Date",
            //   iconData: Icons.calendarDay,
            //   setValue: _setInputValue,
            //   field: 'membership_expiry_date',
            //   initialValue: membershipExpiryDate,
            //   readOnly: true,
            // ),
            // TextFieldWidget(
            //   labelText: "Membership Renewal Date",
            //   iconData: Icons.solidCalendarAlt,
            //   setValue: _setInputValue,
            //   field: 'membership_renewal_date',
            //   initialValue: membershipRenewalDate,
            //   readOnly: true,
            // ),

            // PASSWORD SECTION
            if (widget.disableEdit == false)
              const Text("Change password")
                  .paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
            if (widget.disableEdit == false)
              const Text(
                      "Type new password and confirm it when you want to change password")
                  .paddingSymmetric(horizontal: 22, vertical: 5),

            if (widget.first == null)
              TextFieldWidget(
                obscureText: hidePassword,
                labelText: "New Password",
                hintText: "••••••••••••",
                iconData: Icons.lock_outline,
                keyboardType: TextInputType.visiblePassword,
                isFirst: true,
                isLast: false,
                setValue: _setInputValue,
                field: 'new_password',
                readOnly: widget.disableEdit,
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
            if (widget.first == null)
              TextFieldWidget(
                obscureText: hidePassword,
                labelText: "Confirm New Password",
                hintText: "••••••••••••",
                iconData: Icons.lock_outline,
                keyboardType: TextInputType.visiblePassword,
                isFirst: false,
                isLast: true,
                setValue: _setInputValue,
                field: 'password',
                readOnly: widget.disableEdit,
              ),

            if (widget.first != null)
              TextFieldWidget(
                obscureText: hidePassword,
                labelText: "New Password",
                hintText: "••••••••••••",
                iconData: Icons.lock_outline,
                keyboardType: TextInputType.visiblePassword,
                isFirst: true,
                isLast: false,
                setValue: _setInputValue,
                field: 'new_password',
                readOnly: widget.disableEdit,
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
            if (widget.first != null)
              TextFieldWidget(
                obscureText: hidePassword,
                labelText: "Confirm New Password",
                hintText: "••••••••••••",
                iconData: Icons.lock_outline,
                keyboardType: TextInputType.visiblePassword,
                isFirst: false,
                isLast: true,
                setValue: _setInputValue,
                field: 'password',
                readOnly: widget.disableEdit,
                validator: passwordValidator,
              ),
          ]),
        ));
  }

  void _setInputValue(String field, String value) {
    setState(() => _formData[field] = value.trim());
  }

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Please enter an valid email')
  ]);

  final phoneNumberValidator = MultiValidator([
    RequiredValidator(errorText: 'Phone Number is required'),
    MinLengthValidator(10, errorText: 'Phone Number must follow the format'),
    MaxLengthValidator(11, errorText: 'Phone Number must follow the format'),
    PatternValidator(r'(01[0-9]{8,9})',
        errorText: 'Phone Number must follow the format'),
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

  void _showErrorMessage(BuildContext context, String key) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(key), backgroundColor: Colors.red));
  }

  void _showSuccessMessage(BuildContext context, String key) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(key), backgroundColor: Colors.green));
  }
}
