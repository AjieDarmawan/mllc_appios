import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:mlcc_app_ios/constant.dart';

class CheckboxField extends StatefulWidget {
  final bool value;
  final bool tristate;
  final Function setCheckboxValue;
  final Color? activeColor;
  final Color? checkColor;
  final MaterialTapTargetSize? materialTapTargetSize;
  final String translateLabel;
  final IconData? icon;

  const CheckboxField(
      {Key? key,
      required this.value,
      this.tristate = false,
      required this.setCheckboxValue,
      this.activeColor,
      this.checkColor,
      this.materialTapTargetSize,
      required this.translateLabel,
      this.icon})
      : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<CheckboxField> {
  bool isAgreed = false;
  void _handleValueChange(value) {
    setState(() {
      isAgreed = value;
      widget.setCheckboxValue(value);
    });
  }

  @override
  void initState() {
    isAgreed = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget.icon != null
            ? Icon(widget.icon, color: kPrimaryColor).marginOnly(right: 14)
            : Container(),
        Checkbox(
          value: isAgreed,
          onChanged: _handleValueChange,
          activeColor: kThirdColor,
        ),
        Expanded(child: Text(widget.translateLabel)),
      ],
    );
  }
}
