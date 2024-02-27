import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:html/parser.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/trainings/trainings_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/page/home/newsletter_view.dart';

class AllNewsLetterListPage extends StatefulWidget {
  final dynamic data;

  const AllNewsLetterListPage({Key? key, this.data}) : super(key: key);

  @override
  _AllNewsLetterListPageState createState() => _AllNewsLetterListPageState();
}

class _AllNewsLetterListPageState extends State<AllNewsLetterListPage> {
  String deviceID = '';
  int userId = 0;
  bool follow = false;

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  Widget build(BuildContext context) {
    return widget.data.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            itemCount: widget.data.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildNewslettersList(widget.data[index]);
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

  Widget _buildNewslettersList(dynamic newsletter) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          // color: kPrimaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        // child: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Center(
        //       child:
        //           Image.network(newsletter['thumbnail'], fit: BoxFit.fitHeight)),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Image.network(
              newsletter['thumbnail'],
              fit: BoxFit.values[0],
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width * 0.90,
            )),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Text(
                newsletter['title'],
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.0),
              child: Row(children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.calendar_today,
                    color: kThirdColor,
                    size: 13,
                  ),
                ),
                Text(
                  newsletter['publish_at'],
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w300),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10, right: 5.0),
                  child: Icon(
                    Icons.person,
                    color: kThirdColor,
                    size: 13,
                  ),
                ),
                Text(
                  "By ${newsletter['created_by']}",
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w300),
                )
              ]),
            ),
          ],
        ),
      ),
      onTap: () {
        // Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: NewsLetterViewPage(data: newsletter),
          ),
        );
      },
    );
  }

  void _validateInputs(trainer_id) {
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
      showProgress(context);
      context.read<TrainingsBloc>().add(UpdateFavoriteTrainer(_formData));
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
          message: const Text('Following...')),
    );
    showResultDialog(context, result);
    // return result;
  }

  void showResultDialog(
    BuildContext context,
    String result,
  ) {
    // Navigator.pop(context);
    Navigator.pushNamed(context, '/trainers_view_page');
  }
}
