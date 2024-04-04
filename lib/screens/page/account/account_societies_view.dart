import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:provider/src/provider.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/widget/date_field_widget.dart';
import 'package:mlcc_app_ios/widget/text_field_widget.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AccountSocietiesViewPage extends StatefulWidget {
  const AccountSocietiesViewPage({Key? key}) : super(key: key);

  @override
  _AccountSocietiesViewPageState createState() =>
      _AccountSocietiesViewPageState();
}

class _AccountSocietiesViewPageState extends State<AccountSocietiesViewPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'society_id': null,
    'society_name': null,
    'holding_position': null,
    'start_date': null,
    'end_date': null
  };

  @override
  void didChangeDependencies() {
    final dynamic args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      _formData['society_id'] = args['data']['id'];
      _formData['society_name'] = args['data']['society_name'];
      _formData['holding_position'] = args['data']['holding_position'];
      _formData['start_date'] = args['data']['start_date'];
      _formData['end_date'] = args['data']['end_date'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Societies",
            style: TextStyle(
              color: kSecondaryColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        // bottomNavigationBar:
        body: Form(
          key: _formKey,
          child: ListView(primary: true, children: [
            TextFieldWidget(
              labelText: "Society Name",
              mandatory: "*",
              // iconData: Icons.ac_unit,
              iconData: FontAwesomeIcons.users,
              setValue: _setInputValue,
              field: 'society_name',
              validator:
                  RequiredValidator(errorText: 'Society Name is required'),
              initialValue: _formData['society_name'],
            ),
            TextFieldWidget(
              labelText: "Holding Position",
              // iconData: Icons.ac_unit,
              iconData: FontAwesomeIcons.userTag,
              mandatory: "*",
              setValue: _setInputValue,
              field: 'holding_position',
              validator:
                  RequiredValidator(errorText: 'Holding Position is required'),
              initialValue: _formData['holding_position'],
            ),
            DateFieldWidget(
              labelText: "Start Date",

              // iconData: Icons.ac_unit,
              iconData: FontAwesomeIcons.solidCalendarAlt,
              isFirst: true,
              isLast: false,
              setValue: _setInputValue,
              field: 'start_date',
              mandatory: "*",
              validator: RequiredValidator(errorText: 'Start Date is required'),
              initialValue: _formData['start_date'],
            ),
            DateFieldWidget(
              labelText: "End Date",
              //iconData: Icons.ac_unit,
              iconData: FontAwesomeIcons.solidCalendarAlt,
              isFirst: false,
              isLast: true,
              setValue: _setInputValue,
              mandatory: "*",
              field: 'end_date',
              validator: RequiredValidator(errorText: 'End Date is required'),
              initialValue: _formData['end_date'],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: kThirdColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      onPressed: () {
                        final form = _formKey.currentState;
                        if (form!.validate()) {
                          form.save();
                          context
                              .read<AuthBloc>()
                              .add(CreateUpdateSocieties(_formData));
                          Navigator.pop(context);
                        }
                      },
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: kPrimaryColor,
                      child: const Text("Save",
                          style: TextStyle(color: kSecondaryColor)),
                      elevation: 0,
                      highlightElevation: 0,
                      hoverElevation: 0,
                      focusElevation: 0,
                    ),
                  ),
                ],
              ).paddingSymmetric(vertical: 10, horizontal: 20),
            ),
          ]),
        ));
  }

  void _setInputValue(String field, String value) {
    setState(() => _formData[field] = value.trim());
  }
}
