import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:mlcc_app_ios/widget/disable_screenshots.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mlcc_app_ios/Bloc/entrepreneurs/entrepreneurs_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/screens/page/entrepreneurs/entrepreneurs_view.dart';
import 'package:mlcc_app_ios/screens/page/entrepreneurs/register_refferal_page.dart';
import 'package:mlcc_app_ios/widget/block_button_widget.dart';
import 'package:mlcc_app_ios/widget/expandedSection.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';
import 'package:mlcc_app_ios/widget/text_field_widget.dart';
import 'package:mlcc_app_ios/widget/til_widget.dart';
import 'package:mlcc_app_ios/widget/title_bar_widget.dart';
import 'package:mlcc_app_ios/widget/item_widget.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class EntrepreneurDetailsViewPage extends StatefulWidget {
  final dynamic data;
  final dynamic allUsers;

  const EntrepreneurDetailsViewPage({Key? key, this.data, this.allUsers})
      : super(key: key);

  @override
  _EntrepreneurDetailsViewPageState createState() =>
      _EntrepreneurDetailsViewPageState();
}

class _EntrepreneurDetailsViewPageState
    extends State<EntrepreneurDetailsViewPage> {
  bool joined = false;
  bool _isIntro = false;
  bool _isMedia = false;
  bool _isEducation = false;
  bool _isSocieties = false;
  bool _isCert = false;
  bool _isWork = false;
  bool _isEmail = false;
  bool _isNumber = false;
  String _connect = "";
  int userId = 0;
  String name = '';
  int connector_id = 0;
  Color _color = kPrimaryColor;
  String _swipeText = 'Connect   > >         < <   Refferal';
  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<void> clearSecureScreen() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
      connector_id = widget.data['id'];
      name = widget.data['name'];
      // if (widget.data['connect_user_id'].isNotEmpty &&
      //     widget.data['connect_user_id'].contains(userId) == true) {
      //   _connect = "Approve";
      // }
      // if (widget.data['pending_user_id'].isNotEmpty &&
      //     widget.data['pending_user_id'].contains(userId) == true) {
      //   _connect = "Pending";
      // }
      // if (widget.data['reject_user_id'].isNotEmpty &&
      //     widget.data['reject_user_id'].contains(userId) == true) {
      //   _connect = "Reject";
      // }
    });

    final _formData_detail = {};
    _formData_detail['user_id'] = widget.data['id'];
    _formData_detail['log_user_id'] = userId;

    context
        .read<EntrepreneursBloc>()
        .add(GetEntrepreneurDetails(_formData_detail));
  }
  // List<dynamic> entrepreneurData = [];

  // @override
  // void didChangeDependencies() {
  //   final dynamic args = ModalRoute.of(context)!.settings.arguments;
  //   if (args != null) {
  //     context
  //         .read<EntrepreneursBloc>()
  //         .add(GetEntrepreneurDetails(args['data']));
  //   }
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    // print('idconnect${widget.data['id']}');
    secureScreen();
    DisableScreenshots.disable();
    getUser();
    // Timer(const Duration(milliseconds: 2000), () {

    Timer(const Duration(milliseconds: 1000), () {
      setState(() {
        _isIntro = true;
        _isMedia = true;
        _isEducation = true;
        _isSocieties = true;
        _isCert = true;
        _isWork = true;
        _isEmail = true;
        _isNumber = true;
      });
      // });

      // Timer(const Duration(milliseconds: 2000), () {
      //   setState(() {
      //     _isIntro = false;
      //   });
      // });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    clearSecureScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return _buildContent(context, widget.data);
    return BlocBuilder<EntrepreneursBloc, EntrepreneursState>(
        builder: (BuildContext context, EntrepreneursState state) {
      if (state is GetEntrepreneurDetailSuccessful) {
        dynamic entrepreneurData = state.entrepreneurData[0];
        dynamic status_ = state.check_status;

        print("entrepreneurDataentrepreneurData${entrepreneurData}");

        //entrepreneurData['work_experiences'][0]['entity'] = '';
        // entrepreneurData['work_experiences'][0]['designation'] = '';
        // entrepreneurData['work_experiences'][0]['start_date'] = '';
        // entrepreneurData['work_experiences'][0]['end_date'] = '';

        if (entrepreneurData['work_experiences'].isEmpty) {
        } else {
          // entrepreneurData['work_experiences'][0]['entity'] =
          //     "Does not have the Organization Entity";

          // entrepreneurData['work_experiences'][0]['designation'] =
          //     "Does not have the  Designation";

          // entrepreneurData['work_experiences'][0]['start_date'] =
          //     "Does not have the Start date";

          // entrepreneurData['work_experiences'][0]['end_date'] =
          //     "Does not have the End date";

          if (entrepreneurData['work_experiences'][0]['entity'] == null) {
            entrepreneurData['work_experiences'][0]['entity'] =
                "Does not have the Organization Entity";
          }

          if (entrepreneurData['work_experiences'][0]['designation'] == null) {
            entrepreneurData['work_experiences'][0]['designation'] =
                "Does not have the  Designation";
          }

          if (entrepreneurData['work_experiences'][0]['start_date'] == null) {
            entrepreneurData['work_experiences'][0]['start_date'] =
                "Does not have the Start date";
          }

          if (entrepreneurData['work_experiences'][0]['end_date'] == null) {
            entrepreneurData['work_experiences'][0]['end_date'] =
                "Does not have the End date";
          }
        }

        connector_id = entrepreneurData['id'];
        name = entrepreneurData['name'];
        if (entrepreneurData['connect_user_id'].isNotEmpty &&
            entrepreneurData['connect_user_id'].contains(userId) == true) {
          _connect = "Approve";
        }
        if (entrepreneurData['pending_user_id'].isNotEmpty &&
            entrepreneurData['pending_user_id'].contains(userId) == true) {
          _connect = "Pending";
        }
        if (entrepreneurData['reject_user_id'].isNotEmpty &&
            entrepreneurData['reject_user_id'].contains(userId) == true) {
          _connect = "Reject";
        }

        return _buildContent(context, entrepreneurData, status_);
      } else {
        return WillPopScope(
          onWillPop: () async {
            return backtoPrevious();
          },
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.pushReplacement(
                    //   context,
                    //   PageTransition(
                    //       type: PageTransitionType.fade,
                    //       child: EntrepreneursViewPage(data: widget.allUsers)),
                    // );
                    // Navigator.pushReplacementNamed(
                    //     context, '/entrepreneurs_view_page');
                  },
                  icon: const Icon(Icons.keyboard_arrow_left, size: 30),
                ),
                title: Text(
                  "Members Details",
                  style: TextStyle(
                    color: kSecondaryColor,
                  ),
                ),
                centerTitle: true,
                backgroundColor: kPrimaryColor,
                elevation: 0,
              ),
              body: const LoadingWidget()),
        );
        // return const LoadingWidget();
      }
    });
  }

  backtoPrevious() {
    // Navigator.pushReplacement(
    //   context,
    //   PageTransition(
    //       type: PageTransitionType.fade,
    //       child: EntrepreneursViewPage(data: widget.allUsers)),
    // );
    Navigator.pop(context);
    // Navigator.pushReplacementNamed(context, '/entrepreneurs_view_page');
  }

  void _toogleExpand(int index) {
    setState(() {
      if (index == 0) _isIntro = !_isIntro;
      if (index == 1) _isMedia = !_isMedia;
      if (index == 2) _isEducation = !_isEducation;
      if (index == 3) _isSocieties = !_isSocieties;
      if (index == 4) _isCert = !_isCert;
      if (index == 5) _isWork = !_isWork;
      if (index == 6) _isEmail = !_isEmail;
      if (index == 7) _isNumber = !_isNumber;
    });
    print("index_${index}");
  }

  Widget _DialogWithTextField(BuildContext context) => Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.80,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Form(
        key: _formKey2,
        // autovalidateMode: _autoValidate,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Text("Refferal Request")],
                ),
              ),
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
              TextFieldWidget(
                labelText: "Company Name",
                hintText: "Company Address",
                iconData: Icons.business,
                isFirst: false,
                isLast: true,
                setValue: _setInputValue,
                field: 'company_name',
              ),
              TextFieldWidget(
                labelText: "Address",
                hintText: "Company Address",
                keyboardType: TextInputType.multiline,
                iconData: Icons.home,
                // keyboardType: TextInputType.phone,
                isFirst: false,
                isLast: true,
                setValue: _setInputValue,
                field: 'company_address',
              ),
              TextFieldWidget(
                labelText: "Remark / Reason",
                hintText: "Remark / Reason",
                keyboardType: TextInputType.multiline,
                iconData: Icons.textsms,
                // keyboardType: TextInputType.phone,
                isFirst: false,
                isLast: true,
                setValue: _setInputValue,
                field: 'remark',
              ),
              BlockButtonWidget(
                onPressed: () async {},
                color: kPrimaryColor,
                text: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20)
            ],
          ),
        ),
      ));

  Widget _buildContent(BuildContext context, entrepreneurData, status_) {
    print("entrepreneurData${entrepreneurData}");
    print("status_${status_}");

    List<Widget> images = [
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: MaterialButton(
            onPressed: () {
              if (_connect == "" || _connect == "Reject") {
                _validateInputs();
              }
            },
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: _connect == ""
                ? kPrimaryColor
                : _connect == "Pending"
                    ? Colors.grey
                    : _connect == "Approve"
                        ? Colors.green[200]
                        : Colors.red,
            child: _connect == ""
                ? InkWell(
                    onTap: () => _validateInputs(),
                    child: const Text("Connect",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: kSecondaryColor)),
                  )
                : _connect == "Pending"
                    ? const Text("Pending for Approval",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: kSecondaryColor))
                    : _connect == "Approve"
                        ? InkWell(
                            onTap: () {},
                            child: const Text("Connected",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: kSecondaryColor)),
                          )
                        : _connect == "Reject"
                            ? InkWell(
                                onTap: () {
                                  _validateInputs();
                                },
                                child: const Text("Rejected ( Request Again)",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: kSecondaryColor)),
                              )
                            : InkWell(
                                onTap: () => _validateInputs(),
                                child: const Text("Connected",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: kSecondaryColor)),
                              )),
      ),
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: MaterialButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 6,
                      backgroundColor: Colors.transparent,
                      child: _DialogWithTextField(context),
                    );
                  });
            },
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: kPrimaryColor,
            child: const Text("Refferal",
                textAlign: TextAlign.center,
                style: TextStyle(color: kSecondaryColor))),
      )
    ];
    return WillPopScope(
      onWillPop: () async {
        return backtoPrevious();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              // Navigator.pushReplacement(
              //   context,
              //   PageTransition(
              //       type: PageTransitionType.fade,
              //       child: EntrepreneursViewPage(data: widget.allUsers)),
              // );
              Navigator.pop(context);

              // Navigator.pushReplacementNamed(
              //     context, '/entrepreneurs_view_page');
            },
            icon: const Icon(Icons.keyboard_arrow_left, size: 30),
          ),
          title: Text(
            entrepreneurData['title'] + " " + entrepreneurData['name'],
            style: const TextStyle(
              color: kSecondaryColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        bottomNavigationBar: GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            // if (details.primaryVelocity! > 0) {
            // print("Test1");
            // setState(() {
            //   if (_connect == "" || _connect == "Reject") {
            //     if (_connect == '') {
            //       _swipeText = "Connect";
            //       _color = kThirdColor;
            //     } else {
            //       _swipeText = "Rejected ( Request Again)";
            //       _color = Colors.red;
            //     }

            //     Navigator.push(
            //       context,
            //       PageTransition(
            //         type: PageTransitionType.fade,
            //         child: RegisterRefferalPage(data: entrepreneurData),
            //       ),
            //     );

            //   } else if (_connect == "Pending") {
            //     _swipeText = "Pending for Approval";
            //     _color = Colors.grey;
            //     showDialog<String>(
            //         // barrierDismissible: false,
            //         context: context,
            //         builder: (BuildContext context) => AlertDialog(
            //               title: const Text('Pending for Approval'),
            //               content: RichText(
            //                   text: TextSpan(
            //                       // Note: Styles for TextSpans must be explicitly defined.
            //                       // Child text spans will inherit styles from parent
            //                       style: const TextStyle(
            //                         fontSize: 13.0,
            //                         color: Colors.black,
            //                       ),
            //                       children: <TextSpan>[
            //                     const TextSpan(
            //                         text: 'You have sent request to the '),
            //                     TextSpan(
            //                         text: name + ". \n\n",
            //                         style: const TextStyle(
            //                             fontSize: 15.0,
            //                             fontWeight: FontWeight.bold)),
            //                     const TextSpan(
            //                       text: ' Please wait for response...',
            //                       style: TextStyle(
            //                         fontSize: 13.0,
            //                         color: Colors.black,
            //                       ),
            //                     ),
            //                   ])),
            //               actions: <Widget>[
            //                 TextButton(
            //                   onPressed: () {
            //                     Navigator.pop(context);
            //                   },
            //                   child: const Text('OK'),
            //                   style:
            //                       TextButton.styleFrom(primary: Colors.black),
            //                 ),
            //               ],
            //             ));
            //   } else if (_connect == "Approve") {
            //     _swipeText = "Connected";
            //     _color = Colors.green.shade300;
            //     showDialog<String>(
            //         // barrierDismissible: false,
            //         context: context,
            //         builder: (BuildContext context) => AlertDialog(
            //               title: const Text('Connected'),
            //               content: RichText(
            //                   text: TextSpan(
            //                       // Note: Styles for TextSpans must be explicitly defined.
            //                       // Child text spans will inherit styles from parent
            //                       style: const TextStyle(
            //                         fontSize: 13.0,
            //                         color: Colors.black,
            //                       ),
            //                       children: <TextSpan>[
            //                     const TextSpan(
            //                         text: 'You have connected to the '),
            //                     TextSpan(
            //                         text: name + ". \n\n",
            //                         style: const TextStyle(
            //                             fontSize: 15.0,
            //                             fontWeight: FontWeight.bold)),
            //                   ])),
            //               actions: <Widget>[
            //                 TextButton(
            //                   onPressed: () {
            //                     Navigator.pop(context);
            //                     // Navigator.pushReplacementNamed(
            //                     //     context,
            //                     //     '/entrepreneur_details_view_page',
            //                     //     arguments: {
            //                     //       'data': widget.data
            //                     //     });
            //                   },
            //                   child: const Text('OK'),
            //                   style:
            //                       TextButton.styleFrom(primary: Colors.black),
            //                 ),
            //               ],
            //             ));
            //   }
            // });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
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
                //if (_connect.isEmpty)
                Expanded(
                    flex: 8,
                    child: SizedBox(
                        height: 60,
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    functionreferral(status_['referral_status'],
                                        entrepreneurData);
                                  },
                                  child: Image.asset("assets/left.gif",
                                      height: 60, width: 60, fit: BoxFit.cover),
                                ),
                                InkWell(
                                  onTap: () {
                                    functionreferral(status_['referral_status'],
                                        entrepreneurData);
                                    // Navigator.push(
                                    //   context,
                                    //   PageTransition(
                                    //     type: PageTransitionType.fade,
                                    //     child: RegisterRefferalPage(
                                    //         data: entrepreneurData),
                                    //   ),
                                    // );
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text('Swipe Left ',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: kTextColor)),
                                          Text('(Referral)',
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: kTextColor)),
                                        ],
                                      ),
                                      Text(
                                          'Status: ${status_['referral_status']} ',
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: kPrimaryColor)),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   PageTransition(
                                    //     type: PageTransitionType.fade,
                                    //     child: RegisterRefferalPage(
                                    //         data: entrepreneurData),
                                    //   ),
                                    // );
                                    functionconnect(
                                        status_['connected_status']);
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text('Swipe Right ',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: kTextColor)),
                                          Text('(Connect)',
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: kTextColor)),
                                        ],
                                      ),
                                      Flexible(
                                        child: Text(
                                            'Status : ${status_['connected_status']} ',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: kPrimaryColor)),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   PageTransition(
                                    //     type: PageTransitionType.fade,
                                    //     child: RegisterRefferalPage(
                                    //         data: entrepreneurData),
                                    //   ),
                                    // );
                                    functionconnect(
                                        status_['connected_status']);
                                  },
                                  child: Image.asset("assets/right.gif",
                                      height: 60, width: 60, fit: BoxFit.cover),
                                ),
                              ],
                            ))))
              ],
            ).paddingSymmetric(vertical: 10, horizontal: 20),
          ),
        ),
        body: CustomScrollView(
          primary: true,
          shrinkWrap: true,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              expandedHeight: 350,
              elevation: 0,
              // floating: true,
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              centerTitle: true,
              pinned: true,
              automaticallyImplyLeading: false,
              // bottom: entrepreneurTitleBarWidget(entrepreneurData['name']),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    (entrepreneurData['thumbnail'] != null &&
                            entrepreneurData['thumbnail'] != "")
                        ? Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.white,
                                  Colors.black87,
                                  Colors.black,
                                ],
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.60),
                                    BlendMode.dstATop),
                                image: NetworkImage(
                                  entrepreneurData['thumbnail'],
                                ),
                              ),
                            ),
                          )
                        : Image.asset(
                            'assets/mlcc_logo.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 400,
                          ),
                    if (entrepreneurData['member_type_string'] == 'Both')
                      Positioned(
                        bottom: 1,
                        left: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Image.asset("assets/mlcc_logo.png",
                              width: 50, height: 50),
                        ),
                      ),
                    if (entrepreneurData['member_type_string'] == 'Both')
                      Positioned(
                        bottom: 1,
                        left: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Image.asset("assets/mlcc_logo.png",
                              width: 50, height: 50),
                        ),
                      ),
                    if (entrepreneurData['member_type_string'] == 'Ambassador')
                      Positioned(
                        bottom: 1,
                        left: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Image.asset("assets/mlcc_logo.png",
                              width: 50, height: 50),
                        ),
                      ),
                    if (entrepreneurData['member_type_string'] == 'Consultant')
                      Positioned(
                        bottom: 1,
                        left: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Image.asset("assets/mlcc_logo.png",
                              width: 50, height: 50),
                        ),
                      ),
                  ],
                ),
              ).marginOnly(bottom: 10),
            ),
            // Introduction
            SliverToBoxAdapter(
                child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
                  decoration: BoxDecoration(
                    color: kThirdColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => _toogleExpand(0),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Introduction",
                                  style: TextStyle(color: Colors.white)),
                              if (_isIntro == true)
                                const Icon(Icons.keyboard_arrow_up,
                                    size: 30, color: kSecondaryColor)
                              else
                                const Icon(Icons.keyboard_arrow_down,
                                    size: 30, color: kSecondaryColor),
                            ],
                          ),
                        )
                        // padding: EdgeInsets.all(5),
                        ),
                  ),
                ),
                ExpandedSection(
                  expand: _isIntro,
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(
                          left: 20, bottom: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          entrepreneurData['introduction'] != ""
                              // ? Text("tes")
                              ? TilWidget(
                                  check: "两个自己",
                                  actions: const [],
                                  title: const Text("Introduction",
                                      style: TextStyle(
                                          fontSize: 16, color: kPrimaryColor)),
                                  content: Html(
                                    data: entrepreneurData['introduction'],
                                    // onLinkTap: (url, _, __, ___) {
                                    //   launch(url!);
                                    // },
                                  ))
                              : const SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Does not have any introduction",
                                      textAlign: TextAlign.left,
                                      // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                                    ),
                                  )),
                          // child: AccountInfo(user: widget.user),,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),

            //social_medias
            SliverToBoxAdapter(
                child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
                  decoration: BoxDecoration(
                    color: kThirdColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => _toogleExpand(1),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Social Medias",
                                  style: TextStyle(color: Colors.white)),
                              if (_isMedia == true)
                                const Icon(Icons.keyboard_arrow_up,
                                    size: 30, color: kSecondaryColor)
                              else
                                const Icon(Icons.keyboard_arrow_down,
                                    size: 30, color: kSecondaryColor),
                            ],
                          ),
                        )
                        // padding: EdgeInsets.all(5),
                        ),
                  ),
                ),
                ExpandedSection(
                  expand: _isMedia,
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(
                          left: 20, bottom: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          entrepreneurData['social_medias'].isNotEmpty
                              ? TilWidget(
                                  check: "两个自己",
                                  actions: const [],
                                  title: const Text("Social Media",
                                      style: TextStyle(
                                          fontSize: 16, color: kPrimaryColor)),
                                  content: ItemWidget(
                                      dataName: 'social_medias',
                                      data: entrepreneurData['social_medias']))
                              : const SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Does not have any social medias",
                                      textAlign: TextAlign.left,
                                      // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                                    ),
                                  )),

                          // child: AccountInfo(user: widget.user),,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
            //Eduction
            SliverToBoxAdapter(
                child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
                  decoration: BoxDecoration(
                    color: kThirdColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => _toogleExpand(2),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Educations",
                                  style: TextStyle(color: Colors.white)),
                              if (_isEducation == true)
                                const Icon(Icons.keyboard_arrow_up,
                                    size: 30, color: kSecondaryColor)
                              else
                                const Icon(Icons.keyboard_arrow_down,
                                    size: 30, color: kSecondaryColor),
                            ],
                          ),
                        )
                        // padding: EdgeInsets.all(5),
                        ),
                  ),
                ),
                ExpandedSection(
                  expand: _isEducation,
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(
                          left: 20, bottom: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          entrepreneurData['educations'].isNotEmpty
                              ? TilWidget(
                                  check: "两个自己",
                                  actions: const [],
                                  title: const Text("Education",
                                      style: TextStyle(
                                          fontSize: 16, color: kPrimaryColor)),
                                  content: ItemWidget(
                                      dataName: 'educations',
                                      data: entrepreneurData['educations']))
                              : const SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Does not have any educations",
                                      textAlign: TextAlign.left,
                                      // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                                    ),
                                  )),

                          // child: AccountInfo(user: widget.user),,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
            //Scieties
            SliverToBoxAdapter(
                child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
                  decoration: BoxDecoration(
                    color: kThirdColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => _toogleExpand(3),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Societies",
                                  style: TextStyle(color: Colors.white)),
                              if (_isSocieties == true)
                                const Icon(Icons.keyboard_arrow_up,
                                    size: 30, color: kSecondaryColor)
                              else
                                const Icon(Icons.keyboard_arrow_down,
                                    size: 30, color: kSecondaryColor),
                            ],
                          ),
                        )
                        // padding: EdgeInsets.all(5),
                        ),
                  ),
                ),
                ExpandedSection(
                  expand: _isSocieties,
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(
                          left: 20, bottom: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          entrepreneurData['societies'].isNotEmpty
                              ? TilWidget(
                                  check: "两个自己",
                                  actions: const [],
                                  title: const Text("Societies",
                                      style: TextStyle(
                                          fontSize: 16, color: kPrimaryColor)),
                                  content: ItemWidget(
                                      dataName: 'societies',
                                      data: entrepreneurData['societies']))
                              : const SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Does not have any societies",
                                      textAlign: TextAlign.left,
                                      // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                                    ),
                                  )),
                          // child: AccountInfo(user: widget.user),,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
            //Professional Cert & Rewards
            SliverToBoxAdapter(
                child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
                  decoration: BoxDecoration(
                    color: kThirdColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => _toogleExpand(4),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Professional Cert & Rewards",
                                  style: TextStyle(color: Colors.white)),
                              if (_isCert == true)
                                const Icon(Icons.keyboard_arrow_up,
                                    size: 30, color: kSecondaryColor)
                              else
                                const Icon(Icons.keyboard_arrow_down,
                                    size: 30, color: kSecondaryColor),
                            ],
                          ),
                        )
                        // padding: EdgeInsets.all(5),
                        ),
                  ),
                ),
                ExpandedSection(
                  expand: _isCert,
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(
                          left: 20, bottom: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          entrepreneurData['professional_certs'].isNotEmpty
                              ? TilWidget(
                                  check: "两个自己",
                                  actions: const [],
                                  title: const Text(
                                      "Professional Cert & Rewards",
                                      style: TextStyle(
                                          fontSize: 16, color: kPrimaryColor)),
                                  content: ItemWidget(
                                      dataName: 'professional_certs',
                                      data: entrepreneurData[
                                          'professional_certs']))
                              : const SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Does not have any professional Cert & Rewards",
                                      textAlign: TextAlign.left,
                                      // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                                    ),
                                  )),

                          // child: AccountInfo(user: widget.user),,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
            //Work Experienced
            SliverToBoxAdapter(
                child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
                  decoration: BoxDecoration(
                    color: kThirdColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () => _toogleExpand(5),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Work Experienced",
                                  style: TextStyle(color: Colors.white)),
                              if (_isWork == true)
                                const Icon(Icons.keyboard_arrow_up,
                                    size: 30, color: kSecondaryColor)
                              else
                                const Icon(Icons.keyboard_arrow_down,
                                    size: 30, color: kSecondaryColor),
                            ],
                          ),
                        )
                        // padding: EdgeInsets.all(5),
                        ),
                  ),
                ),
                ExpandedSection(
                  expand: _isWork,
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(
                          left: 20, bottom: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // entrepreneurData['societies'].isNotEmpty
                          entrepreneurData['work_experiences'].isNotEmpty
                              ? TilWidget(
                                  check: "两个自己",
                                  actions: const [],
                                  title: const Text("Work Experienced",
                                      style: TextStyle(
                                          fontSize: 16, color: kPrimaryColor)),
                                  content: ItemWidget(
                                      dataName: 'work_experiences',
                                      data:
                                          entrepreneurData['work_experiences']))
                              : const SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Does not have any work experienced",
                                      textAlign: TextAlign.left,
                                      // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                                    ),
                                  )),
                          // child: AccountInfo(user: widget.user),,
                        ],
                      ),
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 100,
                // )
              ],
            )),
            if (_connect == 'Approve')
              //Personal Information
              SliverToBoxAdapter(
                  child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
                    decoration: BoxDecoration(
                      color: kThirdColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () => _toogleExpand(6),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Email Address",
                                    style: TextStyle(color: Colors.white)),
                                if (_isEmail == true)
                                  const Icon(Icons.keyboard_arrow_up,
                                      size: 30, color: kSecondaryColor)
                                else
                                  const Icon(Icons.keyboard_arrow_down,
                                      size: 30, color: kSecondaryColor),
                              ],
                            ),
                          )
                          // padding: EdgeInsets.all(5),
                          ),
                    ),
                  ),
                  ExpandedSection(
                    expand: _isEmail,
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(
                            left: 20, bottom: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            entrepreneurData['email'] != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: InkWell(
                                          onTap: () {
                                            launch("mailto:" +
                                                entrepreneurData['email']);
                                          },
                                          child: Text(
                                            entrepreneurData['email'],
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(
                                    height: 60,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Does not have any email",
                                        textAlign: TextAlign.left,
                                        // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                                      ),
                                    )),
                            // child: AccountInfo(user: widget.user),,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 100,
                  // )
                ],
              )),
            //Personal Phone
            if (_connect == 'Approve')
              SliverToBoxAdapter(
                  child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
                    decoration: BoxDecoration(
                      color: kThirdColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () => _toogleExpand(7),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Phone Number",
                                    style: TextStyle(color: Colors.white)),
                                if (_isNumber == true)
                                  const Icon(Icons.keyboard_arrow_up,
                                      size: 30, color: kSecondaryColor)
                                else
                                  const Icon(Icons.keyboard_arrow_down,
                                      size: 30, color: kSecondaryColor),
                              ],
                            ),
                          )
                          // padding: EdgeInsets.all(5),
                          ),
                    ),
                  ),
                  ExpandedSection(
                    expand: _isNumber,
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(
                            left: 20, bottom: 20, right: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            entrepreneurData['phone_number'] != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: InkWell(
                                          onTap: () {
                                            _makePhoneCall("tel:" +
                                                entrepreneurData[
                                                    'phone_number']);
                                          },
                                          child: Text(
                                            entrepreneurData['phone_number'],
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            maxLines: 2,
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(
                                    height: 60,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Does not have any Phone Number",
                                        textAlign: TextAlign.left,
                                        // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                                      ),
                                    )),
                            // child: AccountInfo(user: widget.user),,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          ],
        ),
      ),
    );
  }

  TitleBarWidget entrepreneurTitleBarWidget(entrepreneurName) {
    return TitleBarWidget(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  entrepreneurName,
                  style: Theme.of(context).textTheme.headline5!.merge(
                      const TextStyle(height: 1.1, color: kPrimaryColor)),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _validateInputs() {
    final _formData = {};
    _formData['user_id'] = userId;
    _formData['connector_id'] = connector_id;

    print("_formDataconnect${_formData}");

    Timer(const Duration(milliseconds: 600), () {
      showProgress(context);
      context
          .read<EntrepreneursBloc>()
          .add(UpdateToRequestConnected(_formData));
      // Navigator.pop(context);
      // Navigator.pushReplacementNamed(context, '/training_details_view_page',
      //     arguments: {
      //       'data': widget.data,
      //       'trainingList': widget.trainingList
      //     });
    });
  }

  Future getFuture() {
    return Future(() async {
      await Future.delayed(const Duration(seconds: 2));
      return 'Submit Successfully!';
    });
  }

  Future<void> showProgress(
    BuildContext context,
  ) async {
    var result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(getFuture(),
          message: Text('Connecting to \n' + name + ' ...')),
    );
    showResultDialog(context, result);
    // return result;
  }

  void showResultDialog(
    BuildContext context,
    String result,
  ) {
    // Navigator.pop(context);
    // getDetails(widget.data['id']);

    Navigator.pushReplacementNamed(context, '/entrepreneur_details_view_page',
        arguments: {'data': widget.data});
  }

  var entrepreneurDetail = [];
  void getDetails(id) async {
    dynamic formData = {'user_id': id};
    setState(() async {
      // entrepreneurDetail =
      //     await httpProvider.postHttp("member/info", {'user_id': id});
      // if (entrepreneurDetail != null) {
      //   // Navigator.pushReplacementNamed(
      //   //     context, '/entrepreneur_details_view_page',
      //   //     arguments: {'data': entrepreneurDetail});
      // }
    });
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

  void functionconnect(status_sent_connect) {
    if (status_sent_connect == 'not connected')
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Notices'),
                content: Text('Are you sure want to connect to ' + name),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No'),
                    style: TextButton.styleFrom(primary: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {
                      _validateInputs();
                    },
                    child: const Text('Yes'),
                    style: TextButton.styleFrom(primary: Colors.blue),
                  ),
                ],
              ));

    if (status_sent_connect == 'Pending')
      showDialog<String>(
          // barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Pending for Approval'),
                content: RichText(
                    text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                      const TextSpan(text: 'You have sent request to the '),
                      TextSpan(
                          text: name + ". \n\n",
                          style: const TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold)),
                      const TextSpan(
                        text: ' Please wait for response...',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                      ),
                    ])),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                    style: TextButton.styleFrom(primary: Colors.black),
                  ),
                ],
              ));

    if (status_sent_connect == 'Approve')
      showDialog<String>(
          // barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Connected'),
                content: RichText(
                    text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                      const TextSpan(text: 'You have connected to the '),
                      TextSpan(
                          text: name + ". \n\n",
                          style: const TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold)),
                    ])),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.pushReplacementNamed(
                      //     context,
                      //     '/entrepreneur_details_view_page',
                      //     arguments: {
                      //       'data': widget.data
                      //     });
                    },
                    child: const Text('OK'),
                    style: TextButton.styleFrom(primary: Colors.black),
                  ),
                ],
              ));
  }

  functionreferral(status_refferal, entrepreneurData) {
    if (status_refferal == 'not referral') {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: RegisterRefferalPage(data: entrepreneurData),
        ),
      );
    } else {
      showDialog<String>(
          // barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Referral'),
                content: RichText(
                    text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                      TextSpan(text: "The referral previously made to"),
                      TextSpan(
                          text: " ${entrepreneurData['name']} ",
                          style: const TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              "is currently still ${status_refferal.toString()}"),
                    ])),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.pushReplacementNamed(
                      //     context,
                      //     '/entrepreneur_details_view_page',
                      //     arguments: {
                      //       'data': widget.data
                      //     });
                    },
                    child: const Text('OK'),
                    style: TextButton.styleFrom(primary: Colors.black),
                  ),
                ],
              ));
    }
  }
}
