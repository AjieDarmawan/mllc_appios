import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlcc_app_ios/Bloc/adv/adv_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/page/adv/product_list.dart';
import 'package:mlcc_app_ios/screens/page/adv/rewards_list.dart';
import 'package:mlcc_app_ios/screens/page/adv/vouchers_list.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';

class XBuyPage extends StatefulWidget {
  @override
  _XBuyPageState createState() => new _XBuyPageState();
}

class _XBuyPageState extends State<XBuyPage>
    with SingleTickerProviderStateMixin {
  var _activeTabIndex;
  void initState() {
    super.initState();

    context.read<AdvBloc>().add(const GetAdvList());
  }

  List<dynamic> vouchersList = [];
  List<dynamic> rewardsList = [];
  List<dynamic> productsList = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvBloc, AdvState>(
        builder: (BuildContext context, AdvState state) {
      if (state is GetAdvListSuccessful) {
        productsList = state.productsList;
        return _buildContent(context, productsList);
      } else {
        return Scaffold(
            appBar: AppBar(
              // leading: IconButton(
              //   onPressed: () {
              //     Navigator.pushReplacementNamed(context, '/home_page');
              //   },
              //   icon: const Icon(Icons.keyboard_arrow_left,size:25),
              // ),
              title: const Text(
                "X-Buy",
                style: TextStyle(
                  color: kSecondaryColor,
                ),
              ),
              centerTitle: true,
              backgroundColor: kPrimaryColor,
              elevation: 0,
            ),
            body: const LoadingWidget());
      }
    });
  }

  Widget _buildContent(BuildContext context, List<dynamic> productsList) {
    // ignore: unused_local_variable
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('X-Buy'),
        backgroundColor: kPrimaryColor,
        centerTitle: true,
      ),
      body: ProductListPage(data: productsList),
    );
  }
}
