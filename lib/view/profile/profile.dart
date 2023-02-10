import 'dart:convert';

import 'package:bus_express/model/api.dart';
import 'package:bus_express/view/components/alert/alertLoading.dart';
import 'package:bus_express/view/components/button/textButton.dart';
import 'package:bus_express/view/profile/myInfo.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:bus_express/model/constants.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/components/alert/alertDialog.dart';
import 'package:bus_express/view/login.dart';
import 'package:bus_express/view/profile/company/aboutUs.dart';
import 'package:bus_express/view/signup.dart';
import 'package:open_settings/open_settings.dart';
import 'company/components/contactFunctions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var prefs;
  var userEmail = '';
  var userContactNumber = '';
  double iconSize = 24;
  double borderRadius = 100;
  double padding = 10;

  deleteAccount() async {
    await prefs.remove(currentLoginUsername);
    await prefs.remove("loginUser");
    setState(() {
      isUserLogin = false;
      currentLoginUsername = "";
      userContactNumber = '';
    });
  }

  logoutAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("loginUser");

    setState(() {
      isUserLogin = false;
      currentLoginUsername = "";
      userContactNumber = '';
    });
  }

  refreshEmailAddressAndContactNumber() {
    if (currentLoginUsername.isNotEmpty) {
      Map<String, dynamic> userData = jsonDecode(
        prefs.getString(currentLoginUsername),
      );
      userEmail = userData["email"];
      userContactNumber = userData["contactNumber"];
    }
  }

  profileCard() {
    Color bgColor = Color.lerp(Colors.white, primaryColor, 0.125);
    String accountName = isUserLogin ? currentLoginUsername : "Guest";
    String accountSubtitle = isUserLogin
        ? userEmail + "  •  +65 " + userContactNumber
        : "Login to view your profile";
    double paddingTopBottom = 30.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: paddingTopBottom,
      ),
      color: bgColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                accountName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Theme.of(context).textTheme.headline6.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                accountSubtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: Theme.of(context).textTheme.bodyText1.fontSize,
                ),
              ),
            ],
          ),
          if (isUserLogin) ...[
            SizedBox(width: 10),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage("images/defaultProfilePic.png"),
            ),
          ]
        ],
      ),
    );
  }

  settingSection() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      physics: BouncingScrollPhysics(),
      children: [
        // PROFILE CARD
        profileCard(),

        // SETTING AREA
        listViewHeader('Settings', context),

        if (!isUserLogin) ...[
          customListTile(
            "Login",
            "View all your favourites",
            FluentIcons.person_28_filled,
            FluentIcons.chevron_right_24_filled,
            Colors.orange,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Login(),
              ),
            ).then((value) {
              setState(() {
                isUserLogin = isUserLogin;
                refreshEmailAddressAndContactNumber();
              });
            }),
            iconSize: iconSize,
            borderRadius: borderRadius,
            padding: padding,
          ),
          customListTile(
            'Sign Up',
            'Favourites all your bus stop',
            FluentIcons.person_add_24_filled,
            FluentIcons.chevron_right_24_filled,
            Colors.teal,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUp(),
              ),
            ),
            iconSize: iconSize,
            borderRadius: borderRadius,
            padding: padding,
          ),
        ] else ...[
          customListTile(
            "My Info",
            "Username, Password, Email and more",
            FluentIcons.contact_card_24_filled,
            FluentIcons.chevron_right_24_filled,
            Colors.indigo,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountSettings(
                  'My Info',
                  'Username, Password, Email & Contact Number',
                ),
              ),
            ).then((value) {
              setState(() {
                isUserLogin = isUserLogin;
                refreshEmailAddressAndContactNumber();

                if (!isUserLogin) {
                  logoutAccount();
                }
              });
            }),
            iconSize: iconSize,
            borderRadius: borderRadius,
            padding: padding,
          ),
          customListTile(
            "Delete Account",
            "You can't undo this action",
            FluentIcons.delete_24_filled,
            null,
            Colors.red,
            () {
              TextButton textButton = customTextButton(
                context,
                "Delete",
                () async {
                  await deleteAccount();
                  Navigator.pop(context);
                  alertDialog(
                    accountDeletedTitle,
                    accountDeletedDescription,
                    context,
                    additionalActions: feedbackTextButton("Feedback", context),
                  );
                },
              );
              alertDialog(
                deleteAccountTitle,
                deleteAccountDescription,
                context,
                closeTitle: "Cancel",
                additionalActions: textButton,
              );
            },
            iconSize: iconSize,
            borderRadius: borderRadius,
            padding: padding,
          ),
          customListTile(
            "Logout",
            "You can always sign back in",
            FluentIcons.sign_out_24_filled,
            null,
            Colors.orange,
            () {
              alertDialog(
                logoutTitle,
                logoutDescription,
                context,
                closeTitle: "Cancel",
                additionalActions: customTextButton(
                  context,
                  "Logout",
                  () async {
                    await logoutAccount();
                    Navigator.pop(context);
                  },
                ),
              );
            },
            iconSize: iconSize,
            borderRadius: borderRadius,
            padding: padding,
          ),
        ],

        listViewHeader('Others', context),
        customListTile(
          "Location Service",
          "Enable your location service",
          FluentIcons.cursor_24_filled,
          FluentIcons.open_24_filled,
          Colors.blueGrey,
          () => OpenSettings.openLocationSetting(),
          iconSize: iconSize,
          borderRadius: borderRadius,
          padding: padding,
          rotate: true,
        ),
        customListTile(
          "Refetch Data",
          "Refetch missing Bus Stops, Service & Route",
          FluentIcons.arrow_clockwise_24_filled,
          null,
          Colors.brown,
          () async {
            loadingAlert(context, title: "Refetching Data");
            await Bus().all();
            print("done with bus service");
            await BusStop().all();
            print("done with bus stop");
            await Bus().route();
            print("done with bus route");
            Navigator.pop(context);
            alertDialog(refetchDataTitle, refetchDataDescription, context);
          },
          iconSize: iconSize,
          borderRadius: borderRadius,
          padding: padding,
        ),

        listViewHeader('Company', context),
        customListTile(
          'About Us',
          'Find out more about us',
          FluentIcons.info_24_filled,
          FluentIcons.chevron_right_24_filled,
          Colors.green,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CompanyAboutUs()),
          ),
          iconSize: iconSize,
          borderRadius: borderRadius,
          padding: padding,
        ),
        customListTile(
          'Feedback',
          'Tell us if you encounter something odd',
          FluentIcons.person_feedback_24_filled,
          FluentIcons.open_24_filled,
          Colors.purple,
          () => launchEmail(companyFeedbackEmail, 'Feedback'),
          iconSize: iconSize,
          borderRadius: borderRadius,
          padding: padding,
        ),
      ],
    );
  }

  loadData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      refreshEmailAddressAndContactNumber();
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return settingSection();
  }
}
