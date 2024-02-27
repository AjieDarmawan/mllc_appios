import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/trainings/trainings_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';

class TrainingsViewPage extends StatefulWidget {
  final dynamic data;
  const TrainingsViewPage({Key? key, this.data}) : super(key: key);

  @override
  _TrainersViewPageState createState() => _TrainersViewPageState();
}

class _TrainersViewPageState extends State<TrainingsViewPage> {
  List<dynamic> trainingsList = [];
  var userId = 0;

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
    });
  }

  @override
  void initState() {
    // Timer(const Duration(milliseconds: 1000), () {
    context.read<TrainingsBloc>().add(GetTrainingsList(widget.data));
    // });
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainingsBloc, TrainingsState>(
        builder: (BuildContext context, TrainingsState state) {
      if (state is GetTrainingsListSuccessful) {
        trainingsList = state.trainingsList;
        trainingsList.removeWhere((item) => item['created_by'] == userId);
        return _buildContent(context, trainingsList);
      } else {
        return WillPopScope(
          onWillPop: () async {
            return backtoPrevious();
          },
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, '/trainers_view_page');
                  },
                  icon: const Icon(Icons.keyboard_arrow_left, size: 30),
                ),
                title: const Text(
                  "Trainings",
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
      }
    });
  }

  backtoPrevious() {
    Navigator.pushReplacementNamed(context, '/trainers_view_page');
  }

  Widget _buildContent(BuildContext context, List<dynamic> trainingsList) {
    return WillPopScope(
      onWillPop: () async {
        return backtoPrevious();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/trainers_view_page');
            },
            icon: const Icon(Icons.keyboard_arrow_left, size: 30),
          ),
          title: const Text(
            "Trainings",
            style: TextStyle(
              color: kSecondaryColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        body: trainingsList.isNotEmpty
            ? ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                itemCount: trainingsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildTrainingsList(trainingsList[index]);
                })
            : Center(
                child: SizedBox(
                  height: 600.0,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("No records found!",
                            style:
                                TextStyle(color: kThirdColor.withOpacity(0.7))),
                      ]),
                ),
              ),
      ),
    );
  }

  Widget _buildTrainingsList(dynamic data) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/training_details_view_page',
            arguments: {'data': data, 'trainingList': widget.data});
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: kThirdColor.withOpacity(0.3),
              blurRadius: 10,
            ),
          ],
          border: Border.all(color: kPrimaryColor.withOpacity(0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data['title'],
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
                          data['caption'],
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
                      data['payment'] == 1
                          ? Expanded(
                              child: Text(
                                data['price'],
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .merge(TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: kThirdColor.withOpacity(0.8))),
                              ),
                            )
                          : Expanded(
                              child: Text(
                                "Free",
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .merge(TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: kThirdColor.withOpacity(0.8))),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
