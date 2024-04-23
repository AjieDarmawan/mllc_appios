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
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:mlcc_app_ios/screens/page/auth/login_page.dart';
import 'package:mlcc_app_ios/screens/page/home/home_swiper_event.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mlcc_app_ios/Bloc/entrepreneurs/entrepreneurs_bloc.dart';
import 'package:mlcc_app_ios/Bloc/events/events_bloc.dart';
import 'package:mlcc_app_ios/Bloc/trainings/trainings_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/favorite/favorite_view.dart';
import 'package:mlcc_app_ios/screens/page/webview/payment_webview_page.dart';
import 'package:mlcc_app_ios/widget/block_button_widget.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';
import 'package:mlcc_app_ios/widget/text_field_widget.dart';
import 'package:mlcc_app_ios/widget/til_widget.dart';
import 'package:mlcc_app_ios/widget/title_bar_widget.dart';
import 'package:mlcc_app_ios/widget/item_widget.dart';

import 'events_view.dart';

class EventDetailsViewPage extends StatefulWidget {
  final dynamic data;
  final int? id;
  final bool? wish;
  final String? type;
  const EventDetailsViewPage(
      {Key? key, this.data, this.wish, this.type, this.id})
      : super(key: key);

  @override
  _EventDetailsViewPageState createState() => _EventDetailsViewPageState();
}

class _EventDetailsViewPageState extends State<EventDetailsViewPage> {
  bool isLoggedIn = false;
  int userId = 0;
  bool joined = false;
  bool liked = false;
  bool expired = false;
  late int event_id;
  String deviceID = '';
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  late DateTime calendarStartAt;
  late DateTime calendarEndAt;
  String calendarVenue = "";
  String calendarTitle = "";
  String calendarDescription = "";
  final SwiperController _swiperControllerevent = SwiperController();
  late bool showExpired = false;
  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool("isLoggedIn")!;
      userId = prefs.getInt("userId")!;
      showExpired = prefs.getBool("isExpired")!;
    });
  }

  Future<void> share(id, name) async {
    await FlutterShare.share(
        title: name.toString(),
        text: '',
        linkUrl: apireal + 'shared/events/' + id.toString(),
        chooserTitle: 'Share');
  }

  @override
  void initState() {
    //context.read<EventsBloc>().add(GetEventDetails(34));

    if (widget.type != null) {
      context.read<EventsBloc>().add(GetEventDetails(widget.data));
    } else {
      context.read<EventsBloc>().add(
          GetEventDetails(widget.id == null ? widget.data['id'] : widget.id));
    }
    getUser();
    initPlatformState();
    super.initState();
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
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
                  _formData['event_id'] = event_id;
                  _formData['phone_number'] = "+6${_formData['phone_number']}";
                  final form = _formKey2.currentState;
                  if (form!.validate()) {
                    HttpProvider httpProvider = HttpProvider();
                    form.save();
                    var guestJoinEventDataReturn = await httpProvider.postHttp(
                        "event/guest_participate", _formData);
                    if (guestJoinEventDataReturn['status'] == "Joined") {
                      Navigator.pop(context);
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Join Event'),
                                content: const Text("Join Event Successfully!"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushReplacementNamed(
                                          context, '/event_details_view_page',
                                          arguments: {
                                            'data': widget.data,
                                          });
                                    },
                                    child: const Text('OK'),
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
      deviceID = deviceData['model'];
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
    return BlocBuilder<EventsBloc, EventsState>(
        builder: (BuildContext context, EventsState state) {
      if (state is GetEventDetailSuccessful) {
        dynamic eventData = state.eventData;

        event_id = eventData['id'];
        if (eventData['joined_user_id'].isNotEmpty &&
            eventData['joined_user_id'].contains(userId) == true) {
          joined = true;
        }

        if (eventData['wished_user_id'].isNotEmpty &&
            eventData['wished_user_id'].contains(userId) == true) {
          liked = true;
        }
        return _buildContent(context, eventData);
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
                      Navigator.pushReplacementNamed(
                          context, '/events_view_page');

                      // Navigator.pop(context);
                      //       Navigator.push(
                      //   context,

                      //   PageTransition(
                      //     type: PageTransitionType.fade,
                      //     child: const MainScreen(
                      //       page: EventsViewPage(),
                      //       index: 2,
                      //     ),
                      //   ),
                      // );
                    } else {
                      Navigator.pushReplacementNamed(
                          context, '/events_view_page');
                      //       Navigator.push(
                      //   context,

                      //   PageTransition(
                      //     type: PageTransitionType.fade,
                      //     child: const MainScreen(
                      //       page: EventsViewPage(),
                      //       index: 2,
                      //     ),
                      //   ),
                      // );
                    }
                  },
                  icon: const Icon(Icons.keyboard_arrow_left, size: 30),
                ),
                title: const Text(
                  "Event Details",
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
      // Navigator.pushReplacementNamed(context, '/events_view_page');
      Navigator.push(
        context,
        // PageTransition(
        //   type: PageTransitionType.fade,
        //   child: const EventsViewPage(),
        // ),
        PageTransition(
          type: PageTransitionType.fade,
          child: const MainScreen(
            page: EventsViewPage(),
            index: 2,
          ),
        ),
      );
    }
  }

  Widget _buildContent(BuildContext context, eventData) {
    // calendarStartAt = DateTime.parse(eventData['start_at']);
    // calendarEndAt = DateTime.parse(eventData['end_at']);
    // calendarVenue = eventData['venue'];
    // calendarTitle = eventData['title'];
    // calendarDescription = _parseHtmlString(eventData['description']);

    calendarStartAt = DateTime.parse(eventData['start_at']);
    calendarEndAt = DateTime.parse(eventData['end_at']);
    calendarVenue = eventData['venue'];
    calendarTitle = eventData['title'];
    calendarDescription = _parseHtmlString(
        eventData['description'] == null ? "" : eventData['description']);

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    var currentDate = formatter.format(now);
    late bool valDate;

    DateTime parseDate = DateFormat("yyyy-MM-dd").parse(eventData['end_at']);
    valDate = now.isBefore(parseDate);
    var endDate = formatter.format(parseDate);
    if (currentDate == endDate) {
      valDate = true;
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
              Navigator.pushReplacementNamed(context, '/events_view_page');

              // if (widget.type != null) {
              //   // Navigator.pop(context);
              //   Navigator.push(
              //     context,

              //     PageTransition(
              //       type: PageTransitionType.fade,
              //       child: const MainScreen(
              //         page: EventsViewPage(),
              //         index: 2,
              //       ),
              //     ),
              //   );
              // } else {
              //   // Navigator.pushReplacementNamed(context, '/events_view_page');
              //   Navigator.push(
              //     context,

              //     PageTransition(
              //       type: PageTransitionType.fade,
              //       child: const MainScreen(
              //         page: EventsViewPage(),
              //         index: 2,
              //       ),
              //     ),
              //   );
              // }
            },
            icon: const Icon(Icons.keyboard_arrow_left, size: 30),
          ),
          title: const Text(
            "Event Details",
            style: TextStyle(
              color: kSecondaryColor,
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                onPressed: () {
                  share(widget.id == null ? widget.data['id'] : widget.id,
                      eventData['title']);
                })
          ],
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
                  child: MaterialButton(
                    onPressed: () {
                      if (expired == false) {
                        if (eventData['balance'] > 0) {
                          if (joined == false) {
                            if (isLoggedIn == true) {
                              print("logged in");
                              if (showExpired != true) {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text('Join Event'),
                                          content: const Text(
                                              'Are you sure want to join this event.'),
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
                                                // Navigator.pop(context);

                                                if (eventData['payment'] == 0) {
                                                  dynamic formData = {
                                                    'user_id': userId,
                                                    'event_id': eventData['id']
                                                  };

                                                  Timer(
                                                      const Duration(
                                                          milliseconds: 600),
                                                      () {
                                                    context
                                                        .read<EventsBloc>()
                                                        .add(JoinEvent(
                                                            formData));

                                                    showProgressJoin(context);
                                                    // Navigator.pushReplacementNamed(
                                                    //     context, '/event_details_view_page',
                                                    //     arguments: {'data': widget.data});
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
                                                          training: 0,
                                                          event:
                                                              eventData['id'],
                                                          eventData: eventData,
                                                          productID: 0),
                                                    ),
                                                  );
                                                  // Navigator.pushNamed(context,
                                                  //     '/payment_webview_page',
                                                  //     arguments: {
                                                  //       'userId': userId,
                                                  //       'training': 0,
                                                  //       'event': eventData['id'],
                                                  //     });
                                                }
                                              },
                                              child: const Text('Join'),
                                              style: TextButton.styleFrom(
                                                  primary: Colors.black),
                                            ),
                                          ],
                                        ));
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

                              // dynamic formData = {
                              //   'user_id': userId,
                              //   'event_id': eventData['id']
                              // };

                              // Timer(const Duration(milliseconds: 600), () {
                              //   showProgressJoin(context);
                              //   context.read<EventsBloc>().add(JoinEvent(formData));
                              //   // Navigator.pushReplacementNamed(
                              //   //     context, '/event_details_view_page',
                              //   //     arguments: {'data': widget.data});
                              // });
                            } else {
                              print("no logged in");
                              if (eventData['availability'] == 'Public') {
                                if (eventData['payment'] == 0) {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text(
                                                'Join Event for free'),
                                            content: const Text(
                                                'Please select join method.'),
                                            actions: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context,
                                                            'Member Join Event');
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/login_page');
                                                      },
                                                      child: const Text(
                                                        'Member ?',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      style:
                                                          TextButton.styleFrom(
                                                              primary:
                                                                  Colors.blue),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context,
                                                            'Guest Join Event');
                                                        showGuestForm();
                                                      },
                                                      child: const Text(
                                                        'Guest ?',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      style:
                                                          TextButton.styleFrom(
                                                              primary:
                                                                  Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ));
                                } else {
                                  // showDialog<String>(
                                  //     context: context,
                                  //     builder: (BuildContext context) =>
                                  //         AlertDialog(
                                  //           title: const Text('Join Training'),
                                  //           content: const Text(
                                  //               'Need to login first only can join this event.'),
                                  //           actions: <Widget>[
                                  //             TextButton(
                                  //               onPressed: () {
                                  //                 Navigator.pop(context, 'OK');
                                  //                 Navigator.pushNamed(
                                  //                     context, '/login_page');
                                  //               },
                                  //               child: const Text('OK'),
                                  //               style: TextButton.styleFrom(
                                  //                   primary: Colors.black),
                                  //             ),
                                  //           ],
                                  //         ));
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      child: PaymentWebViewPage(
                                          userId: userId,
                                          training: 0,
                                          event: eventData['id'],
                                          eventData: eventData,
                                          productID: 0),
                                    ),
                                  );
                                }
                              } else {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text('Join Events'),
                                          content: Text(
                                              "Need to  login first only can join this event."),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.pop(context, 'OK');
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginPage(
                                                              id: eventData[
                                                                  'id'],
                                                              type: "events",
                                                            )));
                                                // Navigator.pushNamed(
                                                //     context, '/login_page',
                                                //     arguments: {
                                                //       id: eventData['id']
                                                //     });
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
                        } else {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Join Events'),
                                    content: const Text(
                                        'The event is fully register.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, 'OK');
                                          // Navigator.pushNamed(
                                          //     context, '/login_page');
                                        },
                                        child: const Text('OK'),
                                        style: TextButton.styleFrom(
                                            primary: Colors.black),
                                      ),
                                    ],
                                  ));
                        }
                      }
                    },
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: expired == true
                        ? Colors.grey
                        : eventData['balance'] == 0
                            ? Colors.grey
                            : joined == false
                                ? kPrimaryColor
                                : Colors.grey,
                    child: BlocBuilder<EventsBloc, EventsState>(
                        builder: (BuildContext context, EventsState state) {
                      if (state is JoinEventSuccessful) {
                        return const Text("You Have Joined This Event",
                            style: TextStyle(color: kSecondaryColor));
                      } else if (state is EventsLoading) {
                        return const LoadingWidget();
                      } else {
                        return expired == true
                            ? const Text("The Event Was Expired",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: kSecondaryColor))
                            : eventData['balance'] == 0
                                ? const Text("The Event Is Fully Register",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: kSecondaryColor))
                                : joined == true
                                    ? const Text("You Have Joined This Event",
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(color: kSecondaryColor))
                                    : eventData['payment'] == 0
                                        ? const Text("Join This Event For Free",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: kSecondaryColor))
                                        : Text(
                                            "Join This Event For ${eventData['price']}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: kSecondaryColor));
                      }
                    }),
                    // child: eventData['payment'] == 0
                    //     ? const Text("Join This Event For Free",
                    //         style: TextStyle(color: kSecondaryColor))
                    //     : Text("Join This Event For ${eventData['price']}",
                    //         style: const TextStyle(color: kSecondaryColor)),
                    elevation: 0,
                    highlightElevation: 0,
                    hoverElevation: 0,
                    focusElevation: 0,
                  )),
              // Expanded(
              //   flex: 2,
              //   child: Container(
              //     margin: const EdgeInsets.all(5.0),
              //     padding: const EdgeInsets.only(
              //         left: 5.0, right: 5.0, top: 8.0, bottom: 8.0),
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
              // bottom: trainingTitleBarWidget(eventData['title']),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    (eventData['multi_images'].length > 0 &&
                            eventData['multi_images'].length > 0)
                        ? HomeSwipeEvent(
                            images: eventData['multi_images'],
                            title: eventData['title'],
                            swiperControllerbanner_: _swiperControllerevent,
                            height: MediaQuery.of(context).size.height * 0.30,
                          )
                        : (eventData['banner'] != null &&
                                eventData['banner'] != "")
                            ? GestureDetector(
                                child: CachedNetworkImage(
                                  height: 350,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  imageUrl: eventData['banner'],
                                  placeholder: (context, url) => Image.asset(
                                    'assets/loading.gif',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 350,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error_outline),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/photo_webview_page',
                                      arguments: {
                                        'url': eventData['banner'],
                                        'title': eventData['title']
                                      });
                                },
                              )
                            : Image.asset(
                                'assets/mlcc_logo.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 350,
                              ),
                  ],
                ),
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
                          eventData['title'],
                          style: Theme.of(context).textTheme.headline5!.merge(
                              const TextStyle(
                                  height: 2.1, color: kPrimaryColor)),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  eventData['description'] != null
                      //  ? Text("tes")

                      ? TilWidget(
                          actions: const [],
                          title: const Text("Description",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          // content: Text(
                          //   _parseHtmlString(eventData['description']),
                          //   textAlign: TextAlign.left,
                          //   // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          // )
                          content: Html(
                            data: eventData!['description'],
                            onLinkTap: (url, _, __, ___) {
                              launch(url!);
                            },
                          ),
                        )
                      : Container(),
                  eventData['venue'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Venue",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            eventData['venue'],
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),
                  (eventData['start_at'] != null && eventData['end_at'] != null)
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Date & Time",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            "${eventData['start_at']} to ${eventData['end_at']}",
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

  TitleBarWidget trainingTitleBarWidget(trainingTitle) {
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

    _formData['event_id'] = event_id;

    Timer(const Duration(milliseconds: 600), () {
      showProgress(context);
      context.read<EventsBloc>().add(UpdateFavoriteEvents(_formData));
      // Navigator.pop(context);
      // Navigator.pushReplacementNamed(context, '/event_details_view_page',
      //     arguments: {'data': widget.data});
    });
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
    showResultDialog(context, result);
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
    showResultDialog(context, result);
    // return result;
  }

  void showResultDialog(
    BuildContext context,
    String result,
  ) {
    Navigator.pop(context);
    if (widget.type != null) {
      Navigator.pushReplacementNamed(context, '/event_details_view_page',
          arguments: {'data': widget.data, 'type': 'Notification'});
    } else {
      Navigator.pushReplacementNamed(context, '/event_details_view_page',
          arguments: {'data': widget.data});
    }
  }

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
