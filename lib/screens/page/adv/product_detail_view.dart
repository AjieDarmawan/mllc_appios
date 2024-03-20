import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:html/parser.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mlcc_app_ios/Bloc/adv/adv_bloc.dart';
import 'package:mlcc_app_ios/Bloc/entrepreneurs/entrepreneurs_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';
import 'package:mlcc_app_ios/screens/page/adv/adv_view.dart';
import 'package:mlcc_app_ios/screens/page/adv/product.dart';
import 'package:mlcc_app_ios/screens/page/entrepreneurs/entrepreneurs_view.dart';
import 'package:mlcc_app_ios/screens/page/webview/payment_webview_page.dart';
import 'package:mlcc_app_ios/screens/page/webview/webview_container_photo.dart';
import 'package:mlcc_app_ios/widget/block_button_widget.dart';
import 'package:mlcc_app_ios/widget/expandedSection.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';
import 'package:mlcc_app_ios/widget/text_field_widget.dart';
import 'package:mlcc_app_ios/widget/til_widget.dart';
import 'package:mlcc_app_ios/widget/title_bar_widget.dart';
import 'package:mlcc_app_ios/widget/item_widget.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class RewardDetailsViewPage extends StatefulWidget {
  final dynamic data;
  final String? type;
  const RewardDetailsViewPage({Key? key, this.data, this.type})
      : super(key: key);

  @override
  _RewardDetailsViewPageState createState() => _RewardDetailsViewPageState();
}

class _RewardDetailsViewPageState extends State<RewardDetailsViewPage> {
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<void> clearSecureScreen() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  bool isLoggedIn = false;
  int userId = 0;
  bool redeemed = false;
  bool pending = false;
  bool rejected = false;
  bool _isExpanded = false;

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool("isLoggedIn")!;
      userId = prefs.getInt("userId")!;
    });
  }

  @override
  void initState() {
    // secureScreen();
    // DisableScreenshots.disable();
    getUser();
    // Timer(const Duration(milliseconds: 1000), () {
    if (widget.type != null) {
      context.read<AdvBloc>().add(GetAdvDetails(widget.data, widget.data));
    } else {
      context
          .read<AdvBloc>()
          .add(GetAdvDetails(widget.data, widget.data['id']));
    }

    // });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    clearSecureScreen();
    super.dispose();
  }

  Future<void> showProgressJoin(
    BuildContext context,
  ) async {
    var result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(getFuture(),
          message: const Text('Redeeming...')),
    );
    showResultDialog(context, result);
    // return result;
  }

  void showResultDialog(
    BuildContext context,
    String result,
  ) {
    if (widget.type != null) {
      Navigator.pushReplacementNamed(context, '/reward_details_view_page',
          arguments: {'data': widget.data, 'type': 'Notification'});
    } else {
      Navigator.pushReplacementNamed(context, '/reward_details_view_page',
          arguments: {
            'data': widget.data,
          });
    }
  }

  Future getFuture() {
    return Future(() async {
      await Future.delayed(const Duration(seconds: 2));
      return 'Submit Successfully!';
    });
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvBloc, AdvState>(
        builder: (BuildContext context, AdvState state) {
      if (state is GetAdvDetailSuccessful) {
        dynamic rewardData = state.advData;
        if (rewardData['redeemed_user_id'].contains(userId) == true) {
          redeemed = true;
        }
        if (rewardData['pending_user_id'].contains(userId) == true) {
          pending = true;
        }
        if (rewardData['rejected_user_id'].contains(userId) == true) {
          rejected = true;
        }
        return _buildContent(context, rewardData);
      } else {
        return WillPopScope(
          onWillPop: () async {
            return backtoPrevious();
          },
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    // context.read<AdvBloc>().add(const GetAdvList());
                    // Navigator.pop(context);
                    if (widget.type != null) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          child: MainScreen(
                            page: AdvPage(),
                            index: 3,
                          ),
                        ),
                      );

                      // Navigator.pushReplacement(
                      //   context,
                      //   PageTransition(
                      //       type: PageTransitionType.fade, child: AdvPage()),
                      // );
                    }
                  },
                  icon: const Icon(Icons.keyboard_arrow_left, size: 30),
                ),
                title: const Text(
                  "Reward Details",
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

  void _toogleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  backtoPrevious() {
    if (widget.type != null) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        PageTransition(type: PageTransitionType.fade, child: AdvPage()),
      );
    }
  }

  Widget _buildContent(BuildContext context, rewardData) {
    return WillPopScope(
      onWillPop: () async {
        return backtoPrevious();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              // context.read<AdvBloc>().add(const GetAdvList());
              // Navigator.pop(context);
              if (widget.type != null) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: AdvPage()),
                );
              }
            },
            icon: const Icon(Icons.keyboard_arrow_left, size: 30),
          ),
          title: Text(
            rewardData['title'],
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
              Expanded(
                flex: 8,
                // child: Text("Status: Redeem",
                //     textAlign: TextAlign.center,
                //     style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                child: MaterialButton(
                  onPressed: () {
                    if (isLoggedIn == true) {
                      if (redeemed == false && pending == false) {
                        print("logged in");

                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Redeem Reward'),
                                  content: const Text(
                                      'Are you sure want to redeem this reward.'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                      style: TextButton.styleFrom(
                                          primary: Colors.black),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        dynamic formData = {
                                          'user_id': userId,
                                          'advertisement_id': rewardData['id']
                                        };

                                        context.read<AdvBloc>().add(RedeemAdv(
                                            formData, widget.data['id']));
                                        showProgressJoin(context);
                                      },
                                      child: const Text('Redeem'),
                                      style: TextButton.styleFrom(
                                          primary: Colors.black),
                                    ),
                                  ],
                                ));
                      }
                    } else {
                      print("no logged in");
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Redeem Reward'),
                                content: const Text(
                                    'Need to login first only can redeem this reward.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'OK');
                                      Navigator.pushNamed(
                                          context, '/login_page');
                                    },
                                    child: const Text('OK'),
                                    style: TextButton.styleFrom(
                                        primary: Colors.black),
                                  ),
                                ],
                              ));
                    }
                  },
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  // color: (redeemed == false &&
                  //         pending == false &&
                  //         rewardData['left'] > 0)
                  //     ? rejected == true
                  //         ? Colors.red
                  //         : kPrimaryColor
                  //     : Colors.grey,
                  color: (redeemed == false &&
                          pending == false &&
                          rewardData['left'] > 0)
                      ? kPrimaryColor
                      : Colors.grey,
                  child: buttonWidget(rewardData),
                ),
              ),
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
              // bottom: entrepreneurTitleBarWidget(rewardData['name']),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    (rewardData['poster'] != null && rewardData['poster'] != "")
                        ? GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/photo_webview_page', arguments: {
                                'url': rewardData['poster'],
                                'title': rewardData['title']
                              });
                            },
                            child: CachedNetworkImage(
                              height: 400,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl: rewardData['poster'],
                              placeholder: (context, url) => Image.asset(
                                'assets/loading.gif',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 400,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error_outline),
                            ),
                          )
                        : CachedNetworkImage(
                            height: 400,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl:
                                //"https://admin.xclubmy.com/img/no_photo.jpg",
                                'assets/mlcc_noPic.png',
                            placeholder: (context, url) => Image.asset(
                              'assets/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 400,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error_outline),
                          ),
                  ],
                ),
              ).marginOnly(bottom: 10),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  rewardData['caption'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Caption",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            rewardData['caption'],
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),
                  rewardData['company_name'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Company Name",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            rewardData['company_name'],
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),
                  rewardData['contact_person'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Contact Person",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            rewardData['contact_person'],
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),
                  rewardData['email'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Email",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            rewardData['email'],
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),
                  rewardData['phone_number'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Phone Number",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            rewardData['phone_number'],
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),
                  rewardData['terms_condition'] != null
                      //  ? Text("tes")

                      ? TilWidget(
                          actions: const [],
                          title: const Text("Terms & Condition",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          // content: Text(
                          //   rewardData['terms_condition'],
                          //   textAlign: TextAlign.left,
                          //   // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          // )
                          content: Html(
                            data: rewardData['terms_condition'],
                            onLinkTap: (url, _, __, ___) {
                              launch(url!);
                            },
                          ))
                      : Container(),
                  rewardData['left'] != null
                      // ? Text("tes")

                      ? TilWidget(
                          actions: const [],
                          title: const Text("Quantity Left",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            rewardData['left'].toString(),
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonWidget(rewardData) {
    Widget button = const Text("Waiting for Redeem",
        textAlign: TextAlign.center, style: TextStyle(color: kSecondaryColor));
    if (rewardData['left'] == 0) {
      button = const Text("Not More To Redeem",
          textAlign: TextAlign.center,
          style: TextStyle(color: kSecondaryColor));
    } else if (redeemed == true) {
      button = const Text("Redeemed",
          textAlign: TextAlign.center,
          style: TextStyle(color: kSecondaryColor));
    } else if (pending == true) {
      button = const Text("Pending for Approval",
          textAlign: TextAlign.center,
          style: TextStyle(color: kSecondaryColor));
    } else if (rejected == true) {
      // button = const Text("Rejected! Redeem Again",
      //     textAlign: TextAlign.center,
      //     style: TextStyle(color: kSecondaryColor));
      button = const Text("Waiting for Redeem",
          textAlign: TextAlign.center,
          style: TextStyle(color: kSecondaryColor));
    }

    return button;
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
}
