import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:html/parser.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/page/adv/adv_view.dart';
import 'package:mlcc_app_ios/screens/page/adv/sponsored_user_list.dart';
import 'package:mlcc_app_ios/widget/til_widget.dart';
import 'package:mlcc_app_ios/widget/title_bar_widget.dart';

class SponsoredDetailsViewPage extends StatefulWidget {
  final dynamic data;
  final String? type;
  const SponsoredDetailsViewPage({Key? key, this.data, this.type})
      : super(key: key);

  @override
  _SponsoredDetailsViewPageState createState() =>
      _SponsoredDetailsViewPageState();
}

class _SponsoredDetailsViewPageState extends State<SponsoredDetailsViewPage> {
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
    getUser();
    // Timer(const Duration(milliseconds: 1000), () {
    // if (widget.type != null) {
    //   context.read<AdvBloc>().add(GetAdvDetails(widget.data, widget.data));
    // } else {
    //   context
    //       .read<AdvBloc>()
    //       .add(GetAdvDetails(widget.data, widget.data['id']));
    // }

    // });
    super.initState();
  }

  // Future<void> showProgressJoin(
  //     BuildContext context,
  //     ) async {
  //   var result = await showDialog(
  //     context: context,
  //     builder: (context) => FutureProgressDialog(getFuture(),
  //         message: const Text('Redeeming...')),
  //   );
  //   showResultDialog(context, result);
  //   // return result;
  // }

  void showResultDialog(
    BuildContext context,
    String result,
  ) {
    if (widget.type != null) {
      Navigator.pushReplacementNamed(context, '/sponsored_details_view_page',
          arguments: {'data': widget.data, 'type': 'Notification'});
    } else {
      Navigator.pushReplacementNamed(context, '/sponsored_details_view_page',
          arguments: {
            'data': widget.data,
          });
    }
  }

  // Future getFuture() {
  //   return Future(() async {
  //     await Future.delayed(const Duration(seconds: 2));
  //     return 'Submit Successfully!';
  //   });
  // }

  String getUsedUser() {
    List<String> usedName = [];

    widget.data['used_user'].forEach((e) => usedName.add(e['name']));

    return usedName.join(", ");
  }

  String getRedeemedUser() {
    List<String> redeemName = [];

    widget.data['redeemed_user'].forEach((e) => redeemName.add(e['name']));

    return redeemName.join(", ");
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent(context, widget.data);
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
                        ? CachedNetworkImage(
                            height: 400,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            imageUrl: rewardData['thumbnail'],
                            placeholder: (context, url) => Image.asset(
                              'assets/loading.gif',
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: 400,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error_outline),
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
                              fit: BoxFit.contain,
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
                  rewardData['redeemCount'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Number of Redeem",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            rewardData['redeemCount'].toString(),
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),
                  rewardData['left'] != null
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
                  rewardData['used_user'].isNotEmpty
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Used User",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SponsorUserListPage(
                                        userList: rewardData['used_user'],
                                        title: "Used User")),
                              );
                            },
                            child: const Text(
                              "View User",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                            ),
                          ))
                      : Container(),
                  rewardData['redeemed_user'].isNotEmpty
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Redeemed User",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SponsorUserListPage(
                                        userList: rewardData['redeemed_user'],
                                        title: "Redeemed User")),
                              );
                            },
                            child: const Text(
                              "View User",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                            ),
                          ))
                      : Container(),
                  rewardData['terms_condition'] != null
                      // ? Text("tes")
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
                            // onLinkTap: (url, _, __, ___) {
                            //   launch(url!);
                            // },
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
