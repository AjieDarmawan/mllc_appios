import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:html/parser.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mlcc_app_ios/Bloc/adv/adv_bloc.dart';
import 'package:mlcc_app_ios/Bloc/entrepreneurs/entrepreneurs_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/provider/http_provider.dart';
import 'package:mlcc_app_ios/screens/page/adv/adv_view.dart';
import 'package:mlcc_app_ios/screens/page/entrepreneurs/entrepreneurs_view.dart';
import 'package:mlcc_app_ios/screens/page/webview/webview_container_photo.dart';
import 'package:mlcc_app_ios/widget/block_button_widget.dart';
import 'package:mlcc_app_ios/widget/expandedSection.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';
import 'package:mlcc_app_ios/widget/text_field_widget.dart';
import 'package:mlcc_app_ios/widget/til_widget.dart';
import 'package:mlcc_app_ios/widget/title_bar_widget.dart';
import 'package:mlcc_app_ios/widget/item_widget.dart';
import 'package:image_downloader/image_downloader.dart';

import '../../../main.dart';

class VoucherDetailsViewPage extends StatefulWidget {
  final dynamic data;
  final String? type;
  const VoucherDetailsViewPage({Key? key, this.data, this.type})
      : super(key: key);

  @override
  _VoucherDetailsViewPageState createState() => _VoucherDetailsViewPageState();
}

class _VoucherDetailsViewPageState extends State<VoucherDetailsViewPage> {
  bool isLoggedIn = false;
  int userId = 0;
  bool redeemed = false;
  bool used = false;
  bool verified = false;
  bool _isExpanded = false;
  var imageId;
  String deviceID = '';
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  final Map<String, dynamic> _formData = {
    'advertisement_id': null,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  var redeemCode = "";
  bool redeemGuest = false;

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
      print(deviceID);
    });

    _formData['advertisement_id'] = widget.data['id'];
    _formData['device_id'] = deviceID;
    _formData['action'] = 'open';
    if (isLoggedIn == true) {
      setState(() {});
    } else {
      var guestRedeemAdvReturn = await httpProvider.postHttp3(
          'advertisement/device_guest_redeem', _formData);
      if (guestRedeemAdvReturn['status'] == 'Redeemed') {
        setState(() {
          redeemGuest = true;
          print('betul2');
        });
      } else {
        setState(() {
          redeemGuest = false;
          print('salah2');
        });
      }
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

  Future<void> checkRedeem() async {
    _formData['advertisement_id'] = widget.data['id'];
    _formData['device_id'] = deviceID;
    _formData['action'] = 'open';
    var guestRedeemAdvReturn = await httpProvider.postHttp3(
        'advertisement/device_guest_redeem', _formData);
    if (guestRedeemAdvReturn['status'] == 'Redeemed') {
      setState(() {
        redeemGuest = true;
      });
    } else {
      setState(() {
        redeemGuest = false;
      });
    }
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool("isLoggedIn")!;
      userId = prefs.getInt("userId")!;
    });
    print(userId);
  }

  Widget _DialogWithTextField(
          BuildContext context, advertisementId, passcode, passtype) =>
      Wrap(
        children: [
          Container(
              padding: const EdgeInsets.only(bottom: 20),
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
                          children: const [Text("Guest Redeem")],
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
                        validator:
                            RequiredValidator(errorText: 'Name is required'),
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
                          _formData['advertisement_id'] = advertisementId;
                          print(advertisementId);
                          _formData['phone_number'] =
                              "+6${_formData['phone_number']}";
                          final form = _formKey2.currentState;
                          if (form!.validate()) {
                            HttpProvider httpProvider = HttpProvider();
                            form.save();
                            var guestRedeemAdvDataReturn =
                                await httpProvider.postHttp3(
                                    "advertisement/guest_redeem", _formData);
                            if (guestRedeemAdvDataReturn != null) {
                              Navigator.pop(context);
                              if (guestRedeemAdvDataReturn['status'] ==
                                      "Approve" ||
                                  guestRedeemAdvDataReturn['status'] ==
                                      "Approved") {
                                if (passtype == 1) {
                                  showMerchantPasscode(advertisementId, 0,
                                      guestRedeemAdvDataReturn['guest_id']);
                                } else {
                                  _formData['device_id'] = deviceID;
                                  _formData['action'] = 'claim';
                                  ///////////////////////////////////////////////////
                                  print(_formData);
                                  //////////////////////////////////////////////////
                                  var guestRedeemAdvReturn =
                                      await httpProvider.postHttp3(
                                          'advertisement/device_guest_redeem',
                                          _formData);
                                  print(guestRedeemAdvReturn);
                                  showVoucherPasscode(passcode);
                                }
                              } else if (guestRedeemAdvDataReturn['status'] ==
                                  "Used") {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text('Redeem Vouher'),
                                          content: const Text(
                                              'You already used this voucher!'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'OK'),
                                              child: const Text('OK'),
                                              style: TextButton.styleFrom(
                                                  primary: Colors.black),
                                            ),
                                          ],
                                        ));
                              }
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
              ))
        ],
      );

  showGuestForm(advertisementId, passcode, pass_type) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 6,
            backgroundColor: Colors.transparent,
            child: _DialogWithTextField(
                context, advertisementId, passcode, pass_type),
          );
        });
  }

  showMerchantPasscode(advertisementId, userId, guestId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: 6,
              backgroundColor: Colors.transparent,
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Form(
                    key: _formKey,
                    // autovalidateMode: _autoValidate,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [Text("Merchant Passcode")],
                            ),
                          ),
                          TextFieldWidget(
                            labelText: "Merchant Passcode",
                            keyboardType: TextInputType.number,
                            iconData: Icons.lock_open,
                            setValue: _setInputValue,
                            field: 'passcode',
                            validator: RequiredValidator(
                                errorText: 'Merchant Passcode is required'),
                          ),
                          BlockButtonWidget(
                            onPressed: () async {
                              _formData['advertisement_id'] = advertisementId;
                              _formData['user_id'] = userId;
                              _formData['guest_id'] = guestId;
                              final form = _formKey.currentState;
                              if (form!.validate()) {
                                HttpProvider httpProvider = HttpProvider();
                                form.save();
                                var redeemVoucherDataReturn =
                                    await httpProvider.postHttp3(
                                        "advertisement/verify_passcode",
                                        _formData);
                                if (redeemVoucherDataReturn ==
                                    "Thanks for using this voucher.") {
                                  Navigator.pop(context);
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text('Redeem Voucher'),
                                            content:
                                                Text(redeemVoucherDataReturn),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  if (widget.type != null) {
                                                    Navigator.pop(context);
                                                    Navigator.pushReplacementNamed(
                                                        context,
                                                        '/voucher_details_view_page',
                                                        arguments: {
                                                          'data': widget.data,
                                                          'type': 'Notification'
                                                        });
                                                  } else {
                                                    Navigator.pop(context);
                                                    Navigator.pushReplacementNamed(
                                                        context,
                                                        '/voucher_details_view_page',
                                                        arguments: {
                                                          'data': widget.data,
                                                        });
                                                  }
                                                },
                                                child: const Text('OK'),
                                                style: TextButton.styleFrom(
                                                    primary: Colors.black),
                                              ),
                                            ],
                                          ));
                                } else if (redeemVoucherDataReturn ==
                                    "Your passcode does not matched our records.") {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text('Redeem Voucher'),
                                            content:
                                                Text(redeemVoucherDataReturn),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
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
                              "Redeem Now",
                              style: TextStyle(color: Colors.white),
                            ),
                          ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20)
                        ],
                      ),
                    ),
                  )));
        });
  }

  showVoucherPasscode(passcode) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              contentPadding: const EdgeInsets.all(10.0),
              title: const Text('Voucher Code'),
              content: InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: passcode.toString()))
                      .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Copied to your clipboard !')));
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  height: 85,
                  width: 100,
                  padding: const EdgeInsets.all(10),
                  // margin: const EdgeInsets.only(
                  //     left: 5, right: 5, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Get.theme.focusColor.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5)),
                      ],
                      border: Border.all(
                          color: Get.theme.focusColor.withOpacity(0.05))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Copy Voucher Code",
                        style: Get.textTheme.bodyText1,
                        textAlign: TextAlign.start,
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.copy,
                                size: 25, color: kPrimaryColor),
                          ),
                          SizedBox(
                            //width: MediaQuery.of(context).size.width,
                            child: Text(
                              passcode.toString(),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 1,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  void initState() {
    getUser();
    // Timer(const Duration(milliseconds: 2000), () {
    if (widget.type != null) {
      context.read<AdvBloc>().add(GetAdvDetails(widget.data, widget.data));
    } else {
      context
          .read<AdvBloc>()
          .add(GetAdvDetails(widget.data, widget.data['id']));
    }
    initPlatformState();
    super.initState();
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

  Future<void> showProgressGuestRedeem(
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
      Navigator.pushReplacementNamed(context, '/voucher_details_view_page',
          arguments: {'data': widget.data, 'type': 'Notification'});
    } else {
      Navigator.pushReplacementNamed(context, '/voucher_details_view_page',
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvBloc, AdvState>(
        builder: (BuildContext context, AdvState state) {
      if (state is GetAdvDetailSuccessful) {
        dynamic voucherData = state.advData;
        if (userId != 0) {
          if (voucherData['used_user_id'].contains(userId) == true) {
            used = true;
          } else {
            if (voucherData['redeemed_user_id'].contains(userId) == true) {
              redeemed = true;
            }
          }
          for (var i = 0; i < voucherData['redeemed_user_id'].length; i++) {
            if (voucherData['redeemed_user_id'][i] == userId) {
              redeemCode = voucherData['redeemed_user_passcode'][i].toString();
            }
          }
        }
        return _buildContent(context, voucherData);
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
                      // Navigator.pushReplacement(
                      //   context,
                      //   PageTransition(
                      //       type: PageTransitionType.fade,
                      //       child: AdvPage()),
                      // );

                      //Navigator.pop(context);

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
                    }
                  },
                  icon: const Icon(Icons.keyboard_arrow_left, size: 30),
                ),
                title: const Text(
                  "Voucher Details",
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

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
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

  Widget _buildContent(BuildContext context, voucherData) {
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

                //Navigator.pop(context);
                // Navigator.pushReplacement(
                //   context,
                //   PageTransition(
                //       type: PageTransitionType.fade, child: AdvPage()),
                // );
              }
            },
            icon: const Icon(Icons.keyboard_arrow_left, size: 30),
          ),
          actions: [
            // if (userId != 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              contentPadding: const EdgeInsets.all(10.0),
                              title: const Text('Share Product'),
                              content: InkWell(
                                onTap: () {
                                  if (widget.type != null) {
                                    Clipboard.setData(ClipboardData(
                                      text: api +
                                          "voucher_details?id=${widget.data['id']}",
                                    )).then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                  'Copied to your clipboard !')));
                                    });
                                  } else {
                                    Clipboard.setData(ClipboardData(
                                      text: api +
                                          "voucher_details?id=${widget.data['id']}",
                                    )).then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                  'Copied to your clipboard !')));
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 85,
                                  width: 100,
                                  padding: const EdgeInsets.all(10),
                                  // margin: const EdgeInsets.only(
                                  //     left: 5, right: 5, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Get.theme.focusColor
                                                .withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5)),
                                      ],
                                      border: Border.all(
                                          color: Get.theme.focusColor
                                              .withOpacity(0.05))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "Copy Share Link",
                                        style: Get.textTheme.bodyText1,
                                        textAlign: TextAlign.start,
                                      ),
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(Icons.copy,
                                                size: 25, color: kPrimaryColor),
                                          ),
                                          if (widget.type != null)
                                            SizedBox(
                                              // width: MediaQuery.of(context)
                                              //         .size
                                              //         .width *
                                              //     0.5,
                                              child: Text(
                                                api +
                                                    "voucher_details?id=${widget.data['id']}",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                                maxLines: 1,
                                              ),
                                            )
                                          else
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              child: Text(
                                                api +
                                                    "voucher_details?id=${widget.data['id']}",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black),
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                                maxLines: 1,
                                              ),
                                            ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ));
                  },
                  child: const Icon(Icons.share)),
            ),
          ],
          title: Text(
            voucherData['title'],
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
            child: used == true
                ? Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: MaterialButton(
                          onPressed: () {},
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.grey,
                          child: const Text("Voucher Used",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: kSecondaryColor)),
                        ),
                      ),
                    ],
                  ).paddingSymmetric(vertical: 10, horizontal: 20)
                : redeemed == true
                    ? voucherData['pass_type'] == 1
                        ? Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                      onPressed: () {
                                        showMerchantPasscode(
                                            voucherData['id'], userId, 0);
                                      },
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      color: kPrimaryColor,
                                      child: const Text(
                                        'Redeem Now',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/photo_webview_page',
                                              arguments: {
                                                'url': voucherData['poster'],
                                                'title': voucherData['title']
                                              });

                                          // showMerchantPasscode(
                                          //     voucherData['id'], userId, 0);
                                        },
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        color: kPrimaryColor,
                                        child: const Text(
                                          'View',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ))
                            ],
                          ).paddingSymmetric(vertical: 10, horizontal: 20)
                        : Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                      onPressed: () {
                                        showVoucherPasscode(
                                            voucherData['passcode']);
                                      },
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      color: kPrimaryColor,
                                      child: const Text(
                                        'Show Code',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/photo_webview_page',
                                              arguments: {
                                                'url': voucherData['poster'],
                                                'title': voucherData['title']
                                              });
                                          // showMerchantPasscode(
                                          //     voucherData['id'], userId, 0);
                                        },
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        color: kPrimaryColor,
                                        child: const Text(
                                          'View',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ))
                            ],
                          ).paddingSymmetric(vertical: 10, horizontal: 20)
                    : redeemGuest == true
                        ? Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                      onPressed: () {
                                        showVoucherPasscode(
                                            voucherData['passcode']);
                                      },
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      color: kPrimaryColor,
                                      child: const Text(
                                        'Show Code',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MaterialButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/photo_webview_page',
                                              arguments: {
                                                'url': voucherData['poster'],
                                                'title': voucherData['title']
                                              });

                                          // showMerchantPasscode(
                                          //     voucherData['id'], userId, 0);
                                        },
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        color: kPrimaryColor,
                                        child: const Text(
                                          'View',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ))
                            ],
                          ).paddingSymmetric(vertical: 10, horizontal: 20)
                        : Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: MaterialButton(
                                    onPressed: () async {
                                      if (isLoggedIn == true) {
                                        if (redeemed == false) {
                                          print("logged in");

                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title: const Text(
                                                        'Redeem Voucher'),
                                                    content: const Text(
                                                        'Are you sure want to redeem this voucher.'),
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
                                                                primary: Colors
                                                                    .black),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                              context);
                                                          dynamic formData = {
                                                            'user_id': userId,
                                                            'advertisement_id':
                                                                voucherData[
                                                                    'id']
                                                          };
                                                          if (widget.type !=
                                                              null) {
                                                            context
                                                                .read<AdvBloc>()
                                                                .add(RedeemAdv(
                                                                    formData,
                                                                    widget
                                                                        .data));
                                                          } else {
                                                            context
                                                                .read<AdvBloc>()
                                                                .add(RedeemAdv(
                                                                    formData,
                                                                    widget.data[
                                                                        'id']));
                                                          }

                                                          showProgressJoin(
                                                              context);

                                                          // await ImageDownloader
                                                          //     .downloadImage(
                                                          //         voucherData[
                                                          //             'poster']);
                                                        },
                                                        child: const Text(
                                                            'Redeem'),
                                                        style: TextButton
                                                            .styleFrom(
                                                                primary: Colors
                                                                    .black),
                                                      ),
                                                    ],
                                                  ));
                                        }
                                      } else {
                                        print("no logged in");
                                        showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: const Text(
                                                      'Redeem Voucher'),
                                                  content: const Text(
                                                      'Please select redeem method.'),
                                                  actions: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context,
                                                                  'Member Redeem');
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  '/login_page');
                                                            },
                                                            child: const Text(
                                                              'Member ?',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            style: TextButton
                                                                .styleFrom(
                                                                    primary: Colors
                                                                        .blue),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              // Navigator.pop(context,
                                                              //     'Guest Redeem');
                                                              // _formData['advertisement_id'] = voucherData['id'];
                                                              // _formData['device_id'] = deviceID;
                                                              // _formData['action'] = 'open';
                                                              // HttpProvider httpProvider = HttpProvider();
                                                              // var guestRedeemAdvDataReturn = await httpProvider
                                                              //     .postHttp3("advertisement/device_guest_redeem", _formData);
                                                              // if (guestRedeemAdvDataReturn != null) {
                                                              //   Navigator.pop(context);
                                                              //   if (guestRedeemAdvDataReturn['status'] == "Approved" || guestRedeemAdvDataReturn['status'] == "Approve") {
                                                              //
                                                              //   } else if (guestRedeemAdvDataReturn['status'] ==
                                                              //       "Redeemed") {
                                                              //     showVoucherPasscode(voucherData['passcode']);
                                                              //   }
                                                              // }
                                                              showGuestForm(
                                                                  voucherData[
                                                                      'id'],
                                                                  voucherData[
                                                                      'passcode'],
                                                                  voucherData[
                                                                      'pass_type']);

                                                              print(
                                                                voucherData[
                                                                    'id'],
                                                              );
                                                            },
                                                            child: const Text(
                                                              'Guest ?',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
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
                                      }
                                    },
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: voucherData['left'] == 'unlimited'
                                        ? kPrimaryColor
                                        : voucherData['left'] > 0
                                            ? kPrimaryColor
                                            : Colors.grey,
                                    child: redeemed == true
                                        ? const Text("Download",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: kSecondaryColor))
                                        : voucherData['left'] == 'unlimited'
                                            ? const Text("Redeem",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: kSecondaryColor))
                                            : voucherData['left'] > 0
                                                ? const Text("Redeem",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: kSecondaryColor))
                                                : const Text(
                                                    "Not More To Redeem",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color:
                                                            kSecondaryColor))),
                              ),
                            ],
                          ).paddingSymmetric(vertical: 10, horizontal: 20)),
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
              // bottom: entrepreneurTitleBarWidget(voucherData['name']),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    (voucherData['poster'] != null &&
                            voucherData['poster'] != "")
                        ? CachedNetworkImage(
                            height: 400,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            imageUrl: voucherData['poster'],
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
                            imageUrl: voucherData['poster'],
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
                  voucherData['caption'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Caption",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            voucherData['caption'],
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),
                  voucherData['company_name'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Company Name",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            voucherData['company_name'],
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),
                  voucherData['contact_person'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Contact Person",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            voucherData['contact_person'],
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),
                  voucherData['email'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Email",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            voucherData['email'],
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),
                  voucherData['phone_number'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Phone Number",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            voucherData['phone_number'],
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),
                  voucherData['terms_condition'] != null
                      //  ? Text("tes")
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Terms & Condition",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          // content: Text(
                          //   voucherData['terms_condition'],
                          //   textAlign: TextAlign.left,
                          //   // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          // )
                          content: Html(
                            data: voucherData['terms_condition'],
                            // onLinkTap: (url, _, __, ___) {
                            //   launch(url!);
                            // },
                          ),
                        )
                      : Container(),
                  voucherData['left'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Quantity Left",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            voucherData['left'].toString(),
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
