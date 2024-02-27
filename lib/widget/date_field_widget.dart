// ignore_for_file: unnecessary_null_comparison

/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import '../../../common/ui.dart';

class DateFieldWidget extends StatelessWidget {
  const DateFieldWidget(
      {Key? key,
      // this.onSaved,
      @required this.field,
      @required this.setValue,
      this.onChanged,
      this.validator,
      this.keyboardType,
      this.initialValue = "",
      this.hintText,
      this.errorText,
      this.iconData,
      this.labelText,
      this.obscureText,
      this.suffixIcon,
      this.isFirst,
      this.isLast,
      this.style,
      this.textAlign,
      this.suffix,
      this.readOnly = false})
      : super(key: key);

  // final FormFieldSetter<String>? onSaved;
  final Function? setValue;
  final String? field;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final String? initialValue;
  final String? hintText;
  final String? errorText;
  final TextAlign? textAlign;
  final String? labelText;
  final TextStyle? style;
  final IconData? iconData;
  final bool? obscureText;
  final bool? isFirst;
  final bool? isLast;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
      margin: EdgeInsets.only(
          left: 20, right: 20, top: topMargin, bottom: bottomMargin),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: buildBorderRadius,
          boxShadow: [
            BoxShadow(
                color: Get.theme.focusColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5)),
          ],
          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            labelText ?? "",
            style: Get.textTheme.bodyText1,
            textAlign: textAlign ?? TextAlign.start,
          ),
          DateTimePicker(
            initialValue: initialValue,
            dateMask: 'dd-MMM-yyyy',
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            decoration: InputDecoration(
                icon: Icon(iconData, color: kPrimaryColor),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.only(
                    left: 15, bottom: 11, top: 11, right: 15)),
            validator: validator,
            onSaved: (dynamic value) {
              setValue!(field, value);
            },
            onChanged: (dynamic value) {
              setValue!(field, value);
            },
          )
        ],
      ),
    );
  }

  BorderRadius get buildBorderRadius {
    if (isFirst != null && isFirst!) {
      return const BorderRadius.vertical(top: Radius.circular(10));
    }
    if (isLast != null && isLast!) {
      return const BorderRadius.vertical(bottom: Radius.circular(10));
    }
    if (isFirst != null && isLast != null) {
      return const BorderRadius.all(Radius.circular(0));
    }
    return const BorderRadius.all(Radius.circular(10));
  }

  double get topMargin {
    if ((isFirst != null && isFirst!)) {
      return 20;
    } else if (isFirst == null) {
      return 20;
    } else {
      return 0;
    }
  }

  double get bottomMargin {
    if ((isLast != null && isLast!)) {
      return 10;
    } else if (isLast == null) {
      return 10;
    } else {
      return 0;
    }
  }
}
