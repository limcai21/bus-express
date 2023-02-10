import 'package:bus_express/model/constants.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/profile/company/components/contactFunctions.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:bus_express/view/components/customScaffold.dart';

class CompanyAboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      "About Us",
      'How it started',
      AboutUsContent(),
      2,
    );
  }
}

class AboutUsContent extends StatelessWidget {
  customContactInformationPill(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(icon),
          SizedBox(width: 10),
          Text(title),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("images/appLogo.png"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      thickness: 2,
                      width: 40,
                      color: Colors.grey[600],
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("images/companyLogoBlack.png"),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Text(
                appBriefLong,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GET IN TOUCH
            listViewHeader('Contacts', context),
            customListTile(
              "Phone Number",
              companyNumber,
              FluentIcons.call_24_filled,
              FluentIcons.open_24_filled,
              Colors.teal,
              () => launchContactNumber(companyNumber),
            ),
            customListTile(
              "Email",
              companyFeedbackEmail,
              FluentIcons.mail_24_filled,
              FluentIcons.open_24_filled,
              Colors.orange,
              () => launchEmail(companyFeedbackEmail, "Feedback"),
            ),
            customListTile(
              "Company Website",
              comapanyName,
              FluentIcons.web_asset_24_filled,
              FluentIcons.open_24_filled,
              Colors.red,
              () => launchURL(companyWebsite),
            ),

            // CREDITS
            listViewHeader('Team', context),
            customListTile(
              "Developer",
              companyDeveloper,
              FluentIcons.person_24_filled,
              null,
              Colors.blueGrey,
              null,
            ),

            // DATA SOURCE
            listViewHeader('Sources', context),
            customListTile(
              'LTA DataMall',
              "API",
              FluentIcons.code_24_filled,
              FluentIcons.open_24_filled,
              Colors.brown,
              () => launchURL(ltaDataMallURL),
            ),
          ],
        ),
      ],
    );
  }
}
