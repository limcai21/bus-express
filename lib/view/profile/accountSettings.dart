import 'package:bus_express/model/custom_icons_icons.dart';
import 'package:bus_express/model/global.dart';
import 'package:bus_express/view/components/customScaffold.dart';
import 'package:bus_express/view/profile/profileEdit.dart';
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
              // refreshEmailAddressAndContactNumber();
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
          "Email",
          "Update your email",
          CustomIcons.mail,
          CustomIcons.chevron_right,
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
          ).then((value) {
            setState(() {
              isUserLogin = isUserLogin;
            });
          }),
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
          ),
          iconSize: iconSize,
          borderRadius: borderRadius,
          padding: padding,
        ),
      ],
    );
  }
}
