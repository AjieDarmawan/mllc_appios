import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/page/favorite/events_list.dart';
import 'package:mlcc_app_ios/screens/page/favorite/like_media.dart';
import 'package:mlcc_app_ios/screens/page/favorite/trainer_list.dart';
import 'package:mlcc_app_ios/screens/page/favorite/trainings_list.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late var deviceID;
  int userID = 0;
  final List<Tab> myTabs = <Tab>[
    // const Tab(text: 'Trainings'),
    // const Tab(text: 'Events'),
    const Tab(text: 'Trainer'),
    const Tab(text: 'Media'),
  ];
  var _activeTabIndex;

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic formData = {'user_id': prefs.getInt("userId")!};
    userID = prefs.getInt("userId")!;
    if (userID != 0) {
      // Timer(const Duration(seconds: 1), () {
      context.read<AuthBloc>().add(GetWishlistDetail(formData));
      // });
    }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
      deviceID = deviceData['id'];
      dynamic formData = {'device_id': deviceID};

      if (userID == 0) {
        Timer(const Duration(seconds: 1), () {
          context.read<AuthBloc>().add(GetWishlistDetail(formData));
        });
      }
    });
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  void initState() {
    getUser();
    initPlatformState();
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController!.addListener(_setActiveTabIndex);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _buildContent(context, dynamic listData) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wishlist'),
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          bottom: TabBar(
              // controller: _tabController,
              // onTap: (index) =>
              //     setState(() => _activeTabIndex = widget.tabIndex),
              indicatorColor: Colors.white,
              tabs: myTabs),
        ),
        body: Stack(
          children: [
            TabBarView(
              // controller: _tabController,
              children: <Widget>[
                // TrainingsListPage(data: listData['trainings']),
                // EventsListPage(data: listData['events']),
                TrainerListPage(data: listData['trainers']),
                LikeMediaViewPage(training: listData['trainings']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  dynamic listData = {};
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) async {},
      child: BlocBuilder<AuthBloc, AuthState>(
          builder: (BuildContext context, AuthState state) {
        if (state is GetListDetailsSuccessful) {
          listData = state.listData;

          return _buildContent(context, listData);
        } else {
          return Scaffold(
              appBar: AppBar(
                title: const Text(
                  "Wishlist",
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
      }),
    );
  }

  void _setActiveTabIndex() {
    setState(() => _activeTabIndex = _tabController!.index);
  }
}
