import 'dart:async';
import 'dart:io';

// import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mlcc_app_ios/Bloc/trainings/trainings_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/favorite/favorite_view.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';
import 'package:mlcc_app_ios/screens/page/training/media_view.dart';
import 'package:mlcc_app_ios/screens/page/webview/payment_webview_page.dart';
import 'package:mlcc_app_ios/widget/block_button_widget.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';
import 'package:mlcc_app_ios/widget/text_field_widget.dart';
import 'package:mlcc_app_ios/widget/til_widget.dart';
import 'package:mlcc_app_ios/widget/title_bar_widget.dart';
// import 'package:zoom/zoom.dart';

class TrainingDetailsViewPage extends StatefulWidget {
  final dynamic data;
  final dynamic trainingList;
  final bool? wish;
  final String? type;

  const TrainingDetailsViewPage(
      {Key? key, this.data, this.trainingList, this.wish, this.type})
      : super(key: key);

  @override
  _TrainingDetailsViewPageState createState() =>
      _TrainingDetailsViewPageState();
}

class _TrainingDetailsViewPageState extends State<TrainingDetailsViewPage> {
  bool isLoggedIn = false;
  int userId = 0;
  bool joined = false;
  bool liked = false;
  bool expired = false;
  String deviceID = '';
  bool follow = false;
  bool meeting = false;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  late DateTime calendarStartAt;
  late DateTime calendarEndAt;
  String calendarTitle = "";
  String calendarDescription = "";
  late Timer timer;
  // late String user_id = '';
  late int training_id;
  late String meeting_id;
  late String meeting_passcode;
  late String email;
  late bool showExpired = false;
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool("isLoggedIn")!;
      userId = prefs.getInt("userId")!;
      email = prefs.getString('email')!;
      showExpired = prefs.getBool("isExpired")!;
    });
  }

  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
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

  Widget _DialogWithTextField(BuildContext context) => Container(
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
                  children: const [Text("Guest Join")],
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
              BlockButtonWidget(
                onPressed: () async {
                  _formData['email'] = email;
                  _formData['training_id'] = training_id;
                  _formData['phone_number'] = "+6${_formData['phone_number']}";
                  final form = _formKey2.currentState;
                  if (form!.validate()) {
                    HttpProvider httpProvider = HttpProvider();
                    form.save();
                    var guestJoinTrainingDataReturn = await httpProvider
                        .postHttp("training/guest_participate", _formData);
                    if (guestJoinTrainingDataReturn['status'] == "Joined") {
                      Navigator.pop(context);
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Join Training'),
                                content:
                                    const Text("Join Training Successfully!"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushReplacementNamed(context,
                                          '/training_details_view_page',
                                          arguments: {
                                            'data': widget.data,
                                            'trainingList': widget.trainingList
                                          });
                                    },
                                    child: const Text('OK'),
                                    style: TextButton.styleFrom(
                                        primary: Colors.black),
                                  ),
                                  if (meeting == true)
                                    TextButton(
                                      onPressed: () async {
                                        var formData = {
                                          'email': email,
                                          'training_id': training_id
                                        };
                                        var updateStatusData =
                                            await httpProvider.postHttp(
                                                "training/update_join_status",
                                                formData);
                                        // print(updateStatusData);
                                        // ZoomOptions zoomOptions = ZoomOptions(
                                        //   domain: "zoom.us",

                                        //   appKey:
                                        //       "A5Yf9hRWgNq0waFckPCTkrYD7iiiPHHGcJCo", // Replace with with key got from the Zoom Marketplace ZOOM SDK Section
                                        //   appSecret:
                                        //       "1JbO96l41cF42U32T6ieiwzKtRQGxdnxUeiQ", // Replace with with secret got from the Zoom Marketplace ZOOM SDK Section
                                        // );
                                        // var meetingOptions = ZoomMeetingOptions(
                                        //     userId: _formData['email'],
                                        //     meetingId: meeting_id,
                                        //     meetingPassword: meeting_passcode,
                                        //     disableDialIn: "true",
                                        //     disableDrive: "true",
                                        //     disableInvite: "true",
                                        //     disableShare: "true",
                                        //     noAudio: "false",
                                        //     noDisconnectAudio: "false",
                                        //     meetingViewOptions:
                                        //         ZoomMeetingOptions
                                        //                 .NO_TEXT_PASSWORD +
                                        //             ZoomMeetingOptions
                                        //                 .NO_TEXT_MEETING_ID +
                                        //             ZoomMeetingOptions
                                        //                 .NO_BUTTON_PARTICIPANTS);
                                        // var zoom = Zoom();
                                        // zoom.init(zoomOptions).then((results) {
                                        //   if (results[0] == 0) {
                                        //     zoom.onMeetingStateChanged
                                        //         .listen((status) {
                                        //       print("Meeting Status Stream: " +
                                        //           status[0] +
                                        //           " - " +
                                        //           status[1]);
                                        //       if (_isMeetingEnded(status[0])) {
                                        //         timer.cancel();
                                        //       }
                                        //     });
                                        //     zoom
                                        //         .joinMeeting(meetingOptions)
                                        //         .then((joinMeetingResult) {
                                        //       timer = Timer.periodic(
                                        //           const Duration(seconds: 2),
                                        //           (timer) {
                                        //         zoom
                                        //             .meetingStatus(
                                        //                 meetingOptions
                                        //                     .meetingId)
                                        //             .then((status) {
                                        //           print(
                                        //               "Meeting Status Polling: " +
                                        //                   status[0] +
                                        //                   " - " +
                                        //                   status[1]);
                                        //         });
                                        //       });
                                        //     });
                                        //   }
                                        // });
                                      },
                                      child: const Text('Join Meeting'),
                                      style: TextButton.styleFrom(
                                          primary: Colors.black),
                                    ),
                                ],
                              ));
                    }
                  }
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

  showGuestForm() {
    return showDialog(
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

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  @override
  void initState() {
    getUser();
    if (widget.type != null) {
      context.read<TrainingsBloc>().add(GetTrainingDetails(widget.data));
    } else {
      context.read<TrainingsBloc>().add(GetTrainingDetails(widget.data['id']));
    }

    initPlatformState();
    super.initState();
  }

  bool _isMeetingEnded(String status) {
    if (Platform.isAndroid) {
      return status == "MEETING_STATUS_DISCONNECTING" ||
          status == "MEETING_STATUS_FAILED";
    }
    return status == "MEETING_STATUS_ENDED";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainingsBloc, TrainingsState>(
        builder: (BuildContext context, TrainingsState state) {
      if (state is GetTrainingDetailsSuccessful) {
        dynamic trainingData = state.trainingData;

        training_id = trainingData['id'];

        if (trainingData['joined_user_id'].isNotEmpty &&
            trainingData['joined_user_id'].contains(userId) == true) {
          joined = true;
        }

        if (trainingData['wished_user_id'].isNotEmpty &&
            trainingData['wished_user_id'].contains(userId) == true) {
          liked = true;
        }

        if (trainingData['wished_device_id'].isNotEmpty &&
            trainingData['wished_device_id'].contains(deviceID) == true) {
          liked = true;
        }
        return _buildContent(context, trainingData);
      } else {
        return WillPopScope(
          onWillPop: () async {
            return backtoPrevious();
          },
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    if (widget.type != null) {
                      Navigator.pop(context);
                    } else {
                      if (widget.trainingList != null) {
                        Navigator.pushReplacementNamed(
                            context, '/trainings_view_page',
                            arguments: {'data': widget.trainingList});
                      } else {
                        Navigator.pushReplacementNamed(
                            context, '/trainers_view_page');
                      }
                    }
                  },
                  icon: const Icon(Icons.keyboard_arrow_left, size: 30),
                ),
                title: const Text(
                  "Training Details",
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
    if (widget.type != null) {
      Navigator.pop(context);
    } else {
      if (widget.trainingList != null) {
        Navigator.pushReplacementNamed(context, '/trainings_view_page',
            arguments: {'data': widget.trainingList});
      } else {
        Navigator.pushReplacementNamed(context, '/trainers_view_page');
      }
    }
  }

  Widget _buildContent(BuildContext context, trainingData) {
    calendarStartAt = DateTime.parse(trainingData['start_at']);
    calendarEndAt = DateTime.parse(trainingData['end_at']);
    calendarTitle = trainingData['title'];
    calendarDescription = _parseHtmlString(trainingData['description']);
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    var formatTime = DateFormat('HH:mm');

    var currentDate = formatter.format(now);
    var currentTime = formatter.format(now);

    late bool valDate;

    DateTime parseDate = DateFormat("yyyy-MM-dd").parse(trainingData['end_at']);
    DateTime start =
        DateFormat("yyyy-MM-dd HH:mm").parse(trainingData['start_at']);
    DateTime end = DateFormat("yyyy-MM-dd HH:mm").parse(trainingData['end_at']);
    DateTime StartthirtyMinAgo = start.subtract(
        const Duration(minutes: 60)); // 1 hour before the training start
    print(StartthirtyMinAgo);

    // down below is all check the time
    var startTime = formatTime.format(start);
    var endDate = formatter.format(parseDate);
    valDate = now.isBefore(parseDate);
    if (currentDate == endDate) {
      valDate = true;
      if ((now.isAfter(StartthirtyMinAgo) && now.isBefore(end))) {
        if (trainingData['zoom_id'] != "") {
          meeting_id = trainingData['zoom_id'];
          meeting_passcode = trainingData['zoom_passcode'];
          meeting = true;
        }
      }
    }
    if (valDate == false) {
      expired = true;
    }
    return WillPopScope(
      onWillPop: () async {
        return backtoPrevious();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (widget.type != null) {
                Navigator.pop(context);
              } else {
                if (widget.trainingList != null) {
                  Navigator.pushReplacementNamed(
                      context, '/trainings_view_page',
                      arguments: {'data': widget.trainingList});
                } else {
                  Navigator.pushReplacementNamed(
                      context, '/trainers_view_page');
                }
              }
            },
            icon: const Icon(Icons.keyboard_arrow_left, size: 30),
          ),
          title: const Text(
            "Training Details",
            style: TextStyle(
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
                  child: Container(
                    height: meeting == true ? 80 : 50,
                    child: Column(
                      children: [
                        if (meeting == true)
                          const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text('You can join 1 hour earlier.',
                                style: TextStyle(color: kThirdColor)),
                          ),
                        MaterialButton(
                          onPressed: () async {
                            if (expired == true &&
                                trainingData['training_videos'].length == 0) {
                            } else if (expired == true &&
                                trainingData['training_videos'].length > 0) {
                              if (userId != 0) {
                                if (showExpired != true) {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      child: MediaViewPage(
                                        trainings: trainingData,
                                      ),
                                    ),
                                  );
                                } else {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text('Notices'),
                                            content: const Text(
                                                'Membership period is expired. \nPlease make a payment to renew.'),
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
                                                  Navigator.pushNamed(context,
                                                      '/payment_webview_page',
                                                      arguments: {
                                                        'userId': userId,
                                                        'training': 0,
                                                        'event': 0,
                                                        'product': 0,
                                                      });
                                                },
                                                child: const Text('Pay'),
                                                style: TextButton.styleFrom(
                                                    primary: Colors.blue),
                                              ),
                                            ],
                                          ));
                                }
                              } else {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text(
                                              'View Training Media '),
                                          content: const Text(
                                              'Need to login first only can view this training media.'),
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
                            } else if (joined == false) {
                              if (isLoggedIn == true) {
                                print("logged in");
                                if (showExpired != true) {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text('Join Training'),
                                            content: const Text(
                                                'Are you sure want to join this training.'),
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
                                                onPressed: () async {
                                                  // Navigator.pop(context);

                                                  if (trainingData['payment'] ==
                                                      0) {
                                                    dynamic formData = {
                                                      'user_id': userId,
                                                      'training_id':
                                                          trainingData['id']
                                                    };

                                                    Timer(
                                                        const Duration(
                                                            milliseconds: 600),
                                                        () {
                                                      context
                                                          .read<TrainingsBloc>()
                                                          .add(JoinTraining(
                                                              formData));

                                                      showProgressJoin(context);
                                                    });
                                                  } else {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                      context,
                                                      PageTransition(
                                                        type: PageTransitionType
                                                            .fade,
                                                        child: PaymentWebViewPage(
                                                            userId: userId,
                                                            training:
                                                                trainingData[
                                                                    'id'],
                                                            event: 0,
                                                            trainingData:
                                                                trainingData,
                                                            trainingList: widget
                                                                .trainingList,
                                                            productID: 0),
                                                      ),
                                                    );
                                                    // Navigator.pushNamed(context,
                                                    //     '/payment_webview_page',
                                                    //     arguments: {
                                                    //       'userId': userId,
                                                    //       'training':
                                                    //           trainingData['id'],
                                                    //       'event': 0
                                                    //     });
                                                  }
                                                },
                                                child: const Text('Join'),
                                                style: TextButton.styleFrom(
                                                    primary: Colors.black),
                                              ),
                                            ],
                                          ));

                                  // dynamic formData = {
                                  //   'user_id': userId,
                                  //   'training_id': trainingData['id']
                                  // };

                                  // Timer(const Duration(milliseconds: 600), () {
                                  //   context
                                  //       .read<TrainingsBloc>()
                                  //       .add(JoinTraining(formData));
                                  //   showProgressJoin(context);
                                  // });
                                } else {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text('Notices'),
                                            content: const Text(
                                                'Membership period is expired. \nPlease make a payment to renew.'),
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
                                                  Navigator.pushNamed(context,
                                                      '/payment_webview_page',
                                                      arguments: {
                                                        'userId': userId,
                                                        'training': 0,
                                                        'event': 0,
                                                        'product': 0,
                                                      });
                                                },
                                                child: const Text('Pay'),
                                                style: TextButton.styleFrom(
                                                    primary: Colors.blue),
                                              ),
                                            ],
                                          ));
                                }
                              } else {
                                print("no logged in");
                                if (trainingData['availability'] == "Public") {
                                  if (trainingData['payment'] == 0) {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: const Text(
                                                  'Join Training for free'),
                                              content: const Text(
                                                  'Please select join method.'),
                                              actions: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context,
                                                              'Member Join Training');
                                                          Navigator.pushNamed(
                                                              context,
                                                              '/login_page');
                                                        },
                                                        child: const Text(
                                                          'Member ?',
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        style: TextButton
                                                            .styleFrom(
                                                                primary: Colors
                                                                    .blue),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(context,
                                                              'Guest Join Training');
                                                          showGuestForm();
                                                        },
                                                        child: const Text(
                                                          'Guest ?',
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        style: TextButton
                                                            .styleFrom(
                                                                primary: Colors
                                                                    .grey),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ));
                                  } else {
                                    //   showDialog<String>(
                                    //       context: context,
                                    //       builder: (BuildContext context) =>
                                    //           AlertDialog(
                                    //             title: const Text('Join Training'),
                                    //             content: const Text(
                                    //                 'Need to login first only can join this event.'),
                                    //             actions: <Widget>[
                                    //               TextButton(
                                    //                 onPressed: () {
                                    //                   Navigator.pop(context, 'OK');
                                    //                   Navigator.pushNamed(
                                    //                       context, '/login_page');
                                    //                 },
                                    //                 child: const Text('OK'),
                                    //                 style: TextButton.styleFrom(
                                    //                     primary: Colors.black),
                                    //               ),
                                    //             ],
                                    // ));

                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.fade,
                                        child: PaymentWebViewPage(
                                            userId: userId,
                                            training: trainingData['id'],
                                            event: 0,
                                            trainingData: trainingData,
                                            trainingList: widget.trainingList,
                                            productID: 0),
                                      ),
                                    );
                                  }
                                } else {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text('Join Training'),
                                            content: const Text(
                                                'Need to login first only can join this training.'),
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
                              }
                            } else {
                              if (meeting == true) {
                                var formData = {
                                  'email': email,
                                  'training_id': trainingData['id']
                                };
                                // var updateStatusData =
                                //     await httpProvider.postHttp(
                                //         "training/update_join_status",
                                //         formData);
                                // print(updateStatusData);
                                // ZoomOptions zoomOptions = ZoomOptions(
                                //   domain: "zoom.us",
                                //   //https://marketplace.zoom.us/docs/sdk/native-sdks/auth
                                //   //https://jwt.io/
                                //   //--todo from server
                                //   // jwtToken: "your jwtToken",
                                //   appKey:
                                //       "A5Yf9hRWgNq0waFckPCTkrYD7iiiPHHGcJCo", // Replace with with key got from the Zoom Marketplace ZOOM SDK Section
                                //   appSecret:
                                //       "1JbO96l41cF42U32T6ieiwzKtRQGxdnxUeiQ", // Replace with with secret got from the Zoom Marketplace ZOOM SDK Section
                                // );
                                // var meetingOptions = ZoomMeetingOptions(
                                //     userId: email,
                                //     meetingId: trainingData['zoom_id'],
                                //     meetingPassword:
                                //         trainingData['zoom_passcode'],
                                //     disableDialIn: "true",
                                //     disableDrive: "true",
                                //     disableInvite: "true",
                                //     disableShare: "true",
                                //     noAudio: "false",
                                //     noDisconnectAudio: "false",
                                //     meetingViewOptions: ZoomMeetingOptions
                                //             .NO_TEXT_PASSWORD +
                                //         ZoomMeetingOptions.NO_TEXT_MEETING_ID +
                                //         ZoomMeetingOptions
                                //             .NO_BUTTON_PARTICIPANTS);
                                // var zoom = Zoom();
                                // zoom.init(zoomOptions).then((results) {
                                //   if (results[0] == 0) {
                                //     zoom.onMeetingStateChanged.listen((status) {
                                //       print("Meeting Status Stream: " +
                                //           status[0] +
                                //           " - " +
                                //           status[1]);
                                //       if (_isMeetingEnded(status[0])) {
                                //         timer.cancel();
                                //       }
                                //     });
                                //     zoom
                                //         .joinMeeting(meetingOptions)
                                //         .then((joinMeetingResult) {
                                //       timer = Timer.periodic(
                                //           const Duration(seconds: 2), (timer) {
                                //         zoom
                                //             .meetingStatus(
                                //                 meetingOptions.meetingId)
                                //             .then((status) {
                                //           print("Meeting Status Polling: " +
                                //               status[0] +
                                //               " - " +
                                //               status[1]);
                                //         });
                                //       });
                                //     });
                                //   }
                                // });
                              } else {
                                if (trainingData['training_videos'].length >
                                    0) {
                                  if (userId != 0) {
                                    if (showExpired != true) {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.fade,
                                          child: MediaViewPage(
                                            trainings: trainingData,
                                          ),
                                        ),
                                      );
                                    } else {
                                      showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: const Text('Notices'),
                                                content: const Text(
                                                    'Membership period is expired. \nPlease make a payment to renew.'),
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
                                                      Navigator.pushNamed(
                                                          context,
                                                          '/payment_webview_page',
                                                          arguments: {
                                                            'userId': userId,
                                                            'training': 0,
                                                            'event': 0,
                                                            'product': 0,
                                                          });
                                                    },
                                                    child: const Text('Pay'),
                                                    style: TextButton.styleFrom(
                                                        primary: Colors.blue),
                                                  ),
                                                ],
                                              ));
                                    }
                                  } else {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: const Text(
                                                  'View Training Media '),
                                              content: const Text(
                                                  'Need to login first only can view this training media.'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, 'OK');
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
                                }
                              }
                            }
                          },
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: expired == true &&
                                  trainingData['training_videos'].length == 0
                              ? Colors.grey
                              : expired == true &&
                                      trainingData['training_videos'].length > 0
                                  ? kPrimaryColor
                                  : joined == false
                                      ? kPrimaryColor
                                      : meeting == true
                                          ? kPrimaryColor
                                          : trainingData['training_videos']
                                                      .length >
                                                  0
                                              ? kPrimaryColor
                                              : Colors.grey,
                          child: BlocBuilder<TrainingsBloc, TrainingsState>(
                              builder:
                                  (BuildContext context, TrainingsState state) {
                            if (state is JoinTrainingSuccessful) {
                              return const Text("You Have Joined This Training",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: kSecondaryColor));
                            } else if (state is TrainingsLoading) {
                              return const LoadingWidget();
                            } else {
                              return expired == true &&
                                      trainingData['training_videos'].length ==
                                          0
                                  ? const Text("This Training was expired",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: kSecondaryColor))
                                  : expired == true &&
                                          trainingData['training_videos'].length >
                                              0
                                      ? InkWell(
                                          onTap: () {
                                            if (userId != 0) {
                                              if (showExpired != true) {
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    child: MediaViewPage(
                                                      trainings: trainingData,
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        AlertDialog(
                                                          title: const Text(
                                                              'Notices'),
                                                          content: const Text(
                                                              'Membership period is expired. \nPlease make a payment to renew.'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: const Text(
                                                                  'Cancel'),
                                                              style: TextButton
                                                                  .styleFrom(
                                                                      primary:
                                                                          Colors
                                                                              .black),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    '/payment_webview_page',
                                                                    arguments: {
                                                                      'userId':
                                                                          userId,
                                                                      'training':
                                                                          0,
                                                                      'event':
                                                                          0,
                                                                      'product':
                                                                          0,
                                                                    });
                                                              },
                                                              child: const Text(
                                                                  'Pay'),
                                                              style: TextButton
                                                                  .styleFrom(
                                                                      primary:
                                                                          Colors
                                                                              .blue),
                                                            ),
                                                          ],
                                                        ));
                                              }
                                            } else {
                                              showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                            title: const Text(
                                                                'View Training Media '),
                                                            content: const Text(
                                                                'Need to login first only can view this training media.'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context,
                                                                      'OK');
                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      '/login_page');
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'OK'),
                                                                style: TextButton
                                                                    .styleFrom(
                                                                        primary:
                                                                            Colors.black),
                                                              ),
                                                            ],
                                                          ));
                                            }
                                          },
                                          child: const Text("View Training Video",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: kSecondaryColor)))
                                      : joined == false
                                          ? trainingData['payment'] == 0
                                              ? const Text(
                                                  "Join This Training For Free",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: kSecondaryColor))
                                              : Text(
                                                  "Join This Training For \n ${trainingData['price']}",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: kSecondaryColor))
                                          : meeting == true
                                              ? Text(
                                                  "Join Meeting (Start At ${startTime})",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: kSecondaryColor))
                                              : trainingData['training_videos']
                                                          .length ==
                                                      0
                                                  ? const Text(
                                                      "You Have Joined This Training",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: kSecondaryColor))
                                                  : InkWell(
                                                      onTap: () {
                                                        if (userId != 0) {
                                                          if (showExpired !=
                                                              true) {
                                                            Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                type:
                                                                    PageTransitionType
                                                                        .fade,
                                                                child:
                                                                    MediaViewPage(
                                                                  trainings:
                                                                      trainingData,
                                                                ),
                                                              ),
                                                            );
                                                          } else {
                                                            showDialog<String>(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    AlertDialog(
                                                                      title: const Text(
                                                                          'Notices'),
                                                                      content:
                                                                          const Text(
                                                                              'Membership period is expired. \nPlease make a payment to renew.'),
                                                                      actions: <
                                                                          Widget>[
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              const Text('Cancel'),
                                                                          style:
                                                                              TextButton.styleFrom(primary: Colors.black),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                            Navigator.pushNamed(context, '/payment_webview_page', arguments: {
                                                                              'userId': userId,
                                                                              'training': 0,
                                                                              'event': 0,
                                                                              'product': 0,
                                                                            });
                                                                          },
                                                                          child:
                                                                              const Text('Pay'),
                                                                          style:
                                                                              TextButton.styleFrom(primary: Colors.blue),
                                                                        ),
                                                                      ],
                                                                    ));
                                                          }
                                                        } else {
                                                          showDialog<String>(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  AlertDialog(
                                                                    title: const Text(
                                                                        'View Training Media '),
                                                                    content:
                                                                        const Text(
                                                                            'Need to login first only can view this training media.'),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context,
                                                                              'OK');
                                                                          Navigator.pushNamed(
                                                                              context,
                                                                              '/login_page');
                                                                        },
                                                                        child: const Text(
                                                                            'OK'),
                                                                        style: TextButton.styleFrom(
                                                                            primary:
                                                                                Colors.black),
                                                                      ),
                                                                    ],
                                                                  ));
                                                        }
                                                      },
                                                      child: const Text("View Training Video", textAlign: TextAlign.center, style: TextStyle(color: kSecondaryColor)));
                            }
                          }),
                          elevation: 0,
                          highlightElevation: 0,
                          hoverElevation: 0,
                          focusElevation: 0,
                        ),
                      ],
                    ),
                  )),
              // if (userId != 0)
              // Expanded(
              //   flex: 2,
              //   child: Container(
              //     margin: const EdgeInsets.all(5.0),
              //     padding: const EdgeInsets.only(
              //         left: 5.0, right: 5.0, top: 18.0, bottom: 18.0),
              //     decoration: const BoxDecoration(
              //         color: kPrimaryColor,
              //         borderRadius: BorderRadius.all(Radius.circular(10))),
              //     child: FavoriteButton(
              //         isFavorite: liked,
              //         iconDisabledColor: Colors.white,
              //         iconSize: 40,
              //         valueChanged: (_isFavorite) {
              //           _validateInputs();
              //         }),
              //   ),
              // )
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        ),
        body: CustomScrollView(
          primary: true,
          shrinkWrap: true,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              expandedHeight: 310,
              elevation: 0,
              floating: true,
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              centerTitle: true,
              pinned: true,
              automaticallyImplyLeading: false,
              // bottom: trainingTitleBarWidget(
              //     trainingData['title'], trainingData['caption']),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      (trainingData['thumbnail'] != null &&
                              trainingData['thumbnail'] != "")
                          ? CachedNetworkImage(
                              height: 350,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl: trainingData['thumbnail'],
                              placeholder: (context, url) => Image.asset(
                                'assets/loading.gif',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 350,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error_outline),
                            )
                          : Image.asset(
                              'assets/mlcc_logo.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 350,
                            ),
                      // if (userId != 0)
                      // Positioned(
                      //     top: 1,
                      //     right: 10,
                      //     child: FavoriteButton(
                      //         isFavorite: liked,
                      //         iconDisabledColor: Colors.white,
                      //         iconSize: 35,
                      //         valueChanged: (_isFavorite) {
                      //           _validateInputs();
                      //         })),
                    ]),
              ).marginOnly(bottom: 10),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          trainingData['title'],
                          style: Theme.of(context).textTheme.headline5!.merge(
                              const TextStyle(
                                  height: 1.1, color: kPrimaryColor)),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  TilWidget(
                    actions: const [],
                    title: const Text("Trainer",
                        style: TextStyle(fontSize: 16, color: kPrimaryColor)),
                    content: Container(
                      height: trainingData['trainer'].length * 120.0,
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: trainingData['trainer'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildTrainerList(
                                trainingData['trainer'][index]);
                          }),
                    ),
                  ),
                  trainingData['venue'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Venue",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: SelectableLinkify(
                            onOpen: (link) async {
                              if (!await launch(link.url)) {
                                throw 'Could not launch ${link.url}';
                              }
                            },
                            text: trainingData['venue'],
                            textAlign: TextAlign.left,
                          ))
                      : TilWidget(
                          actions: const [],
                          title: const Text("Venue",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: SelectableLinkify(
                            onOpen: (link) async {
                              if (!await launch(link.url)) {
                                throw 'Could not launch ${link.url}';
                              }
                            },
                            text: "Does not have the venue yet !",
                            textAlign: TextAlign.left,
                          )),
                  trainingData['description'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Description",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          // content: Text(
                          //   _parseHtmlString(trainingData['description']),
                          //   textAlign: TextAlign.left,
                          //   // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          // )
                          content: Html(
                            data: trainingData!['description'],
                            onLinkTap: (url, _, __, ___) {
                              launch(url!);
                            },
                          ),
                        )
                      : Container(),
                  (trainingData['start_at'] != null &&
                          trainingData['end_at'] != null)
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Date & Time",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            "${trainingData['start_at']} to ${trainingData['end_at']}",
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),

                  //ss

                  (joined == true)
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Zoom Link",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: TextButton(
                              child:
                                  Text('Click here to join online streaming'),
                              onPressed: () async {
                                // joinMeeting(
                                //   BuildContext context,
                                // ) {
                                //   ZoomOptions zoomOptions = ZoomOptions(
                                //     domain: "zoom.us",
                                //     //https://marketplace.zoom.us/docs/sdk/native-sdks/auth
                                //     //https://jwt.io/
                                //     //--todo from server
                                //     // jwtToken: "your jwtToken",
                                //     appKey:
                                //         "A5Yf9hRWgNq0waFckPCTkrYD7iiiPHHGcJCo", // Replace with with key got from the Zoom Marketplace ZOOM SDK Section
                                //     appSecret:
                                //         "1JbO96l41cF42U32T6ieiwzKtRQGxdnxUeiQ", // Replace with with secret got from the Zoom Marketplace ZOOM SDK Section
                                //   );
                                //   var meetingOptions = ZoomMeetingOptions(
                                //       userId: email,
                                //       meetingId: trainingData['zoom_id']
                                //           .replaceAll(' ', ''),
                                //       meetingPassword:
                                //           trainingData['zoom_passcode'],
                                //       disableDialIn: "true",
                                //       disableDrive: "true",
                                //       disableInvite: "true",
                                //       disableShare: "true",
                                //       noAudio: "false",
                                //       noDisconnectAudio: "false",
                                //       meetingViewOptions:
                                //           ZoomMeetingOptions.NO_TEXT_PASSWORD +
                                //               ZoomMeetingOptions
                                //                   .NO_TEXT_MEETING_ID +
                                //               ZoomMeetingOptions
                                //                   .NO_BUTTON_PARTICIPANTS);
                                //   var zoom = Zoom();
                                //   zoom.init(zoomOptions).then((results) {
                                //     if (results[0] == 0) {
                                //       zoom.onMeetingStateChanged
                                //           .listen((status) {
                                //         print("Meeting Status Stream: " +
                                //             status[0] +
                                //             " - " +
                                //             status[1]);
                                //         if (_isMeetingEnded(status[0])) {
                                //           timer.cancel();
                                //         }
                                //       });
                                //       zoom
                                //           .joinMeeting(meetingOptions)
                                //           .then((joinMeetingResult) async {
                                //         timer = Timer.periodic(
                                //             const Duration(seconds: 2),
                                //             (timer) {
                                //           zoom
                                //               .meetingStatus(
                                //                   meetingOptions.meetingId)
                                //               .then((status) {
                                //             print("Meeting Status Polling: " +
                                //                 status[0] +
                                //                 " - " +
                                //                 status[1]);
                                //           });
                                //         });
                                //         var formData = {
                                //           'email': email,
                                //           'training_id': trainingData['id']
                                //         };
                                //         var updateStatusData =
                                //             await httpProvider.postHttp(
                                //                 "training/update_join_status",
                                //                 formData);
                                //         updateStatusData;
                                //         print("milo " + trainingData['id']);
                                //       });
                                //     }
                                //   });
                                // }

                                // joinMeeting(context);
                              }))
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TitleBarWidget trainingTitleBarWidget(trainingTitle, trainingCaption) {
    return TitleBarWidget(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  trainingTitle,
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
          // const SizedBox(
          //   height: 5,
          // ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Text(
          //         "(" + trainingCaption + ")",
          //         style: Theme.of(context).textTheme.bodyText1!.merge(
          //             const TextStyle(
          //                 height: 1.1,
          //                 color: kPrimaryColor,
          //                 fontWeight: FontWeight.w700)),
          //         textAlign: TextAlign.center,
          //         maxLines: 2,
          //         softWrap: true,
          //         overflow: TextOverflow.ellipsis,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  void _validateInputs() {
    final _formData = {};
    if (userId != 0) {
      _formData['user_id'] = userId;
      _formData['device_id'] = '';
    } else {
      _formData['user_id'] = '';
      _formData['device_id'] = deviceID;
    }
    _formData['training_id'] = training_id;

    Timer(const Duration(milliseconds: 600), () {
      showProgress(context);
      context.read<TrainingsBloc>().add(UpdateFavoriteTraining(_formData));
      // Navigator.pop(context);
      // Navigator.pushReplacementNamed(context, '/training_details_view_page',
      //     arguments: {
      //       'data': widget.data,
      //       'trainingList': widget.trainingList
      //     });
    });
  }

  void _validateInputTrainer(trainer_id, fol) {
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
      showProgressTrainer(context, fol);
      context.read<TrainingsBloc>().add(UpdateFavoriteTrainer(_formData));
      // Navigator.pop(context);
      // Navigator.pushReplacementNamed(context, '/training_details_view_page',
      //     arguments: {
      //       'data': widget.data,
      //       'trainingList': widget.trainingList
      //     });
    });
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
              arguments: {'data': data});
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
                                fit: BoxFit.values[0],
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
              flex: 3,
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
                  if (data['description'] != '')
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
                  MaterialButton(
                    onPressed: () {
                      if (userId != 0) {
                        if (showExpired != true) {
                          _validateInputTrainer(data['id'], follow);
                        } else {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Notices'),
                                    content: const Text(
                                        'Membership period is expired. \nPlease make a payment to renew.'),
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
                                          Navigator.pushNamed(
                                              context, '/payment_webview_page',
                                              arguments: {
                                                'userId': userId,
                                                'training': 0,
                                                'event': 0,
                                                'product': 0,
                                              });
                                        },
                                        child: const Text('Pay'),
                                        style: TextButton.styleFrom(
                                            primary: Colors.blue),
                                      ),
                                    ],
                                  ));
                        }
                      } else {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Follow Trainer'),
                                  content: const Text(
                                      'Need to login first only can follow this trainer.'),
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
                    // padding: const EdgeInsets.symmetric(
                    //     horizontal: 10, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: follow == false ? kPrimaryColor : Colors.grey,
                    child: follow == true
                        ? const Text("Following",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: kSecondaryColor, fontSize: 11))
                        : const Text("Follow",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kSecondaryColor, fontSize: 11)),
                  )
                ],
              ),
            ),
            // Flexible(
            //     flex: 2,
            //     child:)
          ],
        ),
      ),
    );
  }

  Future getFuture() {
    return Future(() async {
      await Future.delayed(const Duration(seconds: 1));
      return 'Submit Successfully!';
    });
  }

  Future<void> showProgress(
    BuildContext context,
  ) async {
    var result = await showDialog(
      context: context,
      builder: (context) => FutureProgressDialog(getFuture(),
          message: const Text('Adding Wishlist...')),
    );
    showResultDialog(context, result, '');
    // return result;
  }

  Future<void> showProgressTrainer(BuildContext context, fol) async {
    var result;
    if (follow == false) {
      result = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(getFuture(),
            message: const Text('Following...')),
      );
    } else {
      result = await showDialog(
        context: context,
        builder: (context) => FutureProgressDialog(getFuture(),
            message: const Text('Unfollow Trainer...')),
      );
    }
    showResultDialog(context, result, 'follow');
    // return result;
  }

  Future<void> showProgressJoin(
    BuildContext context,
  ) async {
    var result = await showDialog(
      context: context,
      builder: (context) =>
          FutureProgressDialog(getFuture(), message: const Text('Joining...')),
    );
    showResultDialog(context, result, '');
    // return result;
  }

  void showResultDialog(
    BuildContext context,
    String result,
    String follows,
  ) {
    // Navigator.pop(context);
    if (widget.wish == true) {
      Navigator.pushReplacementNamed(context, '/training_details_view_page',
          arguments: {
            'data': widget.data,
            'trainingList': widget.trainingList,
            'wish': true
          });
    } else {
      if (follows == '') {
        Navigator.pop(context);
      }
      if (widget.type != null) {
        // Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/training_details_view_page',
            arguments: {'data': widget.data, 'type': 'Notification'});

        if (follows == '') {
          // Add2Calendar.addEvent2Cal(
          //   buildEvent(),
          // );
        }
      } else {
        Navigator.pushReplacementNamed(context, '/training_details_view_page',
            arguments: {
              'data': widget.data,
              'trainingList': widget.trainingList
            });
        if (follows == '') {
          // Add2Calendar.addEvent2Cal(
          //   buildEvent(),
          // );
        }
      }
    }
  }

  // Event buildEvent({Recurrence? recurrence}) {
  //   return Event(
  //     title: "MLCC - Training\n" + calendarTitle,
  //     description: calendarDescription,
  //     startDate: calendarStartAt,
  //     endDate: calendarEndAt,
  //     allDay: false,
  //     recurrence: recurrence,
  //   );
  // }

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
}
