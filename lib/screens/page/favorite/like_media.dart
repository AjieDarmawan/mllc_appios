import 'dart:async';
import 'dart:io';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/trainings/trainings_bloc.dart';
// import 'package:xclub/Bloc/trainings/trainings_bloc.dart';
import 'package:mlcc_app_ios/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:mlcc_app_ios/screens/page/favorite/favorite_view.dart';
import 'package:mlcc_app_ios/screens/page/training/media_detail.dart';
import 'package:mlcc_app_ios/widget/flick_video_player.dart';
import '../../../constant.dart';

class LikeMediaViewPage extends StatefulWidget {
  final dynamic training;
  const LikeMediaViewPage({Key? key, this.training}) : super(key: key);
  @override
  _LikeMediaViewPageState createState() => _LikeMediaViewPageState();
}

class _LikeMediaViewPageState extends State<LikeMediaViewPage> {
  // List<dynamic> training = [];
  bool liked = true;
  int userId = 0;
  bool joined = false;
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // isLoggedIn = prefs.getBool("isLoggedIn")!;
      userId = prefs.getInt("userId")!;
      // training = [];
      // if (userId != 0) {
      //   if (widget.trainings['joined_user_id'].isNotEmpty &&
      //       widget.trainings['joined_user_id'].contains(userId) == true) {
      //     joined = true;
      //   }
      //   training = widget.trainings['training_videos'];
      // }

      // for (int i = 0; i < widget.trainings['training_videos'].length; ++i) {
      //   if (joined == false) {
      //     if (widget.trainings['training_videos'][i]['availability'] ==
      //         'Public') {
      //       training.add(widget.trainings['training_videos'][i]);
      //     }
      //   } else {

      //   }
      // }
    });
  }

  @override
  void initState() {
    getUser();
    // if (userId != 0) {
    //   if (widget.trainings['joined_user_id'].isNotEmpty &&
    //       widget.trainings['joined_user_id'].contains(userId) == true) {
    //     joined = true;
    //   }
    // }

    // for (int i = 0; i < widget.trainings['training_videos'].length; ++i) {
    //   if (joined == false) {
    //     if (widget.trainings['training_videos'][i]['availability'] ==
    //         'Public') {
    //       training.add(widget.trainings['training_videos'][i]);
    //     }
    //   } else {
    //     training.add(widget.trainings['training_videos'][i]);
    //   }
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.training.length > 0
        ? ListView.builder(
            padding: const EdgeInsets.only(top: 0, bottom: 8),
            itemCount: widget.training.length,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: _buildMediaAlbumList(widget.training[index]),
              );
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
          ));
  }

  _buildMediaAlbumList(media) {
    // if (userId != 0) {
    //   if (media['wished_user_id'].isNotEmpty &&
    //       media['wished_user_id'].contains(userId) == true) {
    //     liked = true;
    //   } else {
    //     liked = false;
    //   }
    // }

    return InkWell(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FlickVideo(
              videoUrl: media,
            ),
          ),
          Positioned(
              top: 10,
              right: 10,
              child: FavoriteButton(
                  isFavorite: liked,
                  iconDisabledColor: const Color(0xFFFFFFFF).withOpacity(0.7),
                  iconSize: 35,
                  valueChanged: (_isFavorite) {
                    _validateInputs(media['video_id']);
                  })),
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
                width: MediaQuery.of(context).size.width * 0.44,
                color: const Color(0xFFFFFFFF).withOpacity(0.7),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, right: 10, left: 10, bottom: 5),
                        child: Text(
                          media['video_name'],
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, right: 10, left: 10, bottom: 5),
                        child: Text(
                          "(" + media['training_name'] + ")",
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: kThirdColor),
                        ),
                      ),
                    ])),
          )
        ],
      ),
      onTap: () {
        // Navigator.push(
        //   context,
        //   PageTransition(
        //     type: PageTransitionType.fade,
        //     child: MediaDetailPage(
        //       mediaUrl: media['video_link'],
        //     ),
        //   ),
        // );
        if (Platform.isAndroid) {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: MediaDetailPage(
                mediaUrl: media['video_link'],
              ),
            ),
          );
        } else if (Platform.isIOS) {
          launch(media['video_link']);
        }
      },
    );
  }

  void _validateInputs(mediaID) {
    final _formData = {};
    _formData['user_id'] = userId;
    _formData['media_id'] = mediaID;

    Timer(const Duration(milliseconds: 600), () {
      showProgress(context);
      context.read<TrainingsBloc>().add(UpdateFavoriteMedia(_formData));
      // Navigator.pop(context);
      // Navigator.pushReplacementNamed(context, '/training_details_view_page',
      //     arguments: {
      //       'data': widget.data,
      //       'trainingList': widget.trainingList
      //     });
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
          message: const Text('Remove Wishlist...')),
    );
    showResultDialog(context, result);
    // return result;
  }

  void showResultDialog(
    BuildContext context,
    String result,
  ) {
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: const MainScreen(page: FavoritePage(), index: 1),
      ),
    );
  }
}
