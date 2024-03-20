import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/adv/adv_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/page/adv/product_list.dart';
import 'package:mlcc_app_ios/screens/page/adv/rewards_list.dart';
import 'package:mlcc_app_ios/screens/page/adv/sponsored_list.dart';
import 'package:mlcc_app_ios/screens/page/adv/vouchers_list.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:mlcc_app_ios/widget/disable_screenshots.dart';
import '../../../main.dart';
import '../../main_view.dart';

class AdvPage extends StatefulWidget {
  @override
  _AdvPageState createState() => new _AdvPageState();
}

class _AdvPageState extends State<AdvPage> with SingleTickerProviderStateMixin {
  var userId = 0;
  dynamic log = [];
  TabController? _tabController;

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<void> clearSecureScreen() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  var _activeTabIndex;
  void initState() {
    // secureScreen();
    // DisableScreenshots.disable();
    super.initState();
    getSponsoredList();
    _tabController = TabController(
        vsync: this,
        length: sponsoredList.isNotEmpty ? myTabs.length : myTabs2.length);
    _tabController!.addListener(_setActiveTabIndex);
    context.read<AdvBloc>().add(GetAdvList());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    clearSecureScreen();
    super.dispose();
  }

  void getSponsoredList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final _formData = {};
    setState(() {
      userId = prefs.getInt("userId")!;

      if (userId != 0) {
        //print("newslettergetUser-masuk");
        _formData['log_user_id'] = userId;
        _formData['page'] = "Advs";
      }
    });
    sponsoredList = await httpProvider
        .postHttp3('advertisement/sponsored_ads', {"member_id": userId});

    if (userId != 0) {
      log = await httpProvider.postHttp("log/create", _formData);
    }
  }

  List<dynamic> vouchersList = [];
  List<dynamic> rewardsList = [];
  List<dynamic> productsList = [];
  List<dynamic> sponsoredList = [];
  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Rewards'),
    const Tab(text: 'Vouchers'),
    const Tab(text: 'Sponsored'),
  ];

  final List<Tab> myTabs2 = <Tab>[
    const Tab(text: 'Rewards'),
    const Tab(text: 'Vouchers'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvBloc, AdvState>(
        builder: (BuildContext context, AdvState state) {
      if (state is GetAdvListSuccessful) {
        vouchersList = state.vouchersList;
        rewardsList = state.rewardsList;
        // productsList = state.productsList;
        return _buildContent(context, vouchersList, rewardsList, sponsoredList);
      } else {
        return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Adv Zone",
                style: TextStyle(
                  color: kSecondaryColor,
                ),
              ),
              centerTitle: true,
              backgroundColor: kPrimaryColor,
              elevation: 0,
            ),
            body: const LoadingWidget());
      }
    });
  }

  Widget _buildContent(BuildContext context, List<dynamic> vouchersList,
      List<dynamic> rewardsList, List<dynamic> sponsoredList) {
    // ignore: unused_local_variable
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: DefaultTabController(
      length: sponsoredList.isNotEmpty ? myTabs.length : myTabs2.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Adv Zone'),
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: sponsoredList.isNotEmpty ? myTabs : myTabs2),
        ),
        body: Stack(
          children: [
            sponsoredList.isNotEmpty
                ? TabBarView(
                    children: <Widget>[
                      RewardsListPage(data: rewardsList),
                      VouchersListPage(data: vouchersList),
                      SponsoredListPage(data: sponsoredList)
                    ],
                  )
                : TabBarView(
                    children: <Widget>[
                      RewardsListPage(data: rewardsList),
                      VouchersListPage(data: vouchersList),
                    ],
                  )
          ],
        ),
      ),
    ));
  }

  void _setActiveTabIndex() {
    setState(() => _activeTabIndex = _tabController!.index);
  }
}
