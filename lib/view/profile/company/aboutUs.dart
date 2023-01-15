import 'package:bus_express/model/constants.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/profile/company/components/contactFunctions.dart';
import 'package:flutter/material.dart';
import 'package:bus_express/view/components/customScaffold.dart';

class CompanyAboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      "About Us",
      'How it started',
      Expanded(child: AboutUsContent()),
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
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        //   child: Text(
        //     contactUsActionLines,
        //     style: TextStyle(fontSize: 16),
        //   ),
        // ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GET IN TOUCH
            listViewHeader('Contacts', context),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: dataTile(Icons.phone_rounded, Colors.teal),
              title: Text(companyNumber),
              trailing: Icon(Icons.open_in_new_rounded, size: 16),
              subtitle: Text("Phone Number"),
              onTap: () => launchContactNumber(companyNumber),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: dataTile(Icons.email_rounded, Colors.orange),
              title: Text(companyFeedbackEmail),
              trailing: Icon(Icons.open_in_new_rounded, size: 16),
              subtitle: Text("Email"),
              onTap: () => launchEmail(companyFeedbackEmail, "Feedback"),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: dataTile(Icons.web_asset_rounded, Colors.red),
              title: Text(comapanyName),
              subtitle: Text("Company Website"),
              trailing: Icon(Icons.open_in_new_rounded, size: 16),
              onTap: () => launchURL(companyWebsite),
            ),

            // CREDITS
            listViewHeader('Team', context),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: dataTile(Icons.code_rounded, Colors.blueGrey),
              title: Text(companyDeveloper),
              subtitle: Text("Developer"),
            ),

            // DATA SOURCE
            listViewHeader('Sources', context),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: dataTile(Icons.api_rounded, Colors.brown),
              title: Text('LTA DataMall'),
              subtitle: Text("API"),
              trailing: Icon(Icons.open_in_new_rounded, size: 16),
              onTap: () => launchURL(ltaDataMallURL),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: dataTile(Icons.api_rounded, Colors.deepPurple),
              title: Text("Tourism Information & Services Hub"),
              subtitle: Text("API"),
              trailing: Icon(Icons.open_in_new_rounded, size: 16),
              onTap: () => launchURL(stbAPIURL),
            ),
          ],
        ),
      ],
    );
  }
}
