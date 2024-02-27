import 'package:flutter/material.dart';
import 'package:mlcc_app_ios/constant.dart';

class TilWidget extends StatelessWidget {
  final Widget title;
  final String? check;
  final Widget content;
  final List<Widget> actions;
  final double? horizontalPadding;

  const TilWidget(
      {Key? key,
      required this.title,
      required this.content,
      this.check,
      required this.actions,
      this.horizontalPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (check == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 20, vertical: 15),
        decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: kThirdColor.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5)),
          ],
          border: Border.all(color: kPrimaryColor.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: title),
                if (actions != null)
                  Wrap(
                    children: actions,
                  )
              ],
            ),
            const Divider(
              height: 26,
              thickness: 1.2,
            ),
            content,
          ],
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: content,
          ),
        ],
      );
    }
  }
}
