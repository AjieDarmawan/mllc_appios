import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/entrepreneurs/entrepreneurs_bloc.dart';
import 'package:mlcc_app_ios/Bloc/events/events_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';
import 'package:mlcc_app_ios/screens/page/events/events_upcoming.dart';
import 'package:mlcc_app_ios/screens/page/events/events_past.dart';
import 'package:mlcc_app_ios/screens/page/events/events_join.dart';
import '../../main_view.dart';

class EventsViewPage extends StatefulWidget {
  const EventsViewPage({Key? key}) : super(key: key);

  @override
  _EventsViewPageState createState() => _EventsViewPageState();
}

class _EventsViewPageState extends State<EventsViewPage>
    with SingleTickerProviderStateMixin {
  List<dynamic> eventsList = [];
  List<dynamic> eventsJoinList = [];
  List<dynamic> eventsPastList = [];

  var userId = 0;
  List<dynamic> items = [];
  List<dynamic> itemList = [];
  bool hasData = true;
  int run = 0;
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   userId = prefs.getInt("userId")!;
    // });

    setState(() {
      if (prefs.getInt("userId") == null) {
        userId = 0;
      } else {
        userId = prefs.getInt("userId")!;
      }
    });

    dynamic formData = {'user_id': userId};

    // Timer(const Duration(milliseconds: 600), () {
    //context.read<AuthBloc>().add(GetUserDetails(formData));
    context.read<EventsBloc>().add(GetEventsList(formData));
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController!.addListener(_setActiveTabIndex);

    dynamic formData = {'user_id': userId};

    getUser();

    //context.read<EventsBloc>().add(const GetEventsList());

    // items = entrepreneursList;

    super.initState();
  }

  TabController? _tabController;
  var _activeTabIndex;

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Upcoming'),
    Tab(text: 'Joined'),
    Tab(text: 'Past'),
  ];

  void filterSearchResults(String query) {
    // List<UserInfo> dummySearchList = List();
    // dummySearchList.addAll(widget.dataUserInfo);

    if (query.isNotEmpty && query != "") {
      List<dynamic> dummyListData = [];
      // itemList.addAll(eventsList);
      for (var item in eventsList) {
        print(item['title']);
        if (item['title'].toLowerCase().contains(query.toLowerCase()) ||
            item['title'].toUpperCase().contains(query.toUpperCase())) {
          dummyListData.add(item);
        }
      }

      setState(() {
        items.clear();
        items.addAll(dummyListData);
        if (items.isEmpty) {
          hasData = false;
        }
      });
    } else {
      setState(() {
        context.read<EntrepreneursBloc>().add(const GetEntrepreneursList());
        items.clear();
        items.addAll(eventsList);
        if (items.isNotEmpty) {
          hasData = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
        builder: (BuildContext context, EventsState state) {
      if (state is GetEventsListSuccessful) {
        eventsList = state.eventsList;
        eventsJoinList = state.eventsJoinList;
        eventsPastList = state.eventsPastList;

        return _buildContent(
            context, eventsList, eventsJoinList, eventsPastList);
      } else {
        return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Event",
                style: TextStyle(
                  color: kSecondaryColor,
                ),
              ),
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: kPrimaryColor,
              elevation: 0,
            ),
            body: const LoadingWidget());
      }
    });
  }

  Widget _buildContent(BuildContext context, List<dynamic> eventList,
      List<dynamic> joinList, List<dynamic> pastList) {
    // ignore: unused_local_variable
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Event'),
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          bottom: TabBar(indicatorColor: Colors.white, tabs: myTabs),
        ),
        body: Stack(
          children: [
            TabBarView(
                // controller: _tabController,
                children: <Widget>[
                  EventUpcoming(data: eventList),
                  EventJoin(data: joinList),
                  EventPast(data: pastList),
                ]),
          ],
        ),
      ),
    ));
  }

  void _setActiveTabIndex() {
    setState(() => _activeTabIndex = _tabController!.index);
  }
}
