import 'package:bus_express/custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:bus_express/model/constants.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/components/alertDialog.dart';
import 'package:bus_express/view/login.dart';
import 'package:bus_express/view/profile/company/aboutUs.dart';
import 'package:bus_express/view/profile/profileEdit.dart';
import 'package:bus_express/view/signup.dart';
import 'company/components/contactFunctions.dart';
import 'components/leadingIcon.dart';
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
    var bgColor = Theme.of(context).primaryColor;
    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: UserAccountsDrawerHeader(
        decoration: BoxDecoration(color: bgColor),
        accountName: Text(isUserLogin ? currentLoginUsername : "Guest"),
        accountEmail: Text(
          isUserLogin
              ? userEmail + "  •  +65 " + userContactNumber
              : "Login to view your profile",
        ),
        currentAccountPicture: isUserLogin
            ? CircleAvatar(
                backgroundImage: AssetImage("images/defaultProfilePic.png"),
              )
            : null,
        margin: const EdgeInsets.all(0),
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
            leading: leadingIcon(CustomIcons.login, Colors.orange),
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
            trailing: Icon(CustomIcons.chevron_right, size: 18),
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

        if (isUserLogin) listViewHeader('Others', context),
        if (isUserLogin)
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text("You can always sign back in"),
            trailing: Icon(CustomIcons.chevron_right, size: 18),
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
