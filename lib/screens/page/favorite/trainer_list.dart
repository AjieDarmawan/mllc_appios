import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:html/parser.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/trainings/trainings_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/favorite/favorite_view.dart';

class TrainerListPage extends StatefulWidget {
  final dynamic data;

  const TrainerListPage({Key? key, this.data}) : super(key: key);

  @override
  _TrainerListPageState createState() => _TrainerListPageState();
}

class _TrainerListPageState extends State<TrainerListPage> {
  String deviceID = '';
  int userId = 0;
  bool follow = false;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  // late String user_id = '';
  late int training_id;

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
    });
  }

  void initState() {
    getUser();
    Timer(const Duration(milliseconds: 1000), () {
      context.read<TrainingsBloc>().add(GetTrainingDetails(widget.data));
    });
    initPlatformState();
    super.initState();
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
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

  Widget build(BuildContext context) {
    return widget.data.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            itemCount: widget.data.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildTrainerList(widget.data[index]);
            })
        : Center(
            child: SizedBox(
              height: 600.0,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("No records found!",
                        style: TextStyle(color: kThirdColor.withOpacity(0.7))),
                  ]),
            ),
          );
  }

  _buildTrainerList(dynamic data) {
    if (data['wished_user_id'].isNotEmpty &&
        data['wished_user_id'].contains(userId) == true) {
      follow = true;
    } else {
      follow = false;
    }

    if (userId == 0) {
      if (data['wished_device_id'].isNotEmpty &&
          data['wished_device_id'].contains(deviceID) == true) {
        follow = true;
      } else {
        follow = false;
      }
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/trainer_details_view_page',
              arguments: {
                'data': data,
              });
        },
        child: Row(
          children: [
            Stack(
              children: <Widget>[
                SizedBox(
                  width: 75,
                  height: 75,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child:
                        (data['thumbnail'] != null && data['thumbnail'] != "")
                            ? CachedNetworkImage(
                                height: 140,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                imageUrl: data['thumbnail'],
                                placeholder: (context, url) => Image.asset(
                                  'assets/loading.gif',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 140,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error_outline),
                              )
                            : Image.asset(
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
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data['name'],
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: Theme.of(context).textTheme.bodyText1!.merge(
                              const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: kPrimaryColor)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _parseHtmlString(data['description']),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: Theme.of(context).textTheme.bodyText1!.merge(
                              TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: kThirdColor.withOpacity(0.8))),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          data['category'],
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: Theme.of(context).textTheme.bodyText1!.merge(
                              TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: kThirdColor.withOpacity(0.8))),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
                flex: 1,
                child: MaterialButton(
                  onPressed: () {
                    _validateInputTrainer(data['id']);
                  },
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: follow == false ? kPrimaryColor : Colors.grey,
                  child: follow == true
                      ? const Text("Following",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: kSecondaryColor, fontSize: 9))
                      : const Text("Follow",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: kSecondaryColor, fontSize: 9)),
                ))
          ],
        ),
      ),
    );
  }

  void _validateInputTrainer(trainer_id) {
    final _formData = {};
    if (userId != 0) {
      _formData['user_id'] = userId;
      _formData['device_id'] = '';
    } else {
      _formData['user_id'] = '';
      _formData['device_id'] = deviceID;
    }
    _formData['trainer_id'] = trainer_id;

    Timer(const Duration(milliseconds: 600), () {
      showProgressTrainer(context);
      context.read<TrainingsBloc>().add(UpdateFavoriteTrainer(_formData));
      // Navigator.pop(context);
      // Navigator.pushReplacementNamed(context, '/training_details_view_page',
      //     arguments: {
      //       'data': widget.data,
      //       'trainingList': widget.trainingList
      //     });
    });
  }

  Future<void> showProgressTrainer(
    BuildContext context,
  ) async {
    var result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(getFuture(),
          message: const Text('Unfollow Trainer...')),
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
        child: const MainScreen(page: FavoritePage(), index: 1),
      ),
    );
  }

  Future getFuture() {
    return Future(() async {
      await Future.delayed(const Duration(seconds: 2));
      return 'Submit Successfully!';
    });
  }
}
