import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/components/customScaffold.dart';
import 'package:bus_express/view/profile/account_settings/profileEdit.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettings extends StatelessWidget {
  final String title;
  final String subtitle;
  AccountSettings(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(title, subtitle, AccountSettingsBody(), 2);
  }
}

class AccountSettingsBody extends StatefulWidget {
  @override
  State<AccountSettingsBody> createState() => _AccountSettingsBodyState();
}

class _AccountSettingsBodyState extends State<AccountSettingsBody> {
  double iconSize = 24;
  double borderRadius = 100;
  double padding = 10;

  logoutAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("loginUser");

    setState(() {
      isUserLogin = false;
      currentLoginUsername = "";
      userContactNumber = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      physics: BouncingScrollPhysics(),
      children: [
        listViewHeader('Account', context),
        customListTile(
          "Username",
          "Change your username",
          FluentIcons.person_24_filled,
          FluentIcons.chevron_right_24_filled,
          Colors.orange,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileEditForm(
                'Username',
                'Change your Username',
                3,
              ),
            ),
          ),
          iconSize: iconSize,
          borderRadius: borderRadius,
          padding: padding,
        ),
        customListTile(
          "Password",
          "Change your password",
          FluentIcons.password_24_filled,
          FluentIcons.chevron_right_24_filled,
          Colors.brown,
          () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileEditForm(
                  'Password',
                  'Change your Password',
                  1,
                ),
              ),
            );
          },
          iconSize: iconSize,
          borderRadius: borderRadius,
          padding: padding,
        ),
        customListTile(
          "Email",
          "Update your email",
          FluentIcons.mail_24_filled,
          FluentIcons.chevron_right_24_filled,
          Colors.blue,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileEditForm(
                'Email',
                'Update your Email',
                0,
              ),
            ),
          ),
          iconSize: iconSize,
          borderRadius: borderRadius,
          padding: padding,
        ),
        customListTile(
          "Contact Number",
          "Update your Contact Number",
          FluentIcons.call_24_filled,
          FluentIcons.chevron_right_24_filled,
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
          ),
          iconSize: iconSize,
          borderRadius: borderRadius,
          padding: padding,
        ),
      ],
    );
  }
}
