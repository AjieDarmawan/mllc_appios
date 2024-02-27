import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/xproject/xproject_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/widget/block_button_widget.dart';
import 'package:mlcc_app_ios/widget/til_widget.dart';
import 'package:mlcc_app_ios/widget/title_bar_widget.dart';

import '../../../widget/text_field_widget.dart';

class XProjectDetails extends StatefulWidget {
  final int projectId;

  const XProjectDetails({Key? key, required this.projectId}) : super(key: key);

  @override
  _XProjectDetailsState createState() => _XProjectDetailsState();
}

class _XProjectDetailsState extends State<XProjectDetails> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();

  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();

  int _current = 0;
  int userId = 0;
  bool isLoggedIn = false;
  bool? isFirst;
  bool? isLast;

  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  String description = "";

  final Map<String, dynamic> _formData = {
    'email': null,
    'phone_number': null,
    'name': null,
  };

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

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("userId")!;
    setState(() async {
      userId = prefs.getInt("userId")!;
      // if (userId != 0) {
      //   getRequestConnect(userId);
      // }
      isLoggedIn = prefs.getBool("isLoggedIn")!;
      // deviceToken = prefs.getString("OneSignalPlayerID") as String;
    });
  }

  _interest() async {
    var interestReturn = await httpProvider.postHttp4("project/interested",
        {'project_id': widget.projectId, 'user_id': userId});

    // Fluttertoast.showToast(
    //   msg: interestReturn,
    // );

    setState(() {
      context.read<XprojectBloc>().add(GetXprojectDetails(widget.projectId));
    });
  }

  bool _checkInterestedUser(List<dynamic> user) {
    var interest = false;
    if (user.contains(userId)) {
      interest = true;
    }

    return interest;
  }

  _guestInterest() async {
    if (email.text == '' || contact.text == '' || name.text == '') {
      // Fluttertoast.showToast(
      //   msg: 'Please fill all field required',
      // );
    } else {
      if (emailValidator.isValid(email.text)) {
        if (phoneNumberValidator.isValid(contact.text)) {
          var interestReturn =
              await httpProvider.postHttp4("project/guest_interested", {
            'project_id': widget.projectId,
            'name': name.text.toString(),
            'email': email.text.toString(),
            'phone_number': contact.text.toString()
          });

          // Fluttertoast.showToast(
          //   msg: interestReturn['status'],
          // );

          Navigator.pop(context);
          email.clear();
          name.clear();
          contact.clear();
        } else {
          // Fluttertoast.showToast(
          //   msg: 'Please enter a valid phone number',
          // );
        }
      } else {
        // Fluttertoast.showToast(
        //   msg: 'Please enter a valid email',
        // );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.projectId);
    getUser();
    context.read<XprojectBloc>().add(GetXprojectDetails(widget.projectId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<XprojectBloc, XprojectState>(builder: (context, state) {
      if (state is XprojectInitial) {
        return Container();
      } else if (state is XprojectLoading) {
        return Center(child: Container());
      } else if (state is GetXprojectDetailsSuccessful) {
        return _content(state.details);
      } else {
        return Container();
      }
    });
  }

  Widget _content(dynamic details) {
    List<dynamic> posters = details['posters'];
    description = details['description'].replaceAll(exp, '');

    return WillPopScope(
      onWillPop: () {
        context.read<XprojectBloc>().add(const GetXprojectList());
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: Text(
              details['title'],
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                posters.isNotEmpty
                    ? ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          CarouselSlider.builder(
                            itemCount: posters.length,
                            options: CarouselOptions(
                                enlargeCenterPage: true,
                                height:
                                    MediaQuery.of(context).size.height - 220,
                                autoPlay: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current = index;
                                  });
                                }),
                            itemBuilder: (context, index, realIndex) {
                              var image = posters[index];
                              return Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 1),
                                      blurRadius: 5,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                  ],
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(
                                      image['link'],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          DotsIndicator(
                            dotsCount: posters.length,
                            position: _current.toDouble(),
                            decorator: DotsDecorator(
                              size: const Size.square(9.0),
                              activeColor: kPrimaryColor,
                              activeSize: const Size(18.0, 9.0),
                              activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                            ),
                          ),
                        ],
                      )
                    : const Center(child: Text("No picture")),
                const SizedBox(
                  height: 10,
                ),
                //Text("tes"),
                TilWidget(
                  actions: const [],
                  title: const Text("Description",
                      style: TextStyle(fontSize: 16, color: kPrimaryColor)),
                  content: Html(
                    data: details['description'],
                  ),
                ),
                const SizedBox(height: 80)
              ],
            ),
          ),
          bottomSheet: interestButton(
              _checkInterestedUser(details['interested_user_id']))),
    );
  }

  Widget interestButton(bool interest) {
    return Container(
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
          Expanded(
            flex: 8,
            child: interest
                ? MaterialButton(
                    onPressed: () {},
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.grey,
                    child: const Text("Already interested",
                        style: TextStyle(color: Colors.white)),
                  )
                : MaterialButton(
                    onPressed: () {
                      if (isLoggedIn) {
                        _interest();
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                elevation: 6,
                                backgroundColor: Colors.transparent,
                                child: Wrap(
                                  children: [_dialogForm()],
                                ),
                              );
                            });
                      }
                    },
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: kPrimaryColor,
                    child: const Text("Interested",
                        style: TextStyle(color: Colors.white)),
                  ),
          ),
        ],
      ).paddingSymmetric(vertical: 10, horizontal: 20),
    );
  }

  Widget _dialogForm() {
    return Container(
        padding: EdgeInsets.only(bottom: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Form(
          key: _formKey3,
          // autovalidateMode: _autoValidate,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [Text("Guest")],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 14, left: 20, right: 20),
                  margin: EdgeInsets.only(left: 20, right: 20, top: topMargin),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
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
                        'Email',
                        style: Get.textTheme.bodyText1,
                        textAlign: TextAlign.start,
                      ),
                      TextFormField(
                        controller: email,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        style: Get.textTheme.bodyText2,
                        validator: emailValidator,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(top: 15, bottom: 15),
                            border: InputBorder.none,
                            hintText: 'johndoe@gmail.com',
                            hintStyle: Get.textTheme.caption,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            prefixIcon: const Icon(Icons.alternate_email,
                                    color: Color(0xff142860))
                                .marginOnly(right: 14),
                            prefixIconConstraints:
                                BoxConstraints.expand(width: 38, height: 38)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 14, left: 20, right: 20),
                  margin: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.zero,
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
                        'Name',
                        style: Get.textTheme.bodyText1,
                        textAlign: TextAlign.start,
                      ),
                      TextFormField(
                        controller: name,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        style: Get.textTheme.bodyText2,
                        validator:
                            RequiredValidator(errorText: 'Name is required'),
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(top: 15, bottom: 15),
                            border: InputBorder.none,
                            hintText: 'Lee Wei Wei',
                            hintStyle: Get.textTheme.caption,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            prefixIcon: const Icon(Icons.person_outline,
                                    color: Color(0xff142860))
                                .marginOnly(right: 14),
                            prefixIconConstraints:
                                BoxConstraints.expand(width: 38, height: 38)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 14, left: 20, right: 20),
                  margin: EdgeInsets.only(
                      left: 20, right: 20, bottom: bottomMargin),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
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
                        'Phone Number',
                        style: Get.textTheme.bodyText1,
                        textAlign: TextAlign.start,
                      ),
                      TextFormField(
                        controller: contact,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.phone,
                        style: Get.textTheme.bodyText2,
                        validator: phoneNumberValidator,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(top: 15, bottom: 15),
                            border: InputBorder.none,
                            hintText: '0123456789',
                            hintStyle: Get.textTheme.caption,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            prefixIcon: const Icon(Icons.phone_iphone,
                                    color: Color(0xff142860))
                                .marginOnly(right: 14),
                            prefixIconConstraints:
                                BoxConstraints.expand(width: 38, height: 38)),
                      ),
                    ],
                  ),
                ),
                BlockButtonWidget(
                  onPressed: () async {
                    _guestInterest();
                  },
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
  }

  BorderRadius get buildBorderRadius {
    if (isFirst != null && isFirst!) {
      return const BorderRadius.vertical(top: Radius.circular(10));
    }
    if (isLast != null && isLast!) {
      return const BorderRadius.vertical(bottom: Radius.circular(10));
    }
    if (isFirst != null && isLast != null) {
      return const BorderRadius.all(Radius.circular(0));
    }
    return const BorderRadius.all(Radius.circular(10));
  }

  double get topMargin {
    if ((isFirst != null && isFirst!)) {
      return 20;
    } else if (isFirst == null) {
      return 20;
    } else {
      return 0;
    }
  }

  double get bottomMargin {
    if ((isLast != null && isLast!)) {
      return 10;
    } else if (isLast == null) {
      return 10;
    } else {
      return 0;
    }
  }

  void _setInputValue(String field, String value) {
    setState(() => _formData[field] = value.trim());
  }
}
