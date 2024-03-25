import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlcc_app_ios/Bloc/timer/timer_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/page/auth/login_page.dart';
import 'package:mlcc_app_ios/screens/page/home/popup_detail.dart';
import 'package:mlcc_app_ios/Bloc/timer/timer_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class CustomDialogBox extends StatefulWidget {
  final String? title,
      descriptions,
      text,
      caption,
      sub_title,
      sub_background_color,
      background_color,
      color_title,
      color_subtitle,
      color_caption,
      gradient_background_color,
      type;
  final int? no, total_no, total_no_;

  bool? slider, slide_close;
  final String? img;

  var tel_number = [];
  var email_address = [];
  var url_link = [];

  CustomDialogBox(
      {Key? key,
      this.title,
      this.sub_title,
      this.sub_background_color,
      this.background_color,
      this.descriptions,
      this.text,
      this.img,
      required this.tel_number,
      required this.url_link,
      required this.email_address,
      this.slider,
      this.total_no_,
      this.slide_close,
      this.caption,
      this.gradient_background_color,
      this.color_title,
      this.color_subtitle,
      this.color_caption,
      this.no,
      this.total_no,
      this.type})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  final CountdownController _controller =
      new CountdownController(autoStart: true);

  final _maxSeconds = 5;
  int _currentSecond = 0;
  Timer? _timer;

  var slide = false;

  int slide_new = 0;

  String get _timerText {
    final secondsPerMinute = 60;
    final secondsLeft = _maxSeconds - _currentSecond;

    final formattedMinutesLeft =
        (secondsLeft ~/ secondsPerMinute).toString().padLeft(2, '0');
    final formattedSecondsLeft =
        (secondsLeft % secondsPerMinute).toString().padLeft(1, '0');

    print('$formattedMinutesLeft : $formattedSecondsLeft');
    // return '$formattedMinutesLeft : $formattedSecondsLeft';
    return '$formattedSecondsLeft';
  }

  void _startTimer() {
    final duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        // slide_new += 1;
        _currentSecond = timer.tick;
        if (timer.tick >= _maxSeconds) timer.cancel();
      });
    });
  }

  void _click(timer) {
    print("timer-${timer}");
    // if (timer.toString() == '0') {
    print("timer-masuk}");
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: Popup_detail(
          title: widget.title,
          descriptions: widget.descriptions,
          img: widget.img,
          caption: widget.caption,
          type: widget.type,
          url_link: widget.url_link,
          tel_number: widget.tel_number,
          email_address: widget.email_address,
        ),
      ),
    );
    // }
  }

  // void cek() {
  //   setState(() {
  //     if (widget.no == widget.total_no_) {
  //       slide = true;
  //     } else {
  //       slide = false;
  //     }
  //   });

  //   print("slide_new${widget.no}");
  //   print("testesslider${widget.slider}");
  //   print("slide${slide}");
  //   print("slide-------------");
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _startTimer();
  //   print("slide_new${slide}");
  //   //cek();

  //   // print("slide-no${widget.no.toString()}");

  //   // print("testes${widget.no.toString()}");
  //   // if (widget.title?.isEmpty ?? true) {
  //   //   print("testes-${_timerText.toString()}");
  //   //   _startTimer();
  //   // }
  // }

  // @override
  // void dispose() {
  //   //_timer?.cancel();
  //   //_startTimer();
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  void initState() {
    // context.read<TimerBloc>().add(TimerStarted(5));
    super.initState();
    // _startTimer();

    if (widget.total_no_ != 0) {
      _controller.pause();
      print("slide_new TETES");
      //widget.slider = true;
      //  widget.slide_close = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("slide_new${widget.total_no_}");
    print("slide_new-------${widget.total_no}");
    // print("slide_new-no${widget.no}");
    print("slide_new-no${widget.slider}");

    return WillPopScope(
      onWillPop: () async => false,

      //  if (widget.slider == true)

      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0.0),
        child:
            contentBox(context, context.select((TimerBloc bloc) => bloc.state)),
        // child: Text('${context.select((TimerBloc bloc) => bloc.state)}',
        //     textAlign: TextAlign.center,
        //     style: const TextStyle(
        //         color: Colors.white,
        //         fontSize: 22,
        //         fontWeight: FontWeight.w600)),
      ),
    );
    //   return BlocBuilder<TimerBloc, TimerState>(
    //     builder: (context, state) {
    //       return Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           // if (state is TimerInitial) ...[
    //           //   FloatingActionButton(
    //           //       child: contentBox(context),

    //           //       /// changes from current state to TimerStarted state
    //           //       onPressed: () => context
    //           //           .read<TimerBloc>()
    //           //           .add(TimerStarted(state.duration))),
    //           // ] else if (state is TimerRunInProgress) ...[
    //           //   FloatingActionButton(
    //           //       child: const Icon(Icons.pause),

    //           //       /// changes from current state to TimerPaused state
    //           //       onPressed: () =>
    //           //           context.read<TimerBloc>().add(const TimerPaused())),
    //           //   FloatingActionButton(
    //           //       child: const Icon(Icons.refresh),

    //           //       /// changes from current state to TimerReset state
    //           //       onPressed: () => context.read<TimerBloc>().add(TimerReset())),
    //           // ] else if (state is TimerRunPause) ...[
    //           //   FloatingActionButton(
    //           //       child: const Icon(Icons.play_arrow),

    //           //       /// changes from current state to TimerRunPause state
    //           //       onPressed: () => context
    //           //           .read<TimerBloc>()
    //           //           .add(TimerResumed(state.duration))),
    //           //   FloatingActionButton(
    //           //       child: const Icon(Icons.refresh),
    //           //       onPressed: () => context.read<TimerBloc>().add(TimerReset())),
    //           // ] else if (state is TimerRunComplete) ...[
    //           //   /// changes from current state to TimerReset state
    //           //   FloatingActionButton(
    //           //       child: const Icon(Icons.refresh),
    //           //       onPressed: () => context.read<TimerBloc>().add(TimerReset()))
    //           // ],

    //           Text('${context.select((TimerBloc bloc) => bloc.state)}',
    //               textAlign: TextAlign.center,
    //               style: const TextStyle(
    //                   color: Colors.white,
    //                   fontSize: 22,
    //                   fontWeight: FontWeight.w600)),
    //           //contentBox(context),
    //         ],
    //       );
    //     },
    //   );
  }

  contentBox(context, timer_state) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: const EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.black.withOpacity(0.0),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // if (widget.slider == false)
              //   Countdown(
              //     seconds: 5,
              //     build: (BuildContext context, double time) =>
              //         Text(time.toString().replaceAll('.0', ''),
              //             style: TextStyle(
              //               fontSize: 20,
              //               color: Colors.white,
              //             )),
              //     interval: Duration(seconds: 1),
              //     onFinished: () {
              //       setState(() {
              //         widget.slider = true;
              //         print("slide timer-masuk}");
              //         print("slide timer-masukslide${slide}}");
              //       });
              //     },
              //   ),
              // Text(widget.no.toString()),
              // if (widget.slider == false)
              //   if (_timerText.toString() != '0')

              // Text(_textSelect(timer_state.toString()),
              //     textAlign: TextAlign.center,
              //     style: const TextStyle(
              //         color: Colors.white,
              //         fontSize: 22,
              //         fontWeight: FontWeight.w600)),
              // Center(
              //   child: Text(
              //     _timerText,
              //     textAlign: TextAlign.center,
              //     style: const TextStyle(
              //         color: Colors.white,
              //         fontSize: 22,
              //         fontWeight: FontWeight.w600),
              //   ),
              // ),

              // Text(timer_state.toString()),

              Container(
                child: CachedNetworkImage(
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  imageUrl: widget.img.toString(),
                ),

                //Image.network(widget.img.toString()),
                // height: MediaQuery.of(context).size.height * 0.5,
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),

        //     )),
        // if (widget.total_no == 1)
        //   Positioned(
        //       top: 40,
        //       right: 0,
        //       child: InkWell(
        //         onTap: () {
        //           if (_textSelect(timer_state.toString()) == 'TimerRunComplete')
        //             close();
        //         },
        //         child: _textSelect(timer_state.toString()) != 'TimerRunComplete'
        //             ? Container(
        //                 height: 40,
        //                 // margin: EdgeInsets.all(5),
        //                 padding: EdgeInsets.all(10),
        //                 decoration: BoxDecoration(
        //                     color: Colors.grey,
        //                     border: Border.all(
        //                       color: Colors.grey,
        //                     ),
        //                     borderRadius:
        //                         const BorderRadius.all(Radius.circular(20))),

        //                 child: Row(children: [
        //                   // Pause
        //                   // ElevatedButton(
        //                   //   child: Text('Pause'),
        //                   //   onPressed: () {
        //                   //     _controller.pause();
        //                   //   },
        //                   // ),
        //                   // // Resume
        //                   // ElevatedButton(
        //                   //   child: Text('Resume'),
        //                   //   onPressed: () {
        //                   //     _controller.resume();
        //                   //   },
        //                   // ),
        //                   // Stop

        //                   Container(
        //                     height: 20,
        //                     child: Row(
        //                       children: [
        //                         // Countdown(
        //                         //   controller: _controller,
        //                         //   seconds: 5,
        //                         //   build: (BuildContext context, double time) => Text(
        //                         //       "${time.toString().replaceAll('.0', '')} Second Remaining",

        //                         //       style: TextStyle(
        //                         //         fontSize: 10,
        //                         //         color: Colors.white,
        //                         //       )),
        //                         //   interval: Duration(seconds: 1),
        //                         //   onFinished: () {
        //                         //     setState(() {
        //                         //       widget.slider = true;
        //                         //       //widget.slide_close = true;
        //                         //       print("slide timer-masuk}");
        //                         //       print(
        //                         //           "slide timer-masukslide${widget.slider}}");

        //                         //     });
        //                         //   },
        //                         // ),
        //                         Container(
        //                           padding: EdgeInsets.only(
        //                               top: 0, left: 0, right: 0, bottom: 70),
        //                           decoration: new BoxDecoration(
        //                             color: Colors.grey[300],
        //                             shape: BoxShape.circle,
        //                           ),
        //                           child: IconButton(
        //                             iconSize: 16.0,
        //                             padding: EdgeInsets.only(
        //                                 top: 0, left: 0, right: 0, bottom: 0),
        //                             icon: Icon(Icons.close, color: Colors.grey),
        //                             onPressed: () {
        //                               close();
        //                               // if (_textSelect(timer_state.toString()) ==
        //                               //     'TimerRunComplete') close();
        //                             },
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ]),
        //               )
        //             : Container(
        //                 height: 20,
        //                 child: Row(
        //                   children: [
        //                     Container(
        //                       padding: EdgeInsets.only(
        //                           top: 0, left: 0, right: 0, bottom: 70),
        //                       decoration: new BoxDecoration(
        //                         color: Colors.grey[300],
        //                         shape: BoxShape.circle,
        //                       ),
        //                       child: IconButton(
        //                         iconSize: 16.0,
        //                         padding: EdgeInsets.only(
        //                             top: 0, left: 0, right: 0, bottom: 0),
        //                         icon: Icon(Icons.close, color: Colors.grey),
        //                         onPressed: () {
        //                           close();
        //                         },
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //       )),

        // if (widget.total_no == 2)
        //   if (widget.total_no_ != 0)
        Positioned(
            top: 40,
            right: 0,
            child: InkWell(
              onTap: () {
                print("testes_loading-finish");
                close();
              },
              child: Container(
                height: 20,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: 0, left: 0, right: 0, bottom: 70),
                      decoration: new BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        iconSize: 16.0,
                        padding: EdgeInsets.only(
                            top: 0, left: 0, right: 0, bottom: 0),
                        icon: Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          close();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  void close() {
    Navigator.pop(context);
    //   showDialog<String>(
    //       context: context,
    //       builder: (BuildContext context) => AlertDialog(
    //             title: const Text('Close Ad ?'),
    //             content: Text('Are you Sure?\nYou will miss out the opportunity',
    //                 style: TextStyle(
    //                     color: Colors.grey,
    //                     fontSize: 16,
    //                     fontWeight: FontWeight.w400)),
    //             actions: <Widget>[
    //               TextButton(
    //                 onPressed: () {
    //                   Navigator.pop(context);
    //                   Navigator.pop(context);
    //                 },
    //                 child: const Text('Close Ad'),
    //               ),
    //               TextButton(
    //                 style: ButtonStyle(
    //                     backgroundColor:
    //                         MaterialStateProperty.all(Colors.blueAccent)),
    //                 onPressed: () => Navigator.pop(context),
    //                 child: const Text('Resume Ad',
    //                     style: TextStyle(color: Colors.white)),
    //               ),
    //             ],
    //           ));
  }
}

class Constants {
  Constants._();
  static const double padding = 10;
  static const double avatarRadius = 40;
}

String _textSelect(String str) {
  // str = str.replaceAll('TimerRunComplete', '');
  str = str.replaceAll('(', '');
  str = str.replaceAll(')', '');
  str = str.replaceAll('0', '');
  str = str.replaceAll('1', '');
  str = str.replaceAll('2', '');
  str = str.replaceAll('3', '');
  str = str.replaceAll('4', '');
  str = str.replaceAll('5', '');
  //str = str.replaceAll('TimerRunInProgress', '');
  return str;
}
