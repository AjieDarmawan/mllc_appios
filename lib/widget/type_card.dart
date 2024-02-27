import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';

class TypeCard extends StatelessWidget {
  final String label;
  final int totalIndex;
  final Color colorCard;
  final String status;

  const TypeCard(this.label, this.totalIndex, this.colorCard, this.status);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: label == status
          ? Row(
              children: [
                Banner(
                  message: "Current Status",
                  location: BannerLocation.topEnd,
                  textStyle: const TextStyle(fontSize: 11),
                  child: Card(
                    color: colorCard,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(19.0))),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                alignment: Alignment.topLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(label,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13.0)),
                                    Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          label,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              color: kThirdColor,
                                              fontSize: 11.0),
                                        ))
                                  ],
                                ),
                              ),
                              if (label == 'Contacted')
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, right: 25.0, bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      Icon(Icons.phone,
                                          size: 30, color: kPrimaryColor),
                                    ],
                                  ),
                                ),
                              if (label == 'In Progress')
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, right: 25.0, bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      Icon(Icons.rotate_left,
                                          size: 30, color: kPrimaryColor),
                                    ],
                                  ),
                                ),
                              if (label == 'Deal On')
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, right: 25.0, bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      Icon(Icons.thumb_up,
                                          size: 30, color: kPrimaryColor),
                                    ],
                                  ),
                                ),
                              if (label == 'Deal Off')
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, right: 25.0, bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: const [
                                      Icon(Icons.mobile_off,
                                          size: 30, color: kPrimaryColor),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ],
            )
          : Card(
              color: colorCard,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(19.0))),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(label,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0)),
                              Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    label,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: kThirdColor, fontSize: 11.0),
                                  ))
                            ],
                          ),
                        ),
                        if (label == 'Contacted')
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 25.0, bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(Icons.phone,
                                    size: 30, color: kPrimaryColor),
                              ],
                            ),
                          ),
                        if (label == 'In Progress')
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 25.0, bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(Icons.rotate_left,
                                    size: 30, color: kPrimaryColor),
                              ],
                            ),
                          ),
                        if (label == 'Deal On')
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 25.0, bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(Icons.thumb_up,
                                    size: 30, color: kPrimaryColor),
                              ],
                            ),
                          ),
                        if (label == 'Deal Off')
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, right: 25.0, bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(Icons.mobile_off,
                                    size: 30, color: kPrimaryColor),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ]),
            ),
    );
  }
}
