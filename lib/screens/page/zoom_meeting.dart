import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/trainings/trainings_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
// import 'package:zoom/zoom.dart';

import '../../provider/http_provider.dart';

class JoinWidget extends StatefulWidget {
  @override
  _JoinWidgetState createState() => _JoinWidgetState();
}

class _JoinWidgetState extends State<JoinWidget> {
  TextEditingController meetingIdController = TextEditingController();
  TextEditingController meetingPasswordController = TextEditingController();
  late Timer timer;
  late String email;
  dynamic trainingData;
  HttpProvider httpProvider = HttpProvider();
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() async {
      email = prefs.getString('email')!;
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // new page needs scaffolding!
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join meeting'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        // automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 32.0,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                  controller: meetingIdController,
                  decoration: const InputDecoration(
                    labelText: 'Meeting ID',
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                  controller: meetingPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Meeting Password',
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Builder(
                builder: (context) {
                  // The basic Material Design action button.
                  return RaisedButton(
                    color: kPrimaryColor,
                    // If onPressed is null, the button is disabled
                    // this is my goto temporary callback.
                    onPressed: () => {
                      //_getTraining(context), joinMeeting(context)
                    },
                    child: const Text(
                      'Join',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Builder(
            //     builder: (context) {
            //       // The basic Material Design action button.
            //       return RaisedButton(
            //         // If onPressed is null, the button is disabled
            //         // this is my goto temporary callback.
            //         onPressed: () => startMeeting(context),
            //         child: const Text('Start Meeting'),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  _getTraining(BuildContext context) {
    return BlocBuilder<TrainingsBloc, TrainingsState>(
        builder: (BuildContext context, TrainingsState state) {
      if (state is GetTrainingDetailsSuccessful) {
        trainingData = state.trainingData;
        //joinMeeting(context);
      }
      return trainingData;
    });
  }

  bool _isMeetingEnded(String status) {
    if (Platform.isAndroid) {
      return status == "MEETING_STATUS_DISCONNECTING" ||
          status == "MEETING_STATUS_FAILED";
    }
    return status == "MEETING_STATUS_ENDED";
  }

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
  //       meetingId: meetingIdController.text,
  //       meetingPassword: meetingPasswordController.text,
  //       disableDialIn: "true",
  //       disableDrive: "true",
  //       disableInvite: "true",
  //       disableShare: "true",
  //       noAudio: "false",
  //       noDisconnectAudio: "false",
  //       meetingViewOptions: ZoomMeetingOptions.NO_TEXT_PASSWORD +
  //           ZoomMeetingOptions.NO_TEXT_MEETING_ID +
  //           ZoomMeetingOptions.NO_BUTTON_PARTICIPANTS);
  //   var zoom = Zoom();
  //   zoom.init(zoomOptions).then((results) {
  //     if (results[0] == 0) {
  //       zoom.onMeetingStateChanged.listen((status) {
  //         print("Meeting Status Stream: " + status[0] + " - " + status[1]);
  //         if (_isMeetingEnded(status[0])) {
  //           timer.cancel();
  //         }
  //       });
  //       zoom.joinMeeting(meetingOptions).then((joinMeetingResult) async {
  //         timer = Timer.periodic(const Duration(seconds: 2), (timer) {
  //           zoom.meetingStatus(meetingOptions.meetingId).then((status) {
  //             print("Meeting Status Polling: " + status[0] + " - " + status[1]);
  //           });
  //         });
  //         var formData = {'email': email, 'training_id': trainingData['id']};
  //         var updateStatusData = await httpProvider.postHttp(
  //             "training/update_join_status", formData);
  //         updateStatusData;
  //         print("milo " + trainingData['id']);
  //       });
  //     }
  //   });
  // }
  // startMeeting(BuildContext context) {}
}
