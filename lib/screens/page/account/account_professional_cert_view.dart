import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:provider/src/provider.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/widget/text_field_widget.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AccountProfessionalCertViewPage extends StatefulWidget {
  const AccountProfessionalCertViewPage({Key? key}) : super(key: key);

  @override
  _AccountProfessionalCertViewPageState createState() =>
      _AccountProfessionalCertViewPageState();
}

class _AccountProfessionalCertViewPageState
    extends State<AccountProfessionalCertViewPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _disableEdit = false;
  final Map<String, dynamic> _formData = {
    'cert_id': null,
    'certname': null,
    'entitled_year': null
  };

  @override
  void didChangeDependencies() {
    final dynamic args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      _formData['cert_id'] = args['data']['id'];
      _formData['certname'] = args['data']['certificate_name'];
      _formData['entitled_year'] = args['data']['year_entitled'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Professional Cert & Rewards",
            style: TextStyle(
              color: kSecondaryColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        //bottomNavigationBar:
        body: Form(
          key: _formKey,
          child: ListView(primary: true, children: [
            TextFieldWidget(
              labelText: "Certificate Name",
              iconData: FontAwesomeIcons.certificate,
              //iconData: Icons.ac_unit,
              setValue: _setInputValue,
              mandatory: "*",
              field: 'certname',
              validator:
                  RequiredValidator(errorText: 'Certificate Name is required'),
              initialValue: _formData['certname'],
              readOnly: _disableEdit,
            ),
            TextFieldWidget(
              keyboardType: TextInputType.number,
              labelText: "Year Entitled",
              mandatory: "*",
              //iconData: Icons.ac_unit,
              iconData: FontAwesomeIcons.solidCalendarAlt,
              setValue: _setInputValue,
              field: 'entitled_year',
              validator:
                  RequiredValidator(errorText: 'Year Entitled is required'),
              initialValue: _formData['entitled_year'],
              readOnly: _disableEdit,
            ),
            SizedBox(
              height: _disableEdit == true ? 0 : 90,
              child: Column(
                children: [
                  if (_disableEdit == false)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
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
                                  context.read<AuthBloc>().add(
                                      CreateUpdateProfessionalCert(_formData));
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
                ],
              ),
            ),
          ]),
        ));
  }

  void _setInputValue(String field, String value) {
    setState(() => _formData[field] = value.trim());
  }
}
