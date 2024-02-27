import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/trainings/trainings_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/favorite/favorite_view.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';
import 'package:mlcc_app_ios/screens/page/training/media_list.dart';
import 'package:mlcc_app_ios/screens/page/training/trainer_list.dart';
import 'package:mlcc_app_ios/screens/page/training/training_upcoming.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';

import '../../../main.dart';

class TrainersViewPage extends StatefulWidget {
  const TrainersViewPage({Key? key}) : super(key: key);

  @override
  _TrainersViewPageState createState() => _TrainersViewPageState();
}

class _TrainersViewPageState extends State<TrainersViewPage> {
  List<dynamic> trainersList = [];
  List<dynamic> training = [];
  List<dynamic> upcomingTraining = [];
  var userId = 0;
  late bool follow;
  String deviceID = '';
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
    });
  }

  @override
  void initState() {
    getUser();
    context.read<TrainingsBloc>().add(const GetTrainersList());
    initPlatformState();
    getAllTraining();
    super.initState();
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  final List<Tab> myTabs = <Tab>[
    // const Tab(text: 'Trainings'),

    const Tab(text: 'Trainer'),
    const Tab(text: 'Upcoming'),
    const Tab(text: 'Media'),
  ];

  getAllTraining() async {
    var getAllTrainingDataReturn =
        await httpProvider.postHttp("training/listing", {'trainer_id': 0});
    if (getAllTrainingDataReturn != null) {
      var now = DateTime.now();
      var formatter = DateFormat('yyyy-MM-dd');
      var currentDate = formatter.format(now);
      late bool valDate;
      for (int i = 0; i < getAllTrainingDataReturn.length; i++) {
        DateTime parseDate = DateFormat("yyyy-MM-dd")
            .parse(getAllTrainingDataReturn[i]['end_at']);
        var endDate = formatter.format(parseDate);

        valDate = now.isBefore(parseDate);
        if (currentDate == endDate) {
          valDate = true;
        }
        if (valDate) {
          upcomingTraining.add(getAllTrainingDataReturn[i]);
        }
      }

      setState(() {
        training = getAllTrainingDataReturn;
      });
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
  Widget build(BuildContext context) {
    return BlocBuilder<TrainingsBloc, TrainingsState>(
        builder: (BuildContext context, TrainingsState state) {
      if (state is GetTrainersListSuccessful) {
        trainersList = state.trainersList;
        trainersList.removeWhere((item) => item['created_by'] == userId);
        return _buildContent(context, trainersList);
      } else {
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
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
                },
                icon: const Icon(Icons.keyboard_arrow_left, size: 30),
              ),
              title: const Text(
                "Training",
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

  backtoPrevious() {
    Navigator.of(context).popUntil((route) => route.isFirst);
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

  Widget _buildContent(BuildContext context, List<dynamic> trainersList) {
    return WillPopScope(
      onWillPop: () async {
        return backtoPrevious();
      },
      child: DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
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
              },
              icon: const Icon(Icons.keyboard_arrow_left, size: 30),
            ),
            title: const Text(
              "Training",
              style: TextStyle(
                color: kSecondaryColor,
              ),
            ),
            centerTitle: true,
            backgroundColor: kPrimaryColor,
            elevation: 0,
            bottom: TabBar(
                // controller: _tabController,
                // onTap: (index) =>
                //     setState(() => _activeTabIndex = widget.tabIndex),
                indicatorColor: kThirdColor,
                tabs: myTabs),
          ),
          body: TabBarView(
            // controller: _tabController,
            children: <Widget>[
              // TrainingsListPage(data: listData['trainings']),
              // EventsListPage(data: listData['events']),
              AllTrainerListPage(data: trainersList),
              UpcomingTrainingListPage(data: upcomingTraining),
              MediaListPage(training: training),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildTrainersList(dynamic data) {
  //   if (data['wished_user_id'].isNotEmpty &&
  //       data['wished_user_id'].contains(userId) == true) {
  //     follow = true;
  //   } else {
  //     follow = false;
  //   }

  //   if (userId == 0) {
  //     if (data['wished_device_id'].isNotEmpty &&
  //         data['wished_device_id'].contains(deviceID) == true) {
  //       follow = true;
  //     } else {
  //       follow = false;
  //     }
  //   }
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.pushReplacementNamed(context, '/trainings_view_page',
  //           arguments: {'data': data});
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.all(12),
  //       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: const BorderRadius.all(Radius.circular(10)),
  //         boxShadow: [
  //           BoxShadow(
  //             color: kThirdColor.withOpacity(0.3),
  //             blurRadius: 10,
  //           ),
  //         ],
  //         border: Border.all(color: kPrimaryColor.withOpacity(0.05)),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: <Widget>[
  //           Stack(
  //             children: <Widget>[
  //               SizedBox(
  //                 width: 75,
  //                 height: 75,
  //                 child: ClipRRect(
  //                   borderRadius: const BorderRadius.all(Radius.circular(10)),
  //                   child:
  //                       (data['thumbnail'] != null && data['thumbnail'] != "")
  //                           ? CachedNetworkImage(
  //                               height: 140,
  //                               width: double.infinity,
  //                               fit: BoxFit.cover,
  //                               imageUrl: data['thumbnail'],
  //                               placeholder: (context, url) => Image.asset(
  //                                 'assets/loading.gif',
  //                                 fit: BoxFit.cover,
  //                                 width: double.infinity,
  //                                 height: 140,
  //                               ),
  //                               errorWidget: (context, url, error) =>
  //                                   const Icon(Icons.error_outline),
  //                             )
  //                           : Image.asset(
  //                               'assets/XClub.jpg',
  //                               fit: BoxFit.cover,
  //                               width: double.infinity,
  //                               height: 140,
  //                             ),
  //                 ),
  //               ),
  //               Positioned(
  //                 bottom: 3,
  //                 right: 3,
  //                 width: 12,
  //                 height: 12,
  //                 child: Container(
  //                   decoration: const BoxDecoration(
  //                     shape: BoxShape.circle,
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //           const SizedBox(width: 15),
  //           Flexible(
  //             flex: 2,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //               children: <Widget>[
  //                 Row(
  //                   children: [
  //                     Expanded(
  //                       child: Text(
  //                         data['name'],
  //                         overflow: TextOverflow.ellipsis,
  //                         softWrap: false,
  //                         style: Theme.of(context).textTheme.bodyText1!.merge(
  //                             const TextStyle(
  //                                 fontWeight: FontWeight.w800,
  //                                 color: kPrimaryColor)),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: <Widget>[
  //                     Expanded(
  //                       child: Text(
  //                         _parseHtmlString(data['description']),
  //                         overflow: TextOverflow.ellipsis,
  //                         softWrap: false,
  //                         style: Theme.of(context).textTheme.bodyText1!.merge(
  //                             TextStyle(
  //                                 fontWeight: FontWeight.w800,
  //                                 color: kThirdColor.withOpacity(0.8))),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: <Widget>[
  //                     Expanded(
  //                       child: Text(
  //                         data['category'],
  //                         overflow: TextOverflow.ellipsis,
  //                         softWrap: false,
  //                         style: Theme.of(context).textTheme.bodyText1!.merge(
  //                             TextStyle(
  //                                 fontWeight: FontWeight.w800,
  //                                 color: kThirdColor.withOpacity(0.8))),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Flexible(
  //               flex: 1,
  //               child: MaterialButton(
  //                 onPressed: () {
  //                   if (userId != 0) {
  //                     _validateInputs(data['id']);
  //                   } else {
  //                     showDialog<String>(
  //                         context: context,
  //                         builder: (BuildContext context) => AlertDialog(
  //                               title: const Text('Follow Trainer'),
  //                               content: const Text(
  //                                   'Need to login first only can follow this trainer.'),
  //                               actions: <Widget>[
  //                                 TextButton(
  //                                   onPressed: () {
  //                                     Navigator.pop(context, 'OK');
  //                                     Navigator.pushNamed(
  //                                         context, '/login_page');
  //                                   },
  //                                   child: const Text('OK'),
  //                                   style: TextButton.styleFrom(
  //                                       primary: Colors.black),
  //                                 ),
  //                               ],
  //                             ));
  //                   }
  //                 },
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(10)),
  //                 color: follow == false ? kPrimaryColor : Colors.grey,
  //                 child: follow == true
  //                     ? const Text("Following",
  //                         textAlign: TextAlign.center,
  //                         style:
  //                             TextStyle(color: kSecondaryColor, fontSize: 10))
  //                     : const Text("Follow",
  //                         textAlign: TextAlign.center,
  //                         style:
  //                             TextStyle(color: kSecondaryColor, fontSize: 10)),
  //               ))
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // void _validateInputs(trainer_id) {
  //   final _formData = {};
  //   if (userId != 0) {
  //     _formData['user_id'] = userId;
  //     _formData['device_id'] = '';
  //   } else {
  //     _formData['user_id'] = '';
  //     _formData['device_id'] = deviceID;
  //   }
  //   _formData['trainer_id'] = trainer_id;

  //   Timer(const Duration(milliseconds: 600), () {
  //     showProgress(context);
  //     context.read<TrainingsBloc>().add(UpdateFavoriteTrainer(_formData));
  //     // Navigator.pop(context);
  //     // Navigator.pushReplacementNamed(context, '/training_details_view_page',
  //     //     arguments: {
  //     //       'data': widget.data,
  //     //       'trainingList': widget.trainingList
  //     //     });
  //   });
  // }

  // Future getFuture() {
  //   return Future(() async {
  //     await Future.delayed(const Duration(seconds: 2));
  //     return 'Submit Successfully!';
  //   });
  // }

  // Future<void> showProgress(
  //   BuildContext context,
  // ) async {
  //   var result = await showDialog(
  //     context: context,
  //     builder: (context) => FutureProgressDialog(getFuture(),
  //         message: const Text('Following...')),
  //   );
  //   showResultDialog(context, result);
  //   // return result;
  // }

  // void showResultDialog(
  //   BuildContext context,
  //   String result,
  // ) {
  //   Navigator.pop(context);

  //   Navigator.pushNamed(context, '/trainers_view_page');
  // }
}
