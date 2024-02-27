import 'package:flutter/material.dart';
import 'package:mlcc_app_ios/constant.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(
          color: kThirdColor,
        ),
      );
}
