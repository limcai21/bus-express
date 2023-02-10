import 'package:bus_express/view/profile/account_settings/changeContactNumber.dart';
import 'package:bus_express/view/profile/account_settings/changeEmail.dart';
import 'package:bus_express/view/profile/account_settings/changePassword.dart';
import 'package:bus_express/view/profile/account_settings/changeUsername.dart';
import 'package:bus_express/view/components/customScaffold.dart';
import 'package:flutter/material.dart';

class ProfileEditForm extends StatelessWidget {
  final String title;
  final String subtitle;
  final int index;
  ProfileEditForm(this.title, this.subtitle, this.index);

  @override
  Widget build(BuildContext context) {
    List pages = [
      ChangeEmail(),
      ChangePassword(),
      ChangeContactNumber(),
      ChangeUsername(),
    ];

    return CustomScaffold(
      title,
      subtitle,
      Container(
        child: SingleChildScrollView(
          child: pages[index],
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          physics: BouncingScrollPhysics(),
        ),
      ),
      2,
    );
  }
}
