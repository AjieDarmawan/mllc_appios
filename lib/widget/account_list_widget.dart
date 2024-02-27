import 'package:flutter/material.dart';
import 'package:mlcc_app_ios/constant.dart';
import 'package:mlcc_app_ios/screens/page/account/account_education_list_view.dart';
import 'package:mlcc_app_ios/screens/page/account/account_professional_cert_list_view.dart';
import 'package:mlcc_app_ios/screens/page/account/account_social_media_list_view.dart';
import 'package:mlcc_app_ios/screens/page/account/account_societies_list_view.dart';
import 'package:mlcc_app_ios/screens/page/account/account_work_experienced_list_view.dart';

class AccountListWidgetPage extends StatelessWidget {
  final bool disableEdit;
  final String navigateToEditPageRoute;
  final String label;

  const AccountListWidgetPage(
      {Key? key,
      required this.navigateToEditPageRoute,
      required this.label,
      required this.disableEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            label,
            style: const TextStyle(
              color: kSecondaryColor,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
        ),
        body: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            color: Theme.of(context).cardColor,
            width: MediaQuery.of(context).size.width,
            child: ListView(
                children: _renderWidgets(context, label, disableEdit))),
        floatingActionButton: disableEdit == false
            ? FloatingActionButton(
                backgroundColor: kThirdColor,
                onPressed: () {
                  Navigator.pushNamed(context, navigateToEditPageRoute);
                },
                child: const Icon(Icons.add))
            : Container());
  }

  List<Widget> _renderWidgets(
      BuildContext context, String label, bool disableEdit) {
    List<Widget> tempList = [];
    if (label == "Social Media") {
      tempList.add(AccountSocialMediaListViewPage(
        disableEdit: disableEdit,
        showEdit: true,
      ));
    } else if (label == "Education") {
      tempList.add(AccountEducationListViewPage(
        showEdit: true,
        disableEdit: disableEdit,
      ));
    } else if (label == "Societies") {
      tempList.add(AccountSocietiesListViewPage(
        showEdit: true,
        disableEdit: disableEdit,
      ));
    } else if (label == "Professional Cert & Rewards") {
      tempList.add(AccountProfessionalCertListViewPage(
        showEdit: true,
        disableEdit: disableEdit,
      ));
    } else if (label == "Work Experienced") {
      tempList.add(AccountWorkExperiencedListViewPage(
        showEdit: true,
        disableEdit: disableEdit,
      ));
    }

    // if (label == 'profile_work_experiences') {
    //   tempList.add(ProfileEmploymentWidget(
    //     showEdit: true,
    //   ));
    // } else if (label == 'profile_highest_education') {
    //   tempList.add(ProfileEducationWidget(
    //     showEdit: true,
    //   ));
    // } else if (label == 'profile_society') {
    //   tempList.add(ProfileSocietyWidget(
    //     showEdit: true,
    //   ));
    // } else if (label == 'profile_professional_certification') {
    //   tempList.add(ProfileProfessionalCertificationWidget(
    //     showEdit: true,
    //   ));
    // } else if (label == 'profile_personal_particulars') {
    //   tempList.add(ProfilePersonalParticularWidget(
    //     showEdit: true,
    //   ));
    // } else if (label == 'profile_social_media') {
    //   tempList.add(ProfileSocialMediaWidget(
    //     showEdit: true,
    //   ));
    // }
    return tempList;
  }
}
