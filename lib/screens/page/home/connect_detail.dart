import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mlcc_app_ios/Bloc/dashboard/dashboard_bloc.dart';
import 'package:mlcc_app_ios/Bloc/entrepreneurs/entrepreneurs_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/page/entrepreneurs/entrepreneurs_view.dart';
import 'package:mlcc_app_ios/screens/page/home/connect_list.dart';
import 'package:mlcc_app_ios/widget/expandedSection.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';
import 'package:mlcc_app_ios/widget/til_widget.dart';
import 'package:mlcc_app_ios/widget/title_bar_widget.dart';
import 'package:mlcc_app_ios/widget/item_widget.dart';

class ConnectDetailsViewPage extends StatefulWidget {
  final dynamic data;
  final String? status;
  const ConnectDetailsViewPage({Key? key, this.data, this.status})
      : super(key: key);

  @override
  _ConnectDetailsViewPageState createState() => _ConnectDetailsViewPageState();
}

class _ConnectDetailsViewPageState extends State<ConnectDetailsViewPage> {
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
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
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

  @override
  void initState() {
    getUser();
    // Timer(const Duration(milliseconds: 2000), () {
    if (widget.status == 'Reject') {
      context
          .read<EntrepreneursBloc>()
          .add(GetEntrepreneurDetails(widget.data['connector_id']));
    } else {
      context
          .read<EntrepreneursBloc>()
          .add(GetEntrepreneurDetails(widget.data['requestor_id']));
    }

    Timer(const Duration(milliseconds: 1500), () {
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
    });

    // Timer(const Duration(milliseconds: 2000), () {
    //   setState(() {
    //     _isIntro = false;
    //   });
    // });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntrepreneursBloc, EntrepreneursState>(
        builder: (BuildContext context, EntrepreneursState state) {
      if (state is GetEntrepreneurDetailSuccessful) {
        dynamic entrepreneurData = state.entrepreneurData[0];
        // connector_id = entrepreneurData['id'];
        // name = entrepreneurData['name'];
        // if (entrepreneurData['connect_user_id'].isNotEmpty &&
        //     entrepreneurData['connect_user_id'].contains(userId) == true) {
        //   _connect = "Approve";
        // }
        // if (entrepreneurData['pending_user_id'].isNotEmpty &&
        //     entrepreneurData['pending_user_id'].contains(userId) == true) {
        //   _connect = "Pending";
        // }
        // if (entrepreneurData['reject_user_id'].isNotEmpty &&
        //     entrepreneurData['reject_user_id'].contains(userId) == true) {
        //   _connect = "Reject";
        // }
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
                        child: RequestListPage(userId: userId, resquestID: 0),
                      ),
                    );
                  },
                  icon: const Icon(Icons.keyboard_arrow_left, size: 30),
                ),
                title: const Text(
                  "Request Details",
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
        child: RequestListPage(userId: userId, resquestID: 0),
      ),
    );
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
                  child: RequestListPage(userId: userId, resquestID: 0),
                ),
              );
            },
            icon: const Icon(Icons.keyboard_arrow_left, size: 30),
          ),
          title: Text(
            entrepreneurData['name'],
            style: const TextStyle(
              color: kSecondaryColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        bottomNavigationBar: Container(
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
              if (widget.data['status'] == 'Pending')
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                        onPressed: () {
                          _validateInputs(widget.data['id'], 'Reject');
                        },
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.red,
                        child: const Text(
                          'Reject',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),

                  // child: eventData['payment'] == 0
                  //     ? const Text("Join This Event For Free",
                  //         style: TextStyle(color: kSecondaryColor))
                  //     : Text("Join This Event For ${eventData['price']}",
                  //         style: const TextStyle(color: kSecondaryColor)),
                ),
              if (widget.data['status'] == 'Pending')
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                          onPressed: () {
                            _validateInputs(widget.data['id'], 'Approve');
                          },
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.green,
                          child: const Text(
                            'Approve',
                            style: TextStyle(color: Colors.white),
                          )),
                    )),
              if (widget.data['status'] == 'Reject')
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                          onPressed: () {
                            _validateInputs(widget.data['id'], 'Pending');
                          },
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: kPrimaryColor,
                          child: const Text(
                            'Request Again',
                            style: TextStyle(color: Colors.white),
                          )),
                    )),
              if (widget.data['status'] == 'Approve')
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                          onPressed: () {
                            // _validateInputs(widget.data['id'], 'Pending');
                          },
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.grey,
                          child: const Text(
                            'Connected',
                            style: TextStyle(color: Colors.white),
                          )),
                    )),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
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
                        ? CachedNetworkImage(
                            height: 400,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: entrepreneurData['thumbnail'],
                            placeholder: (context, url) => Image.asset(
                              'assets/loading.gif',
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: 400,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error_outline),
                          )
                        : Image.asset(
                            'assets/mlcc_logo.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 400,
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
                          entrepreneurData['work_experiences'] != null
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

            // //Personal Information
            // SliverToBoxAdapter(
            //     child: Column(
            //   children: [
            //     Container(
            //       padding: const EdgeInsets.all(5),
            //       margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
            //       decoration: BoxDecoration(
            //         color: kThirdColor,
            //         borderRadius: const BorderRadius.only(
            //           topRight: Radius.circular(15),
            //           topLeft: Radius.circular(15),
            //         ),
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.grey.withOpacity(0.1),
            //             spreadRadius: 5,
            //             blurRadius: 7,
            //             offset:
            //                 const Offset(0, 3), // changes position of shadow
            //           ),
            //         ],
            //       ),
            //       child: InkWell(
            //         onTap: () => _toogleExpand(6),
            //         child: SizedBox(
            //             width: MediaQuery.of(context).size.width,
            //             child: Padding(
            //               padding: const EdgeInsets.all(15.0),
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   const Text("Email Address",
            //                       style: TextStyle(color: Colors.white)),
            //                   if (_isEmail == true)
            //                     const Icon(Icons.keyboard_arrow_up,
            //                         size: 30, color: kSecondaryColor)
            //                   else
            //                     const Icon(Icons.keyboard_arrow_down,
            //                         size: 30, color: kSecondaryColor),
            //                 ],
            //               ),
            //             )
            //             // padding: EdgeInsets.all(5),
            //             ),
            //       ),
            //     ),
            //     ExpandedSection(
            //       expand: _isEmail,
            //       child: SizedBox(
            //         width: double.infinity,
            //         child: Container(
            //           padding: const EdgeInsets.all(5),
            //           margin: const EdgeInsets.only(
            //               left: 20, bottom: 20, right: 20),
            //           decoration: BoxDecoration(
            //             color: Colors.grey[50],
            //             borderRadius: const BorderRadius.only(
            //               bottomRight: Radius.circular(15),
            //               bottomLeft: Radius.circular(15),
            //             ),
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.grey.withOpacity(0.1),
            //                 spreadRadius: 5,
            //                 blurRadius: 7,
            //                 offset: const Offset(
            //                     0, 3), // changes position of shadow
            //               ),
            //             ],
            //           ),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: <Widget>[
            //               entrepreneurData['email'] != null
            //                   ? Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Padding(
            //                           padding: const EdgeInsets.all(10.0),
            //                           child: InkWell(
            //                             onTap: () {
            //                               launch("mailto:" +
            //                                   entrepreneurData['email']);
            //                             },
            //                             child: Text(
            //                               entrepreneurData['email'],
            //                               overflow: TextOverflow.ellipsis,
            //                               softWrap: false,
            //                               maxLines: 2,
            //                               style: const TextStyle(
            //                                   color: Colors.grey),
            //                             ),
            //                           ),
            //                         ),
            //                       ],
            //                     )
            //                   : const SizedBox(
            //                       height: 60,
            //                       child: Padding(
            //                         padding: EdgeInsets.all(8.0),
            //                         child: Text(
            //                           "Does not have any email",
            //                           textAlign: TextAlign.left,
            //                           // style: TextStyle(fontSize: 16, color: kPrimaryColor),
            //                         ),
            //                       )),
            //               // child: AccountInfo(user: widget.user),,
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //     // const SizedBox(
            //     //   height: 100,
            //     // )
            //   ],
            // )),
            //Personal Phone

            // SliverToBoxAdapter(
            //     child: Column(
            //   children: [
            //     Container(
            //       padding: const EdgeInsets.all(5),
            //       margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
            //       decoration: BoxDecoration(
            //         color: kThirdColor,
            //         borderRadius: const BorderRadius.only(
            //           topRight: Radius.circular(15),
            //           topLeft: Radius.circular(15),
            //         ),
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.grey.withOpacity(0.1),
            //             spreadRadius: 5,
            //             blurRadius: 7,
            //             offset:
            //                 const Offset(0, 3), // changes position of shadow
            //           ),
            //         ],
            //       ),
            //       child: InkWell(
            //         onTap: () => _toogleExpand(7),
            //         child: SizedBox(
            //             width: MediaQuery.of(context).size.width,
            //             child: Padding(
            //               padding: const EdgeInsets.all(15.0),
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   const Text("Phone Number",
            //                       style: TextStyle(color: Colors.white)),
            //                   if (_isNumber == true)
            //                     const Icon(Icons.keyboard_arrow_up,
            //                         size: 30, color: kSecondaryColor)
            //                   else
            //                     const Icon(Icons.keyboard_arrow_down,
            //                         size: 30, color: kSecondaryColor),
            //                 ],
            //               ),
            //             )
            //             // padding: EdgeInsets.all(5),
            //             ),
            //       ),
            //     ),
            //     ExpandedSection(
            //       expand: _isNumber,
            //       child: SizedBox(
            //         width: double.infinity,
            //         child: Container(
            //           padding: const EdgeInsets.all(5),
            //           margin: const EdgeInsets.only(
            //               left: 20, bottom: 20, right: 20),
            //           decoration: BoxDecoration(
            //             color: Colors.grey[50],
            //             borderRadius: const BorderRadius.only(
            //               bottomRight: Radius.circular(15),
            //               bottomLeft: Radius.circular(15),
            //             ),
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.grey.withOpacity(0.1),
            //                 spreadRadius: 5,
            //                 blurRadius: 7,
            //                 offset: const Offset(
            //                     0, 3), // changes position of shadow
            //               ),
            //             ],
            //           ),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: <Widget>[
            //               entrepreneurData['phone_number'] != null
            //                   ? Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Padding(
            //                           padding: const EdgeInsets.all(10.0),
            //                           child: InkWell(
            //                             onTap: () {
            //                               launch("tel:" +
            //                                   entrepreneurData['phone_number']);
            //                             },
            //                             child: Text(
            //                               entrepreneurData['phone_number'],
            //                               overflow: TextOverflow.ellipsis,
            //                               softWrap: false,
            //                               maxLines: 2,
            //                               style: const TextStyle(
            //                                   color: Colors.grey),
            //                             ),
            //                           ),
            //                         ),
            //                       ],
            //                     )
            //                   : const SizedBox(
            //                       height: 60,
            //                       child: Padding(
            //                         padding: EdgeInsets.all(8.0),
            //                         child: Text(
            //                           "Does not have any Phone Number",
            //                           textAlign: TextAlign.left,
            //                           // style: TextStyle(fontSize: 16, color: kPrimaryColor),
            //                         ),
            //                       )),
            //               // child: AccountInfo(user: widget.user),,
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // )),
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

  void _validateInputs(connectid, status) {
    final _formData = {};
    if (status == 'Pending') {
      _formData['user_id'] = widget.data['connector_id'];
      _formData['connect_id'] = connectid;
      _formData['status'] = status;
    } else {
      _formData['user_id'] = userId;
      _formData['connect_id'] = connectid;
      _formData['status'] = status;
    }
    Timer(const Duration(milliseconds: 600), () {
      showProgress(context);
      context.read<DashboardBloc>().add(UpdateRequestList(_formData));
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
          message: const Text('Updating request data...')),
    );
    showResultDialog(context, result);
    // return result;
  }

  void showResultDialog(
    BuildContext context,
    String result,
  ) {
    // Navigator.pop(context);

    Navigator.pushReplacement(
      context,
      PageTransition(
          type: PageTransitionType.fade,
          child: RequestListPage(userId: userId, resquestID: 0)),
    );
  }
}
