// ignore_for_file: prefer_is_empty
import 'dart:async';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/account/account_view.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';
import '../../../widget/block_button_widget.dart';
import '../../../widget/text_field_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  // const LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'email': "",
    'member_number': "",
    'password': null
  };
  var InSignIn = false;
  bool hidePassword = true;
  var email = "email";
  var maskFormatter = MaskTextInputFormatter(mask: 'A######');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: const MainScreen(page: HomePage(), index: 0),
                  ),
                );
              },
              icon: const Icon(Icons.keyboard_arrow_left),
            ),
            title: const Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: kPrimaryColor,
            elevation: 0),
        body: ListView(
          primary: true,
          children: [
            Stack(alignment: AlignmentDirectional.bottomCenter, children: [
              Container(
                height: 170,
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
                        style: TextStyle(color: Colors.white, fontSize: 21),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Welcome to MLCC!",
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
                  // Container(
                  //   padding: const EdgeInsets.only(
                  //       top: 20, bottom: 14, left: 20, right: 20),
                  //   margin: const EdgeInsets.only(
                  //       left: 20, right: 20, top: 20, bottom: 10),
                  //   decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: const BorderRadius.all(Radius.circular(10)),
                  //       boxShadow: [
                  //         BoxShadow(
                  //             color: Get.theme.focusColor.withOpacity(0.1),
                  //             blurRadius: 10,
                  //             offset: const Offset(0, 5)),
                ],
                // border: Border.all(
                //     color: Get.theme.focusColor.withOpacity(0.05))),
                // child: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       "Login Method",
                //       style: Get.textTheme.bodyText1,
                //       textAlign: TextAlign.start,
                //      ),
                //     Row(
                //       children: [
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //             const Icon(FontAwesomeIcons.key,
                //                     color: kPrimaryColor)
                //                 .marginOnly(right: 14)
                //           ],
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //             Radio(
                //                 toggleable: true,
                //                 activeColor: kThirdColor,
                //                 value: "email",
                //                 groupValue: email,
                //                 onChanged: (value) {
                //                   setState(() {
                //                     email = value as String;
                //                   });
                //                 }),
                //             const Text(
                //               'Email',
                //               style: TextStyle(fontSize: 12.0),
                //             )
                //           ],
                //         ),
                //         // Row(
                //         //   mainAxisAlignment: MainAxisAlignment.start,
                //         //   children: [
                //         //     Radio(
                //         //       toggleable: false,
                //         //       activeColor: kThirdColor,
                //         //       value: "member_number",
                //         //       groupValue: email,
                //         //       onChanged: (value) {
                //         //         setState(() {
                //         //           email = value as String;
                //         //         });
                //         //       },
                //         //     ),
                //         //     const Text(
                //         //       'Member Number',
                //         //       style: TextStyle(fontSize: 12.0),
                //         //     ),
                //         //   ],

                //       ],
              ),
            ),

            email == email
                ? TextFieldWidget(
                    labelText: "Email Address",
                    hintText: "johndoe@gmail.com",
                    iconData: Icons.alternate_email,
                    keyboardType: TextInputType.emailAddress,
                    field: 'email',
                    setValue: _setInputValue,
                    validator: emailValidator,
                  )
                : TextFieldWidget(
                    //   labelText: "Member Number (X######)",
                    //   hintText: "X######",
                    //   iconData: Icons.card_membership_outlined,
                    //   field: 'member_number',
                    //   setValue: _setInputValue,
                    //   validator: memberNumberValidator,
                    //   inputFormatters: [maskFormatter],
                    ),
            TextFieldWidget(
              labelText: "Password",
              hintText: "••••••••••••",
              iconData: Icons.lock_outline,
              keyboardType: TextInputType.visiblePassword,
              obscureText: hidePassword,
              field: 'password',
              setValue: _setInputValue,
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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     TextButton(
            //       onPressed: () {
            //         Navigator.pushNamed(context, '/forgot_password_page');
            //       },
            //       child: const Text("Forgot Password?",
            //           style: TextStyle(color: kPrimaryColor)),
            //     ),
            //   ],
            // ).paddingSymmetric(horizontal: 20),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     TextButton(
            //       onPressed: () {
            //         Navigator.pushNamed(
            //             context, '/register_personal_basic_info_page');
            //       },
            //       child: const Text("You don't have an account?",
            //           style: TextStyle(color: kPrimaryColor)),
            //     ),
            //   ],
            // ).paddingSymmetric(horizontal: 20),
            BlocListener<AuthBloc, AuthState>(
                listener: (BuildContext context, AuthState state) async {
              if (state is LoginFailure) {
                _showErrorMessage(context, 'Invalid Email/Password.');
              } else if (state is AccountInactive) {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text('Account Inactive'),
                          content: const Text(
                              'Your account is inactive! Please contact admin to verify.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                              style:
                                  TextButton.styleFrom(primary: Colors.black),
                            ),
                          ],
                        ));
              } else if (state is LoginSuccessful) {
                // SharedPreferences prefs =
                //     await SharedPreferences.getInstance();
                // prefs.setInt("userId", state.userData['id']);
                // prefs.setBool("isLoggedIn", true);
                // prefs.setString("token", state.userData['token']);
                // prefs.setString("email", state.userData['email']);
                _showSuccessMessage(context, 'Login Successful');
                // Navigator.of(context).popUntil((route) => route.isFirst);
                // Navigator.pushReplacement(
                //   context,
                //   PageTransition(
                //     type: PageTransitionType.fade,
                //     child: const MainScreen(
                //       page: HomePage(),
                //       index: 0,
                //     ),
                //   ),
                // );
                // Navigator.pop(context);
              }
            }, child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (BuildContext context, AuthState state) {
              if (state is AuthLoading) {
                return LoadingWidget();
              } else {
                return
                    // InSignIn == true
                    // ? CircularProgressIndicator()
                    // :
                    BlockButtonWidget(
                  onPressed: () async {
                    final form = _formKey.currentState;
                    if (form!.validate()) {
                      form.save();
                      // context.read<AuthBloc>().add(Login(_formData));
                      if (email == "email") {
                        _formData['member_number'] = "";
                      } else {
                        _formData['email'] = "";
                        _formData['member_number'] =
                            _formData['member_number'].toUpperCase();
                      }

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var status = prefs.getBool('isLoggedIn') ?? false;
                      var loginDataReturn =
                          await httpProvider.postHttp("login", _formData);

                      if (loginDataReturn == "Password not match" ||
                          loginDataReturn == "User not found") {
                        setState(() {
                          InSignIn = true;
                        });
                        _showLoading(context);
                        _showErrorMessage(context, 'Invalid Email/Password.');
                        setState(() {
                          InSignIn = false;
                        });
                      } else if (loginDataReturn == "Account inactive") {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Account Inactive'),
                                  content: const Text(
                                      'Your account is inactive! Please contact admin to verify.'),
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
                      } else {
                        if (loginDataReturn['active'] == 0) {
                          print('no active');
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Account Deactivated'),
                                    content: const Text(
                                        'Your account is deactivated! Please contact admin to verify.'),
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
                          // } else if (loginDataReturn['paid'] == 0) {
                          //   SharedPreferences prefs =
                          //       await SharedPreferences.getInstance();
                          //   // prefs.setBool("isLoggedIn", true);
                          //   prefs.setString("email", loginDataReturn['email']);
                          //   prefs.setString(
                          //       "username", loginDataReturn['username']);
                          //   // prefs.setInt("userId", loginDataReturn['id']);
                          //   Navigator.pushNamed(context, '/payment_webview_page',
                          //       arguments: {
                          //         'userId': loginDataReturn['id'],
                          //         'training': 0,
                          //         'event': 0,
                          //         'product': 0,
                          //       });
                        } else if (loginDataReturn['last_access'] == "") {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text('First Login'),
                                    content: const Text(
                                        'Please update your password. Thank You'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          // SharedPreferences prefs =
                                          //     await SharedPreferences
                                          //         .getInstance();
                                          // // prefs.setBool("isLoggedIn", true);
                                          // prefs.setString("email",
                                          //     loginDataReturn['email']);
                                          // prefs.setString("username",
                                          //     loginDataReturn['username']);
                                          // prefs.setInt("userId", loginDataReturn['id']);
                                          showProgressTrainer(context);
                                          var _formData = {
                                            "user_id": loginDataReturn['id']
                                          };
                                          var getUserDetails =
                                              await httpProvider.postHttp2(
                                                  "entrepreneur/info",
                                                  _formData);

                                          if (getUserDetails != '') {
                                            Navigator.pop(context);
                                            // Navigator.of(context)
                                            //     .popUntil((route) => route.isFirst);
                                            // Navigator.pushReplacement(
                                            //   context,
                                            //   PageTransition(
                                            //     type: PageTransitionType.fade,
                                            //     child: const MainScreen(
                                            //       page: AccountViewPage(),
                                            //       index: 2,
                                            //     ),
                                            //   ),
                                            // );
                                            Navigator.pushNamed(context,
                                                '/account_personal_basic_info_view_page',
                                                arguments: {
                                                  'data': getUserDetails[0],
                                                  'first': "两个自己",
                                                  'disableEdit': false,
                                                });
                                          }
                                        },
                                        child: const Text('OK'),
                                        style: TextButton.styleFrom(
                                            primary: Colors.black),
                                      ),
                                    ],
                                  ));
                        } else if (loginDataReturn['device_token'] == '') {
                          setState(() {
                            InSignIn = true;
                          });
                          _showLoading(context);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool("isLoggedIn", true);
                          prefs.setString("email", loginDataReturn['email']);
                          prefs.setString(
                              "username", loginDataReturn['username']);
                          prefs.setInt("userId", loginDataReturn['id']);
                          prefs.setBool("isExpired", false);
                          var updateAccessDataReturn =
                              await httpProvider.postHttp("last_access", {
                            'user_id': loginDataReturn['id'],
                            'push_token': prefs.getString("OneSignalPlayerID"),
                            'push_token_status': '1'
                          });

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
                        } else if (loginDataReturn['device_token'] != null) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String? deviceToken =
                              prefs.getString("OneSignalPlayerID");
                          if (loginDataReturn['device_token'] != deviceToken) {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text(
                                          'Detected other device using this account'),
                                      content: const Text(
                                          'To continue to login, it will logout from another device. Click "OK" to proceed...'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel'),
                                          style: TextButton.styleFrom(
                                              primary: Colors.grey),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setBool("isLoggedIn", true);
                                            prefs.setString("email",
                                                loginDataReturn['email']);
                                            prefs.setString("username",
                                                loginDataReturn['username']);
                                            prefs.setInt("userId",
                                                loginDataReturn['id']);
                                            prefs.setBool("isExpired", false);
                                            var updateAccessDataReturn =
                                                await httpProvider
                                                    .postHttp("last_access", {
                                              'user_id': loginDataReturn['id'],
                                              'push_token': prefs.getString(
                                                  "OneSignalPlayerID"),
                                              'push_token_status': '1'
                                            });
                                            if (updateAccessDataReturn ==
                                                "Success") {
                                              Navigator.of(context).popUntil(
                                                  (route) => route.isFirst);
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
                                          },
                                          child: const Text('OK'),
                                          style: TextButton.styleFrom(
                                              primary: Colors.blue),
                                        ),
                                      ],
                                    ));
                          }
                        } else {
                          setState(() {
                            InSignIn = true;
                          });
                          _showLoading(context);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool("isLoggedIn", true);
                          prefs.setString("email", loginDataReturn['email']);
                          prefs.setString(
                              "username", loginDataReturn['username']);
                          prefs.setInt("userId", loginDataReturn['id']);
                          prefs.setBool("isExpired", false);
                          var updateAccessDataReturn =
                              await httpProvider.postHttp("last_access", {
                            'user_id': loginDataReturn['id'],
                            'push_token': prefs.getString("OneSignalPlayerID"),
                            'push_token_status': '1'
                          });
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
                        }
                      }
                      if (status) {
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
                    }
                  },
                  color: kPrimaryColor,
                  text: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ).paddingSymmetric(vertical: 10, horizontal: 20);
              }
            })),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     TextButton(
            //       onPressed: () {
            //         Navigator.pushNamed(
            //             context, '/register_personal_basic_info_page');
            //       },
            //       child: const Text("You don't have an account?",
            //           style: TextStyle(color: kPrimaryColor)),
            //     ),
            //   ],
            // ).paddingSymmetric(vertical: 20),
          ],
        ));
  }

  void _setInputValue(String field, String value) {
    setState(() => _formData[field] = value.trim());
  }

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Please enter an valid email')
  ]);

  final memberNumberValidator = MultiValidator([
    RequiredValidator(errorText: 'Member Number is required'),
    PatternValidator(r'([Xx]\d+)', errorText: 'Member Number invalid'),
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(6, errorText: 'Password must be at least 6 digits long'),
  ]);

  void _showErrorMessage(BuildContext context, String key) async {
    Fluttertoast.showToast(
        msg: key.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    // var result = await showDialog(
    //   context: context,
    //   builder: (context) =>
    //       FutureProgressDialog(getFuture(), message: Text(key)),
    // );
    // showResultDialog(context, result);

    // ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(key), backgroundColor: Colors.red));
  }

  void _showSuccessMessage(BuildContext context, String key) async {
    Fluttertoast.showToast(
        msg: "success",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);

    // var result = await showDialog(
    //   context: context,
    //   builder: (context) =>
    //       FutureProgressDialog(getFuture(), message: Text("success")),
    // );
    // showResultDialog(context, result);

    // ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(key), backgroundColor: Colors.green));
  }

  void _showLoading(BuildContext context) async {
    var result = await showDialog(
      context: context,
      builder: (context) =>
          FutureProgressDialog(getFuture(), message: Text("Loading")),
    );
    showResultDialog(context, result);
  }

  Future<void> showProgressTrainer(BuildContext context) async {
    var result = await showDialog(
      context: context,
      builder: (context) =>
          FutureProgressDialog(getFuture(), message: const Text('Loading...')),
    );
    showResultDialog(context, result);
    // return result;
  }

  void showResultDialog(
    BuildContext context,
    String result,
  ) {
    // Navigator.pop(context);
  }

  Future getFuture() {
    return Future(() async {
      await Future.delayed(const Duration(seconds: 2));
      return 'Submit Successfully!';
    });
  }
}
