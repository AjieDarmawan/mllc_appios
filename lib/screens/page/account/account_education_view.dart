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

class AccountEducationViewPage extends StatefulWidget {
  const AccountEducationViewPage({Key? key}) : super(key: key);

  @override
  _AccountEducationViewPageState createState() =>
      _AccountEducationViewPageState();
}

class _AccountEducationViewPageState extends State<AccountEducationViewPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'education_id': null,
    'academic_institution': null,
    'education_level': null,
    'start_date': null,
    'end_date': null
  };

  @override
  void didChangeDependencies() {
    final dynamic args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      _formData['education_id'] = args['data']['id'];
      _formData['academic_institution'] = args['data']['institution'];
      _formData['education_level'] = args['data']['level'];
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
            "Education",
            style: TextStyle(
              color: kSecondaryColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        body: Form(
          key: _formKey,
          child: ListView(primary: true, children: [
            TextFieldWidget(
              labelText: "Academic Instituion",
              iconData: FontAwesomeIcons.userGraduate,
              //iconData: Icons.ac_unit,
              setValue: _setInputValue,
              field: 'academic_institution',
              mandatory: "*",
              validator: RequiredValidator(
                  errorText: 'Academic Instituion is required'),
              initialValue: _formData['academic_institution'],
            ),
            TextFieldWidget(
              labelText: "Education Level",
              mandatory: "*",
              iconData: FontAwesomeIcons.graduationCap,
              //iconData: Icons.ac_unit,
              setValue: _setInputValue,
              field: 'education_level',
              validator:
                  RequiredValidator(errorText: 'Education Level is required'),
              initialValue: _formData['education_level'],
            ),
            DateFieldWidget(
              labelText: "Start Date",

              iconData: FontAwesomeIcons.solidCalendarAlt,
              // iconData: Icons.ac_unit,
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
              mandatory: "*",
              iconData: FontAwesomeIcons.solidCalendarAlt,
              //iconData: Icons.ac_unit,
              isFirst: false,
              isLast: true,
              setValue: _setInputValue,
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
                              .add(CreateUpdateEducation(_formData));
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
