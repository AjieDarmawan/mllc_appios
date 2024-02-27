import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/xproject/xproject_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';

import 'xproject_list_widget.dart';

class XProjectPage extends StatefulWidget {
  const XProjectPage({Key? key}) : super(key: key);

  @override
  _XProjectPageState createState() => _XProjectPageState();
}

class _XProjectPageState extends State<XProjectPage> {
  late int userId;

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("userId")!;
    // setState(() async {
    //   userId = prefs.getInt("userId")!;
    //   // if (userId != 0) {
    //   //   getRequestConnect(userId);
    //   // }
    //   // isLoggedIn = prefs.getBool("isLoggedIn")!;
    //   // deviceToken = prefs.getString("OneSignalPlayerID") as String;
    // });
  }

  @override
  void initState() {
    super.initState();
    getUser();
    context.read<XprojectBloc>().add(const GetXprojectList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "X-Project",
          style: TextStyle(
            color: kSecondaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: BlocListener<XprojectBloc, XprojectState>(
        listener: (context, state) {
          if (state is XprojectInitial) {
          } else if (state is XprojectLoading) {}
        },
        child: BlocBuilder<XprojectBloc, XprojectState>(
          builder: (context, state) {
            if (state is XprojectInitial) {
              return const Center(
                  child: CircularProgressIndicator(color: kPrimaryColor));
            } else if (state is XprojectLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: kPrimaryColor));
            } else if (state is GetXprojectListSuccessful) {
              return state.projectList.isEmpty
                  ? const Center(child: Text("No Project Found!"))
                  : Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: state.projectList.length,
                  itemBuilder: (context, i) {
                    var project = state.projectList[i];
                    return XProjectListWidget(list: project);
                  },
                ),
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(color: kPrimaryColor));
            }
          },
        ),
      ),
    );
  }
}
