import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:page_transition/page_transition.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:mlcc_app_ios/Bloc/dashboard/dashboard_bloc.dart';
import 'package:mlcc_app_ios/Bloc/entrepreneurs/entrepreneurs_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/page/account/referral_view.dart';

import 'package:mlcc_app_ios/screens/page/home/connect_list.dart';
import 'package:mlcc_app_ios/widget/block_button_widget.dart';

import 'package:mlcc_app_ios/widget/loading_widget.dart';
import 'package:mlcc_app_ios/widget/text_field_widget.dart';

import 'package:mlcc_app_ios/widget/title_bar_widget.dart';

import 'package:mlcc_app_ios/widget/type_card.dart';

class RefereeDetailsViewPage extends StatefulWidget {
  final dynamic data;
  final String status;
  final Color? color;
  const RefereeDetailsViewPage(
      {Key? key, this.data, required this.status, this.color})
      : super(key: key);

  @override
  _RefereeDetailsViewPageState createState() => _RefereeDetailsViewPageState();
}

class _RefereeDetailsViewPageState extends State<RefereeDetailsViewPage>
    with TickerProviderStateMixin {
  late AnimationController _resizableController;
  int userId = 0;
  String _status = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;

      final _formData_detail = {};
      _formData_detail['user_id'] = userId;
      _formData_detail['log_user_id'] = userId;

      context
          .read<EntrepreneursBloc>()
          .add(GetEntrepreneurDetails(_formData_detail));
    });
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
  var cardName = [
    'Contacted',
    'In Progress',
    'Deal On',
    'Deal Off',
  ];

  var active = [
    'unactive',
    'unactive',
    'unactive',
    'unactive',
  ];

  List<Color> colorsCard = [
    Colors.blue.shade50,
    Colors.white,
    Colors.white,
    Colors.blue.shade50
  ];

  @override
  void initState() {
    getUser();
    for (int i = 0; i < cardName.length; i++) {
      if (cardName[i] == widget.status) {
        active[i] = 'active';
      }
    }
    _resizableController = AnimationController(
      duration: const Duration(
        milliseconds: 500,
      ),
      vsync: this,
    );
    _resizableController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _resizableController.forward();
    // Timer(const Duration(milliseconds: 2000), () {
    // if (widget.status == 'Reject') {
    //   context
    //       .read<EntrepreneursBloc>()
    //       .add(GetEntrepreneurDetails(widget.data['connector_id']));
    // } else {
    //   context
    //       .read<EntrepreneursBloc>()
    //       .add(GetEntrepreneurDetails(widget.data['requestor_id']));
    // }

    // Timer(const Duration(milliseconds: 1500), () {
    //   setState(() {
    //     _isIntro = true;
    //     _isMedia = true;
    //     _isEducation = true;
    //     _isSocieties = true;
    //     _isCert = true;
    //     _isWork = true;
    //     _isEmail = true;
    //     _isNumber = true;
    //   });
    // });

    // Timer(const Duration(milliseconds: 2000), () {
    //   setState(() {
    //     _isIntro = false;
    //   });
    // });
    // });
    super.initState();
  }

  @override
  void dispose() {
    _resizableController.dispose();
    super.dispose();
  }

  colorVariation(int note) {
    if (note <= 1) {
      return Colors.blue.shade50;
    } else if (note > 1 && note <= 2) {
      return Colors.blue.shade100;
      ;
    } else if (note > 2 && note <= 3) {
      return Colors.blue.shade200;
    } else if (note > 3 && note <= 4) {
      return Colors.blue.shade300;
    } else if (note > 4 && note <= 5) {
      return Colors.blue.shade400;
    } else if (note > 5 && note <= 6) {
      return Colors.blue;
    } else if (note > 6 && note <= 7) {
      return Colors.blue.shade500;
    } else if (note > 7 && note <= 8) {
      return Colors.blue.shade600;
    } else if (note > 8 && note <= 9) {
      return Colors.blue.shade700;
    } else if (note > 9 && note <= 10) {
      return Colors.blue.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntrepreneursBloc, EntrepreneursState>(
        builder: (BuildContext context, EntrepreneursState state) {
      if (state is GetEntrepreneurDetailSuccessful) {
        dynamic entrepreneurData = state.entrepreneurData[0];

        return _buildContent(context, entrepreneurData);
      } else {
        return WillPopScope(
          onWillPop: () async {
            return backtoPrevious();
          },
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: ReferralRequestListPage(
                            userID: userId,
                            referralID: 0,
                          )),
                    );
                  },
                  icon: const Icon(Icons.keyboard_arrow_left, size: 30),
                ),
                title: const Text(
                  "Referee to Referral",
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
    Navigator.pushReplacement(
      context,
      PageTransition(
          type: PageTransitionType.fade,
          child: ReferralRequestListPage(
            userID: userId,
            referralID: 0,
          )),
    );
  }

  Widget _buildContent(BuildContext context, entrepreneurData) {
    return WillPopScope(
      onWillPop: () async {
        return backtoPrevious();
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: ReferralRequestListPage(
                        userID: userId,
                        referralID: 0,
                      )),
                );
              },
              icon: const Icon(Icons.keyboard_arrow_left, size: 30),
            ),
            title: Text(
              widget.data['name'],
              style: const TextStyle(
                color: kSecondaryColor,
              ),
            ),
            centerTitle: true,
            backgroundColor: kPrimaryColor,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                FlipCard(
                  direction: FlipDirection.HORIZONTAL,
                  speed: 1000,
                  onFlipDone: (status) {
                    print(status);
                  },
                  front: Container(
                    padding: const EdgeInsets.all(12),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: kThirdColor.withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                      border:
                          Border.all(color: kPrimaryColor.withOpacity(0.05)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                SizedBox(
                                  width: 75,
                                  height: 75,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: Image.asset(
                                      'assets/mlcc_logo.jpg',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 140,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 3,
                                  right: 3,
                                  width: 12,
                                  height: 12,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(width: 15),
                            Flexible(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.data['name'].toString(),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .merge(const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: kPrimaryColor)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          widget.data['email'].toString(),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .merge(TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: kThirdColor
                                                      .withOpacity(0.8))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          widget.data['contact'].toString(),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .merge(TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: kThirdColor
                                                      .withOpacity(0.8))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Row(
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.start,
                                  //   children: <Widget>[
                                  //     Expanded(
                                  //       child: Text(
                                  //         widget.status,
                                  //         overflow: TextOverflow.ellipsis,
                                  //         softWrap: false,
                                  //         style: Theme.of(context)
                                  //             .textTheme
                                  //             .bodyText1!
                                  //             .merge(TextStyle(
                                  //                 fontWeight: FontWeight.w800,
                                  //                 color: widget.color)),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: Text(
                                  'Tap to flip',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 12),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  back: Container(
                    padding: const EdgeInsets.all(12),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: kThirdColor.withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                      border:
                          Border.all(color: kPrimaryColor.withOpacity(0.05)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(width: 15),
                            Flexible(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Company Name : ",
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .merge(const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: kPrimaryColor)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.data['company_name']
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .merge(TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: kThirdColor
                                                      .withOpacity(0.8))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Company Address : ",
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .merge(const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: kPrimaryColor)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          widget.data['company_address']
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .merge(TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: kThirdColor
                                                      .withOpacity(0.8))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Remarks : ",
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .merge(const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: kPrimaryColor)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.data['remark'].toString(),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .merge(TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: kThirdColor
                                                      .withOpacity(0.8))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: Text(
                                  'Tap to flip',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 12),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Status :",
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: Theme.of(context).textTheme.bodyText1!.merge(
                              const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: kPrimaryColor,
                                  fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10),
                    child: AlignedGridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cardName.length,
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        itemBuilder: (context, index) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.20,
                            child: GestureDetector(
                                onTap: () {
                                  for (int i = 0; i < active.length; i++) {
                                    setState(() {
                                      active[i] = 'unactive';
                                    });
                                  }

                                  setState(() {
                                    active[index] = 'active';
                                    _status = cardName[index];
                                  });
                                },
                                child: AnimatedBuilder(
                                    animation: _resizableController,
                                    builder: (context, child) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(19)),
                                          border: Border.all(
                                              color: active[index] == 'active'
                                                  ? colorVariation(
                                                      (_resizableController
                                                                  .value *
                                                              10)
                                                          .round())
                                                  : Colors.transparent,
                                              width: 5),
                                        ),
                                        child: cardName[index] == widget.status
                                            ? Banner(
                                                message: "Current Status",
                                                location: BannerLocation.topEnd,
                                                textStyle: const TextStyle(
                                                    fontSize: 11),
                                                child: Card(
                                                  color: colorsCard[index],
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      19.0))),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Column(
                                                          // mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                      cardName[
                                                                          index],
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: const TextStyle(
                                                                          color:
                                                                              kPrimaryColor,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              13.0)),
                                                                  Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        cardName[
                                                                            index],
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                kThirdColor,
                                                                            fontSize:
                                                                                11.0),
                                                                      ))
                                                                ],
                                                              ),
                                                            ),
                                                            if (cardName[
                                                                    index] ==
                                                                'Contacted')
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    top: 15,
                                                                    right: 25.0,
                                                                    bottom:
                                                                        10.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: const [
                                                                    Icon(
                                                                        Icons
                                                                            .phone,
                                                                        size:
                                                                            30,
                                                                        color:
                                                                            kPrimaryColor),
                                                                  ],
                                                                ),
                                                              ),
                                                            if (cardName[
                                                                    index] ==
                                                                'In Progress')
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    top: 15,
                                                                    right: 25.0,
                                                                    bottom:
                                                                        10.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: const [
                                                                    Icon(
                                                                        Icons
                                                                            .rotate_left,
                                                                        size:
                                                                            30,
                                                                        color:
                                                                            kPrimaryColor),
                                                                  ],
                                                                ),
                                                              ),
                                                            if (cardName[
                                                                    index] ==
                                                                'Deal On')
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    top: 15,
                                                                    right: 25.0,
                                                                    bottom:
                                                                        10.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: const [
                                                                    Icon(
                                                                        Icons
                                                                            .thumb_up,
                                                                        size:
                                                                            30,
                                                                        color:
                                                                            kPrimaryColor),
                                                                  ],
                                                                ),
                                                              ),
                                                            if (cardName[
                                                                    index] ==
                                                                'Deal Off')
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    top: 15,
                                                                    right: 25.0,
                                                                    bottom:
                                                                        10.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: const [
                                                                    Icon(
                                                                        Icons
                                                                            .mobile_off,
                                                                        size:
                                                                            30,
                                                                        color:
                                                                            kPrimaryColor),
                                                                  ],
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ]),
                                                ),
                                              )
                                            : Card(
                                                color: colorsCard[index],
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    19.0))),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Column(
                                                        // mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                    cardName[
                                                                        index],
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: const TextStyle(
                                                                        color:
                                                                            kPrimaryColor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            13.0)),
                                                                Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 5),
                                                                    child: Text(
                                                                      cardName[
                                                                          index],
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: const TextStyle(
                                                                          color:
                                                                              kThirdColor,
                                                                          fontSize:
                                                                              11.0),
                                                                    ))
                                                              ],
                                                            ),
                                                          ),
                                                          if (cardName[index] ==
                                                              'Contacted')
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 15,
                                                                      right:
                                                                          25.0,
                                                                      bottom:
                                                                          10.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: const [
                                                                  Icon(
                                                                      Icons
                                                                          .phone,
                                                                      size: 30,
                                                                      color:
                                                                          kPrimaryColor),
                                                                ],
                                                              ),
                                                            ),
                                                          if (cardName[index] ==
                                                              'In Progress')
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 15,
                                                                      right:
                                                                          25.0,
                                                                      bottom:
                                                                          10.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: const [
                                                                  Icon(
                                                                      Icons
                                                                          .rotate_left,
                                                                      size: 30,
                                                                      color:
                                                                          kPrimaryColor),
                                                                ],
                                                              ),
                                                            ),
                                                          if (cardName[index] ==
                                                              'Deal On')
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 15,
                                                                      right:
                                                                          25.0,
                                                                      bottom:
                                                                          10.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: const [
                                                                  Icon(
                                                                      Icons
                                                                          .thumb_up,
                                                                      size: 30,
                                                                      color:
                                                                          kPrimaryColor),
                                                                ],
                                                              ),
                                                            ),
                                                          if (cardName[index] ==
                                                              'Deal Off')
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 15,
                                                                      right:
                                                                          25.0,
                                                                      bottom:
                                                                          10.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: const [
                                                                  Icon(
                                                                      Icons
                                                                          .mobile_off,
                                                                      size: 30,
                                                                      color:
                                                                          kPrimaryColor),
                                                                ],
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ]),
                                              ),
                                      );
                                    })),
                          );
                          ;
                        }),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFieldWidget(
                        labelText: "Reason",
                        hintText: "Give a reason",
                        keyboardType: TextInputType.multiline,
                        iconData: Icons.textsms,
                        // keyboardType: TextInputType.phone,
                        isFirst: false,
                        isLast: true,
                        setValue: _setInputValue,
                        field: 'reason',
                        validator:
                            RequiredValidator(errorText: 'Reason is required'),
                      ),
                      // BlockButtonWidget(
                      //   onPressed: () async {
                      //     _validateInputs();
                      //   },
                      //   color: kPrimaryColor,
                      //   text: const Text(
                      //     "Submit",
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      // ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20)
                      BlockButtonWidget(
                        onPressed: () async {
                          _validateInputs();
                        },
                        color: kPrimaryColor,
                        text: const Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20)
                    ],
                  ),
                )
              ],
            ),
          )),
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
    final form = _formKey.currentState;
    final formData = {};

    formData['user_id'] = userId;
    formData['refer_id'] = widget.data['id'];
    formData['reason'] = _formData['reason'];
    formData['status'] = _status;
    if (_status != '') {
      if (form!.validate()) {
        form.save();
        Timer(const Duration(milliseconds: 300), () {
          showProgress(context);
          context.read<DashboardBloc>().add(UpdateRefferalList(formData));
          // Navigator.pop(context);
          // Navigator.pushReplacementNamed(context, '/training_details_view_page',
          //     arguments: {
          //       'data': widget.data,
          //       'trainingList': widget.trainingList
          //     });
        });
      }
    } else {
      showDialog<String>(
          // barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Notices'),
                content: const Text('Status cannot be empty !'),
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

  Future getFuture() {
    return Future(() async {
      await Future.delayed(const Duration(seconds: 3));
      return 'Submit Successfully!';
    });
  }

  Future<void> showProgress(
    BuildContext context,
  ) async {
    var result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(getFuture(),
          message: const Text('Updating referral request data...')),
    );
    showResultDialog(context, result);
    // return result;
  }

  void showResultDialog(
    BuildContext context,
    String result,
  ) {
    // Navigator.pop(context);
    // Navigator.pop(context);

    Navigator.pushReplacement(
      context,
      PageTransition(
          type: PageTransitionType.fade,
          child: ReferralRequestListPage(
            userID: userId,
            referralID: 0,
          )),
    );
    context.read<DashboardBloc>().add(GetRefferalList(userId));
  }

  void _setInputValue(String field, String value) {
    setState(() => _formData[field] = value.trim());
  }

  void _showSuccessMessage(BuildContext context, String key) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(key), backgroundColor: Colors.red));
  }
}
