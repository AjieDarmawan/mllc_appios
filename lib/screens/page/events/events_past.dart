import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlcc_app_ios/Bloc/entrepreneurs/entrepreneurs_bloc.dart';
import 'package:mlcc_app_ios/Bloc/events/events_bloc.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/page/auth/login_page.dart';

class EventPast extends StatefulWidget {
  final dynamic data;

  const EventPast({Key? key, this.data}) : super(key: key);

  @override
  _EventPastState createState() => _EventPastState();
}

class _EventPastState extends State<EventPast> {
  List<dynamic> eventsList = [];
  var userId = 0;
  List<dynamic> items = [];
  List<dynamic> itemList = [];
  late bool showExpired = false;
  int run = 0;
  bool hasData = true;
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt("userId")!;
      showExpired = prefs.getBool("isExpired")!;
    });
  }

  void filterSearchResults(String query) {
    // List<UserInfo> dummySearchList = List();
    // dummySearchList.addAll(widget.dataUserInfo);

    if (query.isNotEmpty && query != "") {
      List<dynamic> dummyListData = [];
      widget.data.forEach((item) {
        if (item['title'].toLowerCase().contains(query.toLowerCase()) ||
            item['title'].toUpperCase().contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      });

      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
    } else {
      setState(() {
        items.clear();
        items.addAll(widget.data);
      });
    }
  }

  @override
  void initState() {
    // context.read<EventsBloc>().add(const GetEventsList());
    //context.read<EventsBloc>().add(const GetEventsPastList());
    if (items.isEmpty) {
      items.addAll(widget.data);
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            height: 50,
            child: TextField(
              style: const TextStyle(color: Colors.white),
              // autofocus: true,
              cursorColor: kSecondaryColor,
              onChanged: (value) {
                filterSearchResults(value);
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: kSecondaryColor,
                ),
                contentPadding: EdgeInsets.all(10.0),
                hintText: 'Search',
                hintStyle: TextStyle(color: kSecondaryColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  borderSide: BorderSide(color: kSecondaryColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  borderSide: BorderSide(color: kSecondaryColor),
                ),
              ),
            ),
          ),
        ),
      ),
      body: widget.data.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildContent(items[index]);
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
    );
  }

  Widget _buildContent(dynamic data) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/event_details_view_page',
            arguments: {'data': data});
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
                                  fontWeight: FontWeight.w500,
                                  color: kGreyColor)),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          data['start_at'],
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: Theme.of(context).textTheme.bodyText1!.merge(
                              TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: kThirdColor.withOpacity(0.8))),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          data['end_at'],
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
                          data['availability'],
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
