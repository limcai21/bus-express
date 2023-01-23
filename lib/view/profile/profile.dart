import 'package:bus_express/model/api.dart';
import 'package:bus_express/model/custom_icons_icons.dart';
import 'package:bus_express/view/components/alert/alertLoading.dart';
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
import 'components/profileLeadingIcon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var prefs;
  var userEmail = '';
  var userContactNumber = '';

  deleteAccount() {
    prefs.remove(currentLoginUsername);
    prefs.remove(currentLoginUsername + "FavList");
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
      var userData = prefs.getStringList(currentLoginUsername);
      userEmail = userData[1];
      userContactNumber = userData[2];
    }
  }

  customListTile(String title, String subtitle, IconData icon,
      MaterialColor bgColor, Widget route) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(subtitle),
      trailing: Icon(CustomIcons.chevron_right, size: 18),
      leading: leadingIcon(icon, bgColor),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => route),
      ),
    );
  }

  profileCard() {
    Color bgColor = Colors.grey[200];
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
      physics: BouncingScrollPhysics(),
      children: [
        // PROFILE CARD
        profileCard(),

        // SETTING AREA
        listViewHeader('Account', context),

        // USER NOT LOGIN
        if (!isUserLogin)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: Text(
              'Login',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text('View all your favourites'),
            trailing: Icon(CustomIcons.chevron_right, size: 18),
            leading: leadingIcon(CustomIcons.profile_filled, Colors.orange),
            onTap: () => Navigator.push(
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
          ),
        if (!isUserLogin)
          customListTile(
            'Sign Up',
            'Favourites all your bus stop',
            CustomIcons.sign_up,
            Colors.teal,
            SignUp(),
          ),

        // USER LOGIN
        if (isUserLogin)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text('Update your email'),
            trailing: Icon(CustomIcons.chevron_right, size: 18),
            leading: leadingIcon(CustomIcons.mail, Colors.orange),
            onTap: () => Navigator.push(
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
          ),

        if (isUserLogin)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: Text(
              'Password',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text("Change your password"),
            trailing: Icon(CustomIcons.chevron_right, size: 18),
            leading: leadingIcon(CustomIcons.password, Colors.brown),
            onTap: () async {
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
          ),
        if (isUserLogin)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: Text(
              'Contact Number',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text('Update your Contact Number'),
            trailing: Icon(CustomIcons.chevron_right, size: 18),
            leading: leadingIcon(CustomIcons.phone, Colors.teal),
            onTap: () => Navigator.push(
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
          ),

        if (isUserLogin)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: Text(
              'Delete Account',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text("You can't undo this action"),
            leading: leadingIcon(CustomIcons.delete, Colors.red),
            onTap: () {
              alertDialog(
                deleteAccountTitle,
                deleteAccountDescription,
                context,
                closeTitle: "Cancel",
                additionalActions: TextButton(
                  onPressed: () {
                    deleteAccount();
                    Navigator.pop(context);
                    var feedbackBtn = TextButton(
                      onPressed: () =>
                          launchEmail(companyFeedbackEmail, 'Feedback'),
                      child: Text(
                        "FEEDBACK",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    );
                    alertDialog(
                      "Account Deleted",
                      "Tell us what we can do better in the feedback form if you don't mind",
                      context,
                      additionalActions: feedbackBtn,
                    );
                  },
                  child: Text(
                    "DELETE",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              );
            },
          ),

        if (isUserLogin)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text("You can always sign back in"),
            leading: leadingIcon(CustomIcons.logout, Colors.indigo),
            onTap: () {
              alertDialog(
                logoutTitle,
                logoutDescription,
                context,
                closeTitle: "Cancel",
                additionalActions: TextButton(
                  onPressed: () {
                    logoutAccount();
                    Navigator.pop(context);
                  },
                  child: Text(
                    "LOGOUT",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              );
            },
          ),

        listViewHeader('Others', context),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            'Location Service',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text('Enable your location service'),
          trailing: Icon(CustomIcons.open_in, size: 16),
          leading: leadingIcon(CustomIcons.near_me, Colors.blueGrey),
          onTap: () => OpenSettings.openLocationSetting(),
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            'Refetch Data',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text("Refetch missing Bus Stops or Bus Service"),
          leading: leadingIcon(CustomIcons.refresh, Colors.pink),
          onTap: () async {
            loadingAlert(context);
            await BusStop().all();
            await Bus().all();
            Navigator.pop(context);
            alertDialog(refetchDataTitle, refetchDataDescription, context);
          },
        ),

        listViewHeader('Company', context),
        customListTile(
          'About Us',
          'Find out more about us',
          CustomIcons.information_circle,
          Colors.green,
          CompanyAboutUs(),
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            'Feedback',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text('Tell us if you encounter something odd'),
          trailing: Icon(CustomIcons.open_in, size: 16),
          leading: leadingIcon(CustomIcons.feedback, Colors.purple),
          onTap: () => launchEmail(companyFeedbackEmail, 'Feedback'),
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
