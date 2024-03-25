import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:provider/src/provider.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/widget/loading_widget.dart';
import 'package:mlcc_app_ios/widget/text_field_widget.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AccountSocialMediaViewPage extends StatefulWidget {
  const AccountSocialMediaViewPage({Key? key}) : super(key: key);

  @override
  _AccountSocialMediaViewPageState createState() =>
      _AccountSocialMediaViewPageState();
}

class _AccountSocialMediaViewPageState
    extends State<AccountSocialMediaViewPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'social_media_id': null,
    'platform': null,
    'url': null,
  };

  @override
  void didChangeDependencies() {
    final dynamic args = ModalRoute.of(context)!.settings.arguments;
    if (args != null) {
      _formData['social_media_id'] = args['data']['id'];
      _formData['platform'] = args['data']['platform'];
      _formData['url'] = args['data']['url'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text(
              "Social Media",
              style: TextStyle(
                color: kSecondaryColor,
              ),
            ),
            centerTitle: true,
            backgroundColor: kPrimaryColor,
            elevation: 0,
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: kSecondaryColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: kThirdColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5)),
              ],
            ),
            child: Row(
              children: [
                Expanded(child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (BuildContext context, AuthState state) {
                  if (state is AuthLoading) {
                    return const LoadingWidget();
                  } else {
                    return MaterialButton(
                      onPressed: () {
                        final form = _formKey.currentState;
                        if (form!.validate()) {
                          form.save();
                          context
                              .read<AuthBloc>()
                              .add(CreateUpdateSocialMedia(_formData));
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
                    );
                  }
                })),
              ],
            ).paddingSymmetric(vertical: 10, horizontal: 20),
          ),
          body: Form(
            key: _formKey,
            child: ListView(primary: true, children: [
              // const Text("Profile details")
              //     .paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
              // const Text("Change the following details and save them")
              //     .paddingSymmetric(horizontal: 22, vertical: 5),
              TextFieldWidget(
                labelText: "Social Media Platform",
                // iconData: Icons.ac_unit,
                iconData: FontAwesomeIcons.hashtag,
                setValue: _setInputValue,
                field: 'platform',
                validator: RequiredValidator(
                    errorText: 'Social Media Platform is required'),
                initialValue: _formData['platform'],
              ),
              TextFieldWidget(
                labelText: "Social Media URL",
                //iconData: Icons.ac_unit,
                iconData: FontAwesomeIcons.link,
                setValue: _setInputValue,
                field: 'url',
                validator:
                    RequiredValidator(errorText: 'Social Media URL is required'),
                initialValue: _formData['url'],
              ),
            ]),
          )),
    );
  }

  void _setInputValue(String field, String value) {
    setState(() => _formData[field] = value.trim());
  }
}
