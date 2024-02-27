import 'package:flutter/material.dart';
import 'package:mlcc_app_ios/constant.dart';

import 'home_swiper.dart';

class AppBarHomeSliver extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final List<String>? banners;

  AppBarHomeSliver({
    required this.expandedHeight,
    this.banners,
  });

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        HomeSwipe(
          images: banners,
          height: expandedHeight,
        ),
        // Container(
        //   height: 36,
        //   color: Colors.white,
        // ),
        // SafeArea(
        //   child: Container(
        //     padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        //     child: Card(
        //       margin: const EdgeInsets.all(0),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //       elevation: 2,
        //       child: TextButton(
        //         // onPressed: onSearch,
        //         onPressed: () {},
        //         child: Container(
        //           decoration: BoxDecoration(
        //             color: Theme.of(context).dividerColor.withOpacity(.07),
        //             borderRadius: const BorderRadius.all(
        //               Radius.circular(8),
        //             ),
        //           ),
        //           child: Padding(
        //             padding: const EdgeInsets.all(8),
        //             child: IntrinsicHeight(
        //               child: Row(
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 children: <Widget>[
        //                   Expanded(
        //                     child: Text(
        //                       'Search...',
        //                       style: Theme.of(context)
        //                           .textTheme
        //                           .button!
        //                           .copyWith(color: Theme.of(context).hintColor),
        //                     ),
        //                   ),
        //                   const Padding(
        //                     padding: EdgeInsets.only(left: 8, right: 8),
        //                     child: VerticalDivider(),
        //                   ),
        //                   const Icon(
        //                     Icons.search,
        //                     color: kPrimaryColor,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
