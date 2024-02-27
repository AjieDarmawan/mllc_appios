import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:mlcc_app_ios/screens/page/auth/login_page.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';
import '../../../widget/block_button_widget.dart';
import '../../../widget/text_field_widget.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {'email': null};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Forgot Password",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
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
                      color: kThirdColor, blurRadius: 10, offset: Offset(0, 5)),
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
                      color: kThirdColor, blurRadius: 10, offset: Offset(0, 5)),
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
                  labelText: "Email Address",
                  hintText: "johndoe@gmail.com",
                  iconData: Icons.alternate_email,
                  keyboardType: TextInputType.emailAddress,
                  setValue: _setInputValue,
                  field: 'email',
                  validator: emailValidator,
                ),
                BlocListener<AuthBloc, AuthState>(
                    listener: (BuildContext context, AuthState state) async {
                  if (state is ForgotPasswordSuccessful) {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text('Reset Password'),
                              content: Text(state.status),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          child: const LoginPage()),
                                    );
                                  },
                                  child: const Text('OK'),
                                  style: TextButton.styleFrom(
                                      primary: Colors.black),
                                ),
                              ],
                            ));
                  } else if (state is UserNotFound) {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text('Account Not Found'),
                              content: Text(state.status),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pushNamed(context,
                                      '/register_personal_basic_info_page'),
                                  child: const Text('OK'),
                                  style: TextButton.styleFrom(
                                      primary: Colors.black),
                                ),
                              ],
                            ));
                  } else if (state is ErrorOccured) {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text('Register error'),
                              content: const Text(
                                  'Error occured! Please try again!'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
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
                        if (form!.validate()) {
                          form.save();
                          context
                              .read<AuthBloc>()
                              .add(ForgotPassword(_formData));
                        }
                      },
                      color: kPrimaryColor,
                      text: const Text(
                        "Send Reset Link",
                        style: TextStyle(color: Colors.white),
                      ),
                    ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20);
                  }
                })),
                // BlockButtonWidget(
                //   onPressed: () async {
                //     final form = _formKey.currentState;
                //     if (form!.validate()) {
                //       form.save();
                //       HttpProvider httpProvider = HttpProvider();
                //       var forgetPasswordDataReturn = await httpProvider
                //           .postHttp("forget_password", _formData);

                //       if (forgetPasswordDataReturn ==
                //           "Reset password link will be sent to your email.") {
                //         showDialog<String>(
                //             context: context,
                //             builder: (BuildContext context) => AlertDialog(
                //                   title: const Text('Reset Password'),
                //                   content: Text(forgetPasswordDataReturn),
                //                   actions: <Widget>[
                //                     TextButton(
                //                       onPressed: () => Navigator.popUntil(
                //                           context,
                //                           ModalRoute.withName('/login_page')),
                //                       child: const Text('OK'),
                //                       style: TextButton.styleFrom(
                //                           primary: Colors.black),
                //                     ),
                //                   ],
                //                 ));
                //       } else if (forgetPasswordDataReturn == "User not found") {
                //         showDialog<String>(
                //             context: context,
                //             builder: (BuildContext context) => AlertDialog(
                //                   title: const Text('Account Not Found'),
                //                   content: const Text(
                //                       "This email have not registered yet. Please proceed to register an account!"),
                //                   actions: <Widget>[
                //                     TextButton(
                //                       onPressed: () => Navigator.pushNamed(
                //                           context,
                //                           '/register_personal_basic_info_page'),
                //                       child: const Text('OK'),
                //                       style: TextButton.styleFrom(
                //                           primary: Colors.black),
                //                     ),
                //                   ],
                //                 ));
                //       }
                //     }
                //     // Navigator.pushNamed(context, '/login');
                //   },
                //   color: kPrimaryColor,
                //   text: const Text(
                //     "Send Reset Link",
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ).paddingSymmetric(vertical: 35, horizontal: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/register_personal_basic_info_page');
                      },
                      child: const Text("You don't have an account?",
                          style: TextStyle(color: kPrimaryColor)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: const LoginPage()),
                        );
                      },
                      child: const Text("You remember password!",
                          style: TextStyle(color: kPrimaryColor)),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
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
}
