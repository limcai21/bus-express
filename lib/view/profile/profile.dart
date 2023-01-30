import 'dart:convert';

import 'package:bus_express/model/api.dart';
import 'package:bus_express/model/custom_icons_icons.dart';
import 'package:bus_express/view/components/alert/alertLoading.dart';
import 'package:bus_express/view/components/button/textButton.dart';
import 'package:flutter/material.dart';
import 'package:bus_express/model/constants.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/components/alert/alertDialog.dart';
import 'package:bus_express/view/login.dart';
import 'package:bus_express/view/profile/company/aboutUs.dart';
import 'package:bus_express/view/profile/profileEdit.dart';
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
    setState(() {
      isUserLogin = false;
      currentLoginUsername = "";
      userContactNumber = '';
    });
  }

  logoutAccount() {
    setState(() {
      isUserLogin = false;
      currentLoginUsername = "";
      userContactNumber = '';
    });
  }

  refreshEmailAddressAndContactNumber() {
    if (currentLoginUsername.isNotEmpty) {
      Map<String, dynamic> userData =
          jsonDecode(prefs.getString(currentLoginUsername));
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
        listViewHeader('Account', context),

        if (!isUserLogin) ...[
          customListTile(
            "Login",
            "View all your favourites",
            CustomIcons.profile_filled,
            CustomIcons.chevron_right,
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
            CustomIcons.sign_up,
            CustomIcons.chevron_right,
            Colors.teal,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUp()),
            ),
            iconSize: iconSize,
            borderRadius: borderRadius,
            padding: padding,
          ),
        ] else ...[
          customListTile(
            "Email",
            "Update your email",
            CustomIcons.mail,
            CustomIcons.chevron_right,
            Colors.orange,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileEditForm(
                  'Email',
                  'Update your Email',
                  0,
                ),
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
            "Password",
            "Change your password",
            CustomIcons.password,
            CustomIcons.chevron_right,
            Colors.brown,
            () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditForm(
                    'Password',
                    'Change your Password',
                    1,
                  ),
                ),
              );

              if (result == true) {
                logoutAccount();
              }
            },
            iconSize: iconSize,
            borderRadius: borderRadius,
            padding: padding,
          ),
          customListTile(
            "Contact Number",
            "Update your Contact Number",
            CustomIcons.phone,
            CustomIcons.chevron_right,
            Colors.teal,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileEditForm(
                  'Contact Number',
                  'Update your Contact Number',
                  2,
                ),
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
            "Delete Account",
            "You can't undo this action",
            CustomIcons.delete,
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
            CustomIcons.logout,
            null,
            Colors.indigo,
            () {
              alertDialog(
                logoutTitle,
                logoutDescription,
                context,
                closeTitle: "Cancel",
                additionalActions: customTextButton(context, "Logout", () {
                  logoutAccount();
                  Navigator.pop(context);
                }),
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
          CustomIcons.near_me,
          CustomIcons.open_in,
          Colors.blueGrey,
          () => OpenSettings.openLocationSetting(),
          iconSize: iconSize,
          borderRadius: borderRadius,
          padding: padding,
        ),
        customListTile(
          "Refetch Data",
          "Refetch missing Bus Stops, Service & Route",
          CustomIcons.refresh,
          null,
          Colors.pink,
          () async {
            loadingAlert(context, title: "Refetching Data..");
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
          CustomIcons.information_circle,
          CustomIcons.chevron_right,
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
          CustomIcons.feedback,
          CustomIcons.open_in,
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
