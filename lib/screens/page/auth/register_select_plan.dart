// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:get/get.dart';
// import 'package:get/get_utils/src/extensions/widget_extensions.dart';
// import 'package:html/parser.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:mlcc/Bloc/auth/auth_bloc.dart';
// import 'package:mlcc/constant.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:mlcc/main.dart';
// import 'package:mlcc/provider/http_provider.dart';
// import 'package:mlcc/screens/page/auth/login_page.dart';
// import 'package:mlcc/widget/loading_widget.dart';

// import '../../../widget/block_button_widget.dart';

// class RegisterSelectPlanPage extends StatefulWidget {
   //final List data;
//   final Map arguments;
  
//   const RegisterSelectPlanPage(
//       {Key? key, required this.data, required this.arguments})
//       : super(key: key);

//   @override
//   _RegisterSelectPlanPageState createState() => _RegisterSelectPlanPageState();
// }

// class _RegisterSelectPlanPageState extends State<RegisterSelectPlanPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   var _current = 0;

//   // Future<void> getPlan() async {
//   //   widget.data = await httpProvider.getHttp("member_package");
//   // }

//   @override
//   void initState() {
//     super.initState();
//     print('Plan : ${widget.data[_current]['plan']}');
//     print(widget.arguments);
//     // getPlan();
//   }
//   // var widget.data = [
//   //   {
//   //     'description':
//   //         "- Profile in x club app \n- 100 Adv in x club app \n- 24 courses/year by Simon \n- 121 consultation (choose 1) \n1) Brand and marketing analysis \n2) company name and logo Numerology analysis \n3) Company valuation Calculation \n- X Club Newsletter (App)",
//   //     "memberFee": "RM 2400 / year",
//   //     "id": "Gold Member"
//   //   },
//   //   {'description': "Coming Soon", "memberFee": "", "id": ""},
//   //   {'description': "Coming Soon", "memberFee": "", "id": ""}
//   // ];

//   final Map<String, dynamic> _formData = {
//     'package_id': null,
//   };

//   void _showMaterialDialog() {
//     showDialog(
//         context: context,F
//         builder: (context) {
//           return AlertDialog(
//             title: const Text('Please select plan'),
//             content: const Text('This plan is coming soon'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text('OK'),
//               )
//             ],
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Register",
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: kPrimaryColor,
//         elevation: 0,
//       ),
//       body: ListView(
//         primary: true,
//         children: [
//           Stack(alignment: AlignmentDirectional.bottomCenter, children: [
//             Container(
//               height: 160,
//               width: MediaQuery.of(context).size.width,
//               decoration: const BoxDecoration(
//                 color: kPrimaryColor,
//                 borderRadius:
//                     BorderRadius.vertical(bottom: Radius.circular(10)),
//                 boxShadow: [
//                   BoxShadow(
//                       color: kThirdColor, blurRadius: 10, offset: Offset(0, 5)),
//                 ],
//               ),
//               margin: const EdgeInsets.only(bottom: 50),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: const [
//                     Text(
//                       "Malaysia Lin Chamber of Commerce",
//                       style: TextStyle(color: Colors.white, fontSize: 21),
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       "Personal Basic Info",
//                       style: TextStyle(color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                     // Text("Fill the following credentials to login your account",
//                     //     style: TextStyle(color: Colors.white)),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 color: kPrimaryColor,
//                 borderRadius: const BorderRadius.all(Radius.circular(14)),
//                 boxShadow: const [
//                   BoxShadow(
//                       color: kThirdColor, blurRadius: 10, offset: Offset(0, 5)),
//                 ],
//                 border: Border.all(color: kThirdColor),
//                 // gradient: gradient,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.all(Radius.circular(10)),
//                   child: Image.asset(
//                     'assets/mlcc_logo.png',
//                     fit: BoxFit.contain,
//                     width: 100,
//                     height: 100,
//                   ),
//                 ),
//               ),
//             ),
//           ]),
//           Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SingleChildScrollView(
//                   padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: AutoSizeText('👇  Current selected plan  👇',
//                             maxLines: 1,
//                             style: Theme.of(context).textTheme.headline6),
//                       ),
//                       CarouselSlider(
//                           options: CarouselOptions(
//                               initialPage: 0,
//                               onPageChanged: (index, reason) {
//                                 setState(() => _current = index);
//                                 print(_current);
//                                 print(widget.data[_current]['plan']);
//                               },
//                               autoPlay: false,
//                               enlargeCenterPage: true,
//                               aspectRatio: 9 / 12,
//                               height: MediaQuery.of(context).size.height * 0.5),
//                           items: widget.data
//                               .map((item) => planCard(context, item))
//                               .toList()),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: widget.data.asMap().entries.map((entry) {
//                           return GestureDetector(
//                             // onTap: () => _controller
//                             //     .animateToPage(entry.key),
//                             child: Container(
//                               width: 12.0,
//                               height: 12.0,
//                               margin: const EdgeInsets.symmetric(
//                                   vertical: 8.0, horizontal: 4.0),
//                               decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: kThirdColor.withOpacity(
//                                       _current == entry.key ? 0.9 : 0.4)),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   ),
//                 ),
//                 BlocListener<AuthBloc, AuthState>(
//                     listener: (BuildContext context, AuthState state) async {
//                   if (state is RegisterSuccessful) {
//                     Navigator.pushNamed(context, '/register_successful_page');
//                   } else if (state is ErrorOccured) {
//                     showDialog<String>(
//                         context: context,
//                         builder: (BuildContext context) => AlertDialog(
//                               title: const Text('Register error'),
//                               content: const Text(
//                                   'Error occured! Please try again!'),
//                               actions: <Widget>[
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(context, 'OK'),
//                                   child: const Text('OK'),
//                                   style: TextButton.styleFrom(
//                                       primary: Colors.black),
//                                 ),
//                               ],
//                             ));
//                   }
//                 }, child: BlocBuilder<AuthBloc, AuthState>(
//                         builder: (BuildContext context, AuthState state) {
//                   if (state is AuthLoading) {
//                     return const LoadingWidget();
//                   } else {
//                     return BlockButtonWidget(
//                       onPressed: () async {
//                         final form = _formKey.currentState;
//                         // final Map arguments =
//                         //     ModalRoute.of(context)!.settings.arguments as Map;
//                        // _formData['package_id'] = widget.data[_current]['id'];
//                         widget.arguments.addAll(_formData);
//                         print(widget.arguments);
//                         //if (widget.data[_current]['plan'] == 'Coming Soon') {
//                           //_showMaterialDialog();
//                         //} else {
//                           if (form!.validate()) {
//                             form.save();
//                             context
//                                 .read<AuthBloc>()
//                                 .add(Register(widget.arguments));
//                           }
//                         },
                      
//                       color: kPrimaryColor,
//                       text: const Text(
//                         "Register",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20);
//                   }
//                 })),
//                 // BlockButtonWidget(
//                 //   onPressed: () async {
//                 //     // Navigator.pushNamed(context, '/register_successful_page');
//                 //     if (_current == 0) {
//                 //       final form = _formKey.currentState;
//                 //       final Map arguments =
//                 //           ModalRoute.of(context)!.settings.arguments as Map;
//                 //       _formData['package'] = widget.data[_current]['id'];
//                 //       arguments.addAll(_formData);

//                 //       if (form!.validate()) {
//                 //         form.save();
//                 //         HttpProvider httpProvider = HttpProvider();
//                 //         var registerDataReturn =
//                 //             await httpProvider.postHttp("register", arguments);

//                 //         if (registerDataReturn == "Registration success") {
//                 //           Navigator.pushNamed(
//                 //               context, '/register_successful_page');
//                 //         } else {
//                 //           showDialog<String>(
//                 //               context: context,
//                 //               builder: (BuildContext context) => AlertDialog(
//                 //                     title: const Text('Register error'),
//                 //                     content: const Text(
//                 //                         'Error occured! Please try again!'),
//                 //                     actions: <Widget>[
//                 //                       TextButton(
//                 //                         onPressed: () =>
//                 //                             Navigator.pop(context, 'OK'),
//                 //                         child: const Text('OK'),
//                 //                         style: TextButton.styleFrom(
//                 //                             primary: Colors.black),
//                 //                       ),
//                 //                     ],
//                 //                   ));
//                 //         }
//                 //       }
//                 //     } else {
//                 //       showDialog<String>(
//                 //           context: context,
//                 //           builder: (BuildContext context) => AlertDialog(
//                 //                 title: const Text('Plan Selection'),
//                 //                 content: const Text(
//                 //                     'Please select an available plan'),
//                 //                 actions: <Widget>[
//                 //                   TextButton(
//                 //                     onPressed: () =>
//                 //                         Navigator.pop(context, 'OK'),
//                 //                     child: const Text('OK'),
//                 //                     style: TextButton.styleFrom(
//                 //                         primary: Colors.black),
//                 //                   ),
//                 //                 ],
//                 //               ));
//                 //     }
//                 //   },
//                 //   color: kPrimaryColor,
//                 //   text: const Text(
//                 //     "Register",
//                 //     style: TextStyle(color: Colors.white),
//                 //   ),
//                 // ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         // Navigator.popUntil(
//                         //     context, ModalRoute.withName('/login_page'));
//                         Navigator.pushReplacement(
//                           context,
//                           PageTransition(
//                               type: PageTransitionType.fade,
//                               child: const LoginPage()),
//                         );
//                       },
//                       child: const Text("You already have an account?",
//                           style: TextStyle(color: kPrimaryColor)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   String _parseHtmlString(String htmlString) {
//     final document = parse(htmlString);
//     final String parsedString =
//         parse(document.body!.text).documentElement!.text;

//     return parsedString;
//   }

//   ClipRRect planCard(BuildContext context, item) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(8.0),
//       child: GestureDetector(
//         child: SingleChildScrollView(
//           child: Container(
//             color: Colors.amber[200],
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             child: Column(
//               children: [
//                 Container(
//                   height: 60,
//                   width: MediaQuery.of(context).size.width,
//                   color: kPrimaryColor,
//                   padding: const EdgeInsets.all(8.0),
//                   child: Center(
//                       child: FittedBox(
//                     child: Text(item['plan'],
//                         style: const TextStyle(color: Colors.white)),
//                   )),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(18.0),
//                   child: Column(
//                     children: [
//                       Text(item['price']),
//                       // const SizedBox(height: 15.0),
//                       // Text('${item['storage'] / 1000} GB Storage'),
//                       const SizedBox(height: 15.0),
//                       Text(_parseHtmlString(item['desc']))
//                       // Html(
//                       //   data: item['desc'],
//                       //   onLinkTap: (url, _, __, ___) {
//                       //     launch(url!);
//                       //   },
//                       // ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             // child: Text(item['name']),
//           ),
//         ),
//       ),
//     );
//   }
// }
