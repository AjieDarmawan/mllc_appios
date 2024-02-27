// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/page/model/model_category.dart';
import 'package:mlcc_app_ios/widget/app_placeholder.dart';

class HomeCategoryItem extends StatelessWidget {
  final CategoryModel? item;
  final Function(CategoryModel)? onPressed;

  const HomeCategoryItem({
    Key? key,
    this.item,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return AppPlaceholder(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.23,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 8),
              Container(
                height: 10,
                width: 48,
                color: Colors.white,
              ),
            ],
          ),
          //   child: Card(
          //   elevation: 10,
          //   shadowColor: kThirdColor,
          //   color: kPrimaryColor,
          //   shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.all(Radius.circular(19.0))),
          //   child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.start,
          //           children: [
          //             Container(
          //               height: MediaQuery.of(context).size.height * 0.1,
          //               padding: EdgeInsets.all(10),
          //               alignment: Alignment.topLeft,
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   // Text(item!.title,
          //                   //     textAlign: TextAlign.left,
          //                   //     style: TextStyle(
          //                   //         color: Colors.white,
          //                   //         fontWeight: FontWeight.bold,
          //                   //         fontSize: 16.0)),
          //                   // Padding(
          //                   //     padding: EdgeInsets.only(top: 5),
          //                   //     child: Text(
          //                   //       item!.title,
          //                   //       textAlign: TextAlign.left,
          //                   //       style: TextStyle(
          //                   //           color: Colors.grey[700], fontSize: 13.0),
          //                   //     ))
          //                 ],
          //               ),
          //             ),
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.end,
          //               children: [
          //                 // Container(
          //                 //   child: Padding(
          //                 //     padding: EdgeInsets.all(16.0),
          //                 //     child: FaIcon(
          //                 //       item!.icon,
          //                 //       size: 30,
          //                 //       color: Colors.white,
          //                 //     ),
          //                 //   ),
          //                 // ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ]),
          // ),
        ),
      );
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      child: GestureDetector(
        onTap: () => onPressed!(item!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 50,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: kPrimaryColor,
                    //border: Border.all(width: 2, color: Color.fromARGB(255, 19, 19, 18)),
                    borderRadius: BorderRadius.circular(10)),
                child: Text("tes")
                // child: FaIcon(
                //   item!.icon,
                //   size: 25,
                //   color: kSecondaryColor,
                // ),
                ),
            const SizedBox(height: 4),
            Text(
              item!.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.button!.copyWith(fontSize: 11),
            ),
          ],
        ),
        // child: Padding(
        //   padding: const EdgeInsets.all(5.0),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //           colors: [kPrimaryColor, Colors.blue.shade400],
        //           begin: AlignmentDirectional.topStart,
        //           //const FractionalOffset(1, 0),
        //           end: AlignmentDirectional.bottomEnd,
        //           stops: const [0.1, 0.9],
        //           tileMode: TileMode.clamp),
        //       borderRadius: BorderRadius.all(Radius.circular(10)),
        //     ),
        //     child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: <Widget>[
        //           Column(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             children: [
        //               Container(
        //                 height: MediaQuery.of(context).size.height * 0.06,
        //                 padding: EdgeInsets.all(10),
        //                 alignment: Alignment.topLeft,
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(item!.title,
        //                         textAlign: TextAlign.left,
        //                         style: TextStyle(
        //                             color: Colors.white,
        //                             fontWeight: FontWeight.bold,
        //                             fontSize: 16.0)),
        //                     // Padding(
        //                     //     padding: EdgeInsets.only(top: 5),
        //                     //     child: Text(
        //                     //       item!.title,
        //                     //       textAlign: TextAlign.left,
        //                     //       style: TextStyle(
        //                     //           color: Colors.grey[700], fontSize: 13.0),
        //                     //     ))
        //                   ],
        //                 ),
        //               ),
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.end,
        //                 children: [
        //                   Padding(
        //                     padding: EdgeInsets.all(16.0),
        //                     child: FaIcon(
        //                       item!.icon,
        //                       size: 30,
        //                       color: Colors.white,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ]),
        //   ),
        // ),
      ),
    );
  }
}
