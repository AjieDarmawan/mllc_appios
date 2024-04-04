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

class ProductDetailsViewPage extends StatefulWidget {
  final dynamic data;
  final String? type;
  const ProductDetailsViewPage({Key? key, this.data, this.type})
      : super(key: key);

  @override
  _ProductDetailsViewPageState createState() => _ProductDetailsViewPageState();
}

class _ProductDetailsViewPageState extends State<ProductDetailsViewPage> {
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Future<void> clearSecureScreen() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  bool isLoggedIn = false;
  int userId = 0;
  bool redeemed = false;
  bool used = false;
  bool verified = false;
  bool _isExpanded = false;
  var imageId;
  final formatter = intl.NumberFormat.currency(locale: "en_US", symbol: "RM");
  final Map<String, dynamic> _formData = {
    'advertisement_id': null,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  var redeemCode = "";
  String member_number = '';
  String userInfo = '';
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() async {
      isLoggedIn = prefs.getBool("isLoggedIn")!;
      userId = prefs.getInt("userId")!;
      member_number = prefs.getString("memberNo")!;
      final _formData = {};
      _formData['member_number'] = member_number;
      userInfo = await httpProvider.postHttp("encryption", _formData);
    });
  }

  Widget _DialogWithTextField(BuildContext context, advertisementId) =>
      Container(
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
                      _formData['advertisement_id'] = advertisementId;
                      final form = _formKey2.currentState;
                      if (form!.validate()) {
                        HttpProvider httpProvider = HttpProvider();
                        form.save();
                        var guestRedeemAdvDataReturn = await httpProvider
                            .postHttp3("advertisement/guest_redeem", _formData);
                        if (guestRedeemAdvDataReturn != null) {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: PaymentWebViewPage(
                                  userId: userId,
                                  training: 0,
                                  event: 0,
                                  productData: widget.data,
                                  productID: widget.data['id']),
                            ),
                          );
                        }
                      }
                    },
                    color: kPrimaryColor,
                    text: const Text(
                      "Order Now",
                      style: TextStyle(color: Colors.white),
                    ),
                  ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20)
                ],
              ),
            ),
          ));

  showGuestForm(advertisementId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: 6,
            backgroundColor: Colors.transparent,
            child: _DialogWithTextField(context, advertisementId),
          );
        });
  }

  @override
  void initState() {
    // secureScreen();
    // DisableScreenshots.disable();
    getUser();
    // Timer(const Duration(milliseconds: 2000), () {
    if (widget.type != null) {
      context.read<AdvBloc>().add(GetProductDetails(widget.data, widget.data));
    } else {
      context
          .read<AdvBloc>()
          .add(GetProductDetails(widget.data, widget.data['id']));
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

  Future<void> showProgressGuestRedeem(
    BuildContext context,
  ) async {
    var result = await showDialog(
      context: context,
      builder: (context) =>
          FutureProgressDialog(getFuture(), message: const Text('Ordering...')),
    );
    showResultDialog(context, result);
    // return result;
  }

  void showResultDialog(
    BuildContext context,
    String result,
  ) {
    if (widget.type != null) {
      Navigator.pushReplacementNamed(context, '/product_details_view_page',
          arguments: {'data': widget.data, 'type': 'Notification'});
    } else {
      Navigator.pushReplacementNamed(context, '/product_details_view_page',
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
      if (state is GetProductDetailSuccessful) {
        dynamic productsData = state.advData;
        // if (userId != 0) {
        //   if (productData['used_user_id'].contains(userId) == true) {
        //     used = true;
        //   } else {
        //     if (productData['redeemed_user_id'].contains(userId) == true) {
        //       redeemed = true;
        //     }
        //   }
        //   for (var i = 0; i < productData['redeemed_user_id'].length; i++) {
        //     if (productData['redeemed_user_id'][i] == userId) {
        //       redeemCode = productData['redeemed_user_passcode'][i].toString();
        //     }
        //   }
        // }
        return _buildContent(context, productsData);
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
                            type: PageTransitionType.fade, child: XBuyPage()),
                      );
                    }
                  },
                  icon: const Icon(Icons.keyboard_arrow_left, size: 30),
                ),
                title: const Text(
                  "Product Details",
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
        PageTransition(type: PageTransitionType.fade, child: XBuyPage()),
      );
    }
  }

  Widget _buildContent(BuildContext context, productData) {
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
                      type: PageTransitionType.fade, child: XBuyPage()),
                );
              }
            },
            icon: const Icon(Icons.keyboard_arrow_left, size: 30),
          ),
          title: Text(
            productData['title'],
            style: const TextStyle(
              color: kSecondaryColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
          actions: [
            if (userId != 0)
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
                                            "product_details?id=${widget.data}&member=" +
                                            userInfo +
                                            "",
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
                                            "product_details?id=${widget.data['id']}&member=" +
                                            userInfo +
                                            "",
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
                                        borderRadius:
                                            const BorderRadius.vertical(
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
                                                  size: 25,
                                                  color: kPrimaryColor),
                                            ),
                                            if (widget.type != null)
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5,
                                                child: Text(
                                                  api +
                                                      "product_details?id=${widget.data}&member=" +
                                                      userInfo +
                                                      "",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                      "product_details?id=${widget.data['id']}&member=" +
                                                      userInfo +
                                                      "",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                    onPressed: () async {
                      if (isLoggedIn == true) {
                        if (redeemed == false) {
                          print("logged in");
                          if (productData['left'] > 0) {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Product Order'),
                                      content: const Text(
                                          'Are you sure want to order this product ?'),
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
                                            Navigator.pop(context);
                                            if (widget.type != null) {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: PaymentWebViewPage(
                                                      userId: userId,
                                                      training: 0,
                                                      event: 0,
                                                      productData: productData,
                                                      productID: widget.data),
                                                ),
                                              );
                                            } else {
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: PaymentWebViewPage(
                                                      userId: userId,
                                                      training: 0,
                                                      event: 0,
                                                      productData: productData,
                                                      productID:
                                                          widget.data['id']),
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text('Order Now'),
                                          style: TextButton.styleFrom(
                                              primary: Colors.blue),
                                        ),
                                      ],
                                    ));
                          }
                        }
                      } else {
                        print("no logged in");
                        if (productData['left'] > 0) {
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Product Order'),
                                    content: const Text(
                                        'Please select order method.'),
                                    actions: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context, 'Member Redeem');
                                                Navigator.pushNamed(
                                                    context, '/login_page');
                                              },
                                              child: const Text(
                                                'Member ?',
                                                textAlign: TextAlign.center,
                                              ),
                                              style: TextButton.styleFrom(
                                                  primary: Colors.blue),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context, 'Guest Redeem');
                                                // showGuestForm(
                                                //     productData['id']);
                                                Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    child: PaymentWebViewPage(
                                                        userId: userId,
                                                        training: 0,
                                                        event: 0,
                                                        productData:
                                                            widget.data,
                                                        productID:
                                                            widget.data['id']),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'Guest ?',
                                                textAlign: TextAlign.center,
                                              ),
                                              style: TextButton.styleFrom(
                                                  primary: Colors.grey),
                                            ),
                                          ],
                                        ),
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
                    color: productData['left'] == 'unlimited'
                        ? kPrimaryColor
                        : productData['left'] > 0
                            ? kPrimaryColor
                            : Colors.grey,
                    child: redeemed == true
                        ? const Text("Download",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kSecondaryColor))
                        : productData['left'] == 'unlimited'
                            ? productData['discounted_price'] != 0
                                ? Text(
                                    "Buy Now (" +
                                        formatter.format(
                                            productData['discounted_price']) +
                                        ")",
                                    textAlign: TextAlign.center,
                                    style:
                                        const TextStyle(color: kSecondaryColor))
                                : Text(
                                    "Buy Now (" +
                                        formatter.format(
                                            productData['selling_price']) +
                                        ")",
                                    textAlign: TextAlign.center,
                                    style:
                                        const TextStyle(color: kSecondaryColor))
                            : productData['left'] > 0
                                ? productData['discounted_price'] != 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              "Buy Now (" +
                                                  formatter.format(productData[
                                                      'discounted_price']) +
                                                  ")",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: kSecondaryColor)),
                                        ],
                                      )
                                    : Text(
                                        "Buy Now (" +
                                            formatter.format(
                                                productData['selling_price']) +
                                            ")",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: kSecondaryColor))
                                : const Text("Sold Out",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: kSecondaryColor)),
                  ),
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
              // bottom: entrepreneurTitleBarWidget(productData['name']),
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    (productData['poster'] != null &&
                            productData['poster'] != "")
                        ? CachedNetworkImage(
                            height: 400,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            imageUrl: productData['poster'],
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
                            imageUrl: productData['poster'],
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
                  productData['desc'] != null
                      // ? Text("tes")
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Desciption",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          // content: Text(
                          //   productData['terms_condition'],
                          //   textAlign: TextAlign.left,
                          //   // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          // )
                          content: Html(
                            data: productData['desc'],
                            onLinkTap: (url, _, __, ___) {
                              launch(url!);
                            },
                          ),
                        )
                      : Container(),
                  productData['caption'] != null
                      // ? Text("tes")
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Caption",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            productData['caption'],
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),
                  productData['brand_name'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Brand Name",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            productData['brand_name'],
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),
                  productData['selling_price'] != 0
                      ? productData['discounted_price'] != 0
                          ? TilWidget(
                              actions: const [],
                              title: const Text("Price",
                                  style: TextStyle(
                                      fontSize: 16, color: kPrimaryColor)),
                              content: Row(
                                children: [
                                  StrikeThroughWidget(
                                      child: Text(
                                    "" +
                                        formatter.format(
                                            productData['selling_price']) +
                                        "",
                                    textAlign: TextAlign.left,
                                  )
                                      // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                                      ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "" +
                                            formatter.format(productData[
                                                'discounted_price']) +
                                            "",
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.red)),
                                  )
                                ],
                              ))
                          : TilWidget(
                              actions: const [],
                              title: const Text("Price",
                                  style: TextStyle(
                                      fontSize: 16, color: kPrimaryColor)),
                              content: Text(
                                "" +
                                    formatter
                                        .format(productData['selling_price']) +
                                    "",
                                textAlign: TextAlign.left,
                                // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                              ))
                      : Container(),
                  productData['delivery_cost'] != 0
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Delivery Cost",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            "" +
                                formatter.format(productData['delivery_cost']) +
                                "",
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),
                  productData['email'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Email",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            productData['email'],
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),
                  productData['phone_number'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Phone Number",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            productData['phone_number'],
                            textAlign: TextAlign.left,
                            // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          ))
                      : Container(),
                  productData['terms_condition'] != null
                      //  ? Text("tes")
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Terms & Condition",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          // content: Text(
                          //   productData['terms_condition'],
                          //   textAlign: TextAlign.left,
                          //   // style: TextStyle(fontSize: 16, color: kPrimaryColor),
                          // )
                          content: Html(
                            data: productData['terms_condition'],
                            onLinkTap: (url, _, __, ___) {
                              //launch(url!);
                            },
                          ),
                        )
                      : Container(),
                  productData['left'] != null
                      ? TilWidget(
                          actions: const [],
                          title: const Text("Quantity Left",
                              style: TextStyle(
                                  fontSize: 16, color: kPrimaryColor)),
                          content: Text(
                            productData['left'].toString(),
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

class StrikeThroughWidget extends StatelessWidget {
  final Widget _child;

  const StrikeThroughWidget({Key? key, required Widget child})
      : this._child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _child,
      padding: const EdgeInsets.symmetric(
          horizontal:
              8), // this line is optional to make strikethrough effect outside a text
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/strike.png'), fit: BoxFit.contain),
      ),
    );
  }
}
